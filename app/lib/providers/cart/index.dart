import 'dart:convert';
import 'package:e_commerce/common/widgets/utils.dart';
import 'package:e_commerce/constants/global_variables.dart';
import 'package:e_commerce/models/cartItem.dart';
import 'package:e_commerce/models/sku.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _cart = [];

  bool _isLoading = false;
  bool get isloading => _isLoading;

  /// [_isCartValid] cart valid or not if false you cann't proceed to pay
  bool _isCartValid = false;

  bool get isCartValid => _isCartValid;

  /// [checkIsCartValid] check all the skus if they valid or not
  void checkIsCartValid(List<CartItem?> cart) {
    _isCartValid = false;
    for (final product in cart) {
      // if (product!.notVaildAnyMore || product.state != ProductState.Working) {
      if (product!.notVaildAnyMore) {
        _isCartValid = false;
        break;
      }
    }
    _isCartValid = true;
  }

  /// [cart] get the cart itself
  List<CartItem> get cart => _cart;

  /// [qty] get all the cart items qty
  int get qty {
    return _cart.isNotEmpty
        ? _cart.fold(
            0,
            (previousValue, element) => previousValue + element.qty,
          )
        : 0;
  }

  /// [pureTotalPrice] get total price of cart without the shipping price
  /// [return] [double] int
  double get pureTotalPrice {
    double sum = 0;
    // ignore: unnecessary_null_comparison
    if (_cart == null || _cart.isEmpty) {
      return 0;
    } else {
      for (final CartItem cartItem in _cart) {
        sum += cartItem.price * cartItem.qty;
      }
    }
    return sum;
  }

  ///  [fetchAtFirst] fetch the data at initialization the app
  Future<void> fetchAtFirst() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartJson = prefs.getString('cart');
    // if no data stored
    if (cartJson != null && cartJson.isNotEmpty) {
      //! ### add api call to check products found or not in company
      List decodedCartItems = json.decode(cartJson);
      List<CartItem> listOfCartItems =
          decodedCartItems.map((e) => CartItem.fromJson(e)).toList();
      // set the list of cart founded
      _cart = listOfCartItems;
      notifyListeners();
    }
  }

  /// [returnCurrentCartItem]  check if the items added or not
  /// * if added it will return it
  /// * if nah it will return null
  /// * render the addToCart Widget up on this condition
  CartItem? returnCurrentCartItem(String skuid) {
    CartItem? currentCartItem;

    for (final cartItem in _cart) {
      if (cartItem.skuId == skuid) {
        currentCartItem = cartItem;
      }
    }
    return currentCartItem;
  }

  /// [removeAllFromCart] clear the cart
  Future<void> removeAllFromCart() async {
    _cart.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cart', '');
    notifyListeners();
  }

  /// [addNewToCart] add new [CartItem] to cart
  Future<void> addNewToCart(CartItem cartItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _cart.add(cartItem);
    notifyListeners();
    String cartList = json.encode(_cart);
    await prefs.setString('cart', cartList);
  }

  /// [addQtyToExistedCartItem]
  /// * find the cart item
  /// * check if qty == [maxValue]
  /// * if yes : return
  /// * add quantity
  ///
  Future<void> addQtyToExistedCartItem(
    String skuId,
    int? maxValue,
    BuildContext context,
  ) async {
    for (final cartItem in _cart) {
      if (cartItem.skuId == skuId) {
        cartItem.incrementQty(maxValue);
        if (maxValue != null) {
          cartItem.setMaxQty(maxValue);
          //* if qty == max value show snack bar
          if (cartItem.qty == maxValue) {
            showSnackBar(context, 'لا يمكنك اضافة المزيد من هذا المنتج');
          }
        }
        notifyListeners();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String cartList = json.encode(_cart);
        await prefs.setString('cart', cartList);
      }
    }
  }

  void removeOne(String skuId, int? maxValue) async {
    for (var i = 0; i < _cart.length; i++) {
      final CartItem cartItem = _cart[i];
      if (cartItem.skuId == skuId) {
        if (cartItem.qty <= 1) {
          _cart.removeAt(i);
        } else {
          cartItem.decrementQty();
        }
        if (maxValue != null) {
          cartItem.setMaxQty(maxValue);
        }
        notifyListeners();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String cartList = json.encode(_cart);
        await prefs.setString('cart', cartList);
      }
    }
  }

  void deleteCompletely(String skuId, int? maxValue) async {
    for (var i = 0; i < _cart.length; i++) {
      final CartItem cartItem = _cart[i];
      if (cartItem.skuId == skuId) {
        _cart.removeAt(i);
        if (maxValue != null) {
          cartItem.setMaxQty(maxValue);
        }
        notifyListeners();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String cartList = json.encode(_cart);
        await prefs.setString('cart', cartList);
      }
    }
  }

  Future<void> compareCart() async {
    _isLoading = true;
    notifyListeners();
    final skus = await bringInstance();
    if (skus == null) {
      // add snack bar to show couldn't compare cart
      return;
    } else {
      for (final product in _cart) {
        returnCartItemFromSku(product, skus);
      }
      checkIsCartValid(_cart);
    }
    _isLoading = false;
    notifyListeners();
  }

  void returnCartItemFromSku(CartItem cartItem, List<Sku> skus) {
    for (final sku in skus) {
      if (sku.id == cartItem.skuId) {
        cartItem.maxQty = sku.qty;
        cartItem.overQty = cartItem.qty > sku.qty ? true : false;
      }
    }
  }

  Future<List<Sku>?> bringInstance() async {
    Uri uri = apiUri('sku');
    final String token = await getStoredToken();
    final skusIDs = getCartItemsIds();
    final Map<String, List<String>> map = <String, List<String>>{
      "cart": skusIDs
    };

    final response = await http.post(
      uri,
      headers: headers(token),
      body: json.encode(map),
    );

    final Map<String, dynamic> body = json.decode(response.body);
    try {
      if (body["success"]) {
        final List<dynamic> dynamicSkus = body["data"]["cart"];
        final List<Sku> skus =
            dynamicSkus.map((sku) => Sku.fromJson(sku)).toList();
        return skus;
      } else {
        // final String msg = body["message"];
        return [];
      }
    } catch (e) {
      return null;
    }
  }

  List<String> getCartItemsIds() {
    List<String> IDs = [];
    for (final CartItem in _cart) {
      IDs.add(CartItem.skuId);
    }
    return IDs;
  }
}
