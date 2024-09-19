import 'dart:convert';

import 'package:e_commerce/constants/global_variables.dart';
import 'package:e_commerce/models/product.dart';
import 'package:http/http.dart';

class ProductService {
  Future<List<Product>> getProducts(String? params) async {
    try {
      final Uri uri = apiUri('products');
      final token = await getStoredToken();
      final response = await get(uri, headers: headers(token));
      if (response.statusCode != 200) {
        return [];
      } else {
        final Map<String, dynamic> body = json.decode(response.body);
        final List<dynamic> productsData = body["data"];
        final List<Product> products = productsData
            .map<Product>((product) => Product.fromJson(product))
            .toList();
        ;
        return products;
      }
    } catch (e) {
      return [];
    }
  }

  Future<Product?> getProductById(String id) async {
    try {
      final Uri uri = apiUri('products/$id');
      final token = await getStoredToken();
      final response = await get(uri, headers: headers(token));
      if (response.statusCode != 200) {
        return null;
      } else {
        final Map<String, dynamic> body = json.decode(response.body);
        final dynamic productsData = body["data"];
        final Product product = Product.fromJson(productsData);
        return product;
      }
    } catch (e) {
      return null;
    }
  }
}
