import 'package:e_commerce/constants/global_variables.dart';
import 'package:e_commerce/models/category.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/services/categories/index.dart';
import 'package:e_commerce/services/products/index.dart';
import 'package:flutter/cupertino.dart';
// import 'package:kraken_app/common/service/product.dart';
// import 'package:kraken_app/constants/global_variables.dart';
// import 'package:kraken_app/features/stores/services/index.dart';
// import 'package:kraken_app/models/category.dart';
// import 'package:kraken_app/models/product.dart';
// import 'package:kraken_app/models/store.dart';
// import 'package:kraken_app/services/category.dart';

enum Sort { asc, desc }

class CategoriesProvider extends ChangeNotifier {
  final CategoryService _categoryServices = CategoryService();
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _categoryServices.getCategories('');
      // ignore: unnecessary_null_comparison
      if (result != null) {
        _categories = result;
      }
    } catch (e) {
      _categories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

/// [ProductsProvider] The products will be showed in home page
class ProductsProvider extends ChangeNotifier {
  final ProductService _productServices = ProductService();
  List<Product> _products = [];

  /// all products type [Product]
  List<Product> get products => _products;

  bool _isLoading = false;

  /// [isLoading] get the loading state of the products in home page
  bool get isLoading => _isLoading;

  /// items will be skipped
  int skip = 0;
  void addSkip() => skip++;
  void refreshSkip() => skip = 0;

  /// onEnd
  bool _onEnd = false;
  bool get onEnd => _onEnd;
  bool setOnEnd(bool value) => _onEnd = value;
  void resetOnEnd() => _onEnd = false;

  /// [filterQuery] get the filter query
  /// #### return String
  String get filterQuery =>
      'take=${GlobalVariables.pageSize}&views=${viewsFilter.name}&price=${priceFilter.name}&min_price=$minPrice${maxPrice != null ? '&max_price=$maxPrice' : ''}';

  /// fetch the products and pass args:
  /// ```dart
  /// arg => optional
  /// await fetchProducts('take=${GlobalVariables.pageSize}');
  /// ```
  Future<void> fetchProducts() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _productServices.getProducts(
        filterQuery,
      );
      // ignore: unnecessary_null_comparison
      if (result != null) {
        _products = result;
      }
    } catch (e) {
      _products = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// [fetchProductsOnScroll] fetch products on scroll
  Future<void> fetchProductsOnScroll(String? query) async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    notifyListeners();

    try {
      /// add 1 to skip and then multiply it with page Size to skip
      /// [addSkip()] => skip ++
      /// [skip] multiply it by [pageSize]
      /// ```dart
      /// // if we have [skip] 4 and [skipPage] 50 then 4 * 50 = 200; it will skip 200 product and grab 50 after 200 in order
      /// var result = await _productServices.getProducts(
      ///  '$filterQuery&$query&page=${skip * GlobalVariables.pageSize}',
      /// );
      /// ```
      addSkip();
      final result = await _productServices.getProducts(
        '$filterQuery&$query&page=${skip * GlobalVariables.pageSize}',
      );

      if (result.length < GlobalVariables.pageSize) {
        // if the result is less than page size then no more results so we should [onEnd] to true and replace more btn with end widget
        setOnEnd(true);
        _products += result;
      } else {
        setOnEnd(false);
        _products += result;
      }
    } catch (e) {
      _products = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // filters
  /// sort the createdAt
  Sort _timeSort = Sort.desc;
  Sort get timeSort => _timeSort;
  void setTimeSort(Sort sort) {
    _timeSort = sort;
    notifyListeners();
  }

  /// filter the views
  Sort _viewsFilter = Sort.desc;
  Sort get viewsFilter => _viewsFilter;
  void setViewsFilter(Sort filter) {
    _viewsFilter = filter;
    notifyListeners();
  }

  /// sort the price
  Sort _priceFilter = Sort.desc;
  Sort get priceFilter => _priceFilter;
  void setPriceFilter(Sort filter) {
    _priceFilter = filter;
    notifyListeners();
  }

  /// filter the products with range price
  // min price
  double _minPrice = 0;
  double get minPrice => _minPrice;
  void setMinPrice(double minPrice) {
    _minPrice = minPrice;
  }

  // max price
  double? _maxPrice;
  double? get maxPrice => _maxPrice;
  void setMaxPrice(double? maxPrice) {
    _maxPrice = maxPrice;
  }

  /// grab [filterQuery] and then apply it and fetch products [setFilters]
  Future<void> setFilters(double? maxPrice, double? minPrice) async {
    setMinPrice(maxPrice ?? 0);
    setMaxPrice(maxPrice);
    notifyListeners();
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _productServices.getProducts(
        //&sort=${_timeSort.name}
        // ignore: unnecessary_null_comparison
        'take=${GlobalVariables.pageSize}&views=${viewsFilter.name}&price=${priceFilter.name}&min_price=$minPrice${maxPrice != null ? '&max_price=$maxPrice' : ''}',
      );
      // ignore: unnecessary_null_comparison
      if (result != null) {
        _products = result;
      }
    } catch (e) {
      _products = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ``` reset all the filters and notify the listeners and then fetch the products again.
  Future<void> resetFilters() async {
    _timeSort = Sort.desc;
    _viewsFilter = Sort.desc;
    _priceFilter = Sort.desc;
    _minPrice = 0;
    resetOnEnd();
    refreshSkip();
    notifyListeners();
    _products = [];
    await fetchProducts();
  }
}
