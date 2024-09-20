import 'dart:convert';
import 'package:e_commerce/common/widgets/utils.dart';
import 'package:e_commerce/constants/global_variables.dart';
import 'package:e_commerce/models/cartItem.dart';
import 'package:e_commerce/models/sku.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _cart = [];

  bool _isLoading = false;
  bool get isloading => _isLoading;

  /// [_isCartValid] cart valid or not if false you cann't proceed to pay
  bool _isCartValid = true;

  bool get isCartValid => _isCartValid;

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

  List<CartItem> validTheCartItems(
      List<String> ids, List<CartItem> allCartItems) {
    // Filter the classes to find those whose id is not in the ids list
    final notFoundCartItems = allCartItems
        .where((classInstance) => !ids.contains(classInstance.skuId))
        .toList();
    final cartItems = allCartItems
        .where((classInstance) => ids.contains(classInstance.skuId))
        .toList();
    for (final cartItem in notFoundCartItems) {
      cartItem.changeValidity(false);
    }
    return [
      ...cartItems,
      ...notFoundCartItems,
    ];
  }

  /// [clearCart] clear the cart
  Future<void> clearCart() async {
    _cart.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cart', '');
    notifyListeners();
    checkValidity();
  }

  /// [addNewToCart] add new [CartItem] to cart
  Future<void> addNewToCart(CartItem cartItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _cart.add(cartItem);
    notifyListeners();
    String cartList = json.encode(_cart);
    await prefs.setString('cart', cartList);
    checkValidity();
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
        cartItem.incrementQty();
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
    checkValidity();
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
    checkValidity();
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
    checkValidity();
  }

  Future<void> compareCart() async {
    _isLoading = true;
    notifyListeners();
    final skus = await bringTheSkus();
    for (final cartItem in _cart) {
      returnCartItemFromSku(cartItem, skus);
    }
    validTheCartItems(getCartItemsIds(), cart);
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

  void checkValidity() {
    for (final cartItem in _cart) {
      if (cartItem.notVaildAnyMore) {
        return;
      }
    }
    _isCartValid = true;
    notifyListeners();
  }

  Future<List<Sku>> bringTheSkus() async {
    Uri uri = apiUri('skus/cart/verify');
    final String token = await getStoredToken();
    final skusIDs = getCartItemsIds();
    final Map<String, List<String>> map = <String, List<String>>{
      "cart": skusIDs
    };

    final Response response = await http.post(
      uri,
      headers: headers(token),
      body: json.encode(map),
    );

    final Map<String, dynamic> body = json.decode(response.body);
    try {
      if (response.statusCode == 200) {
        final List<dynamic> dynamicSkus = body["data"];
        final List<Sku> skus =
            dynamicSkus.map((sku) => Sku.fromJson(sku)).toList();
        return skus;
      } else {
        // final String msg = body["message"];
        return [];
      }
    } catch (e) {
      return [];
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
