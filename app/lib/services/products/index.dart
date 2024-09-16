import 'dart:convert';

import 'package:e_commerce/constants/global_variables.dart';
import 'package:e_commerce/models/product.dart';
import 'package:http/http.dart';

class ProductService {
  // Future<String> createAssembleRequest(AssembleRequest assembleRequest) async {
  //   Uri uri = apiUri('requests/assemble');
  //   // final String token = await getStoredToken();
  //   final response = await http.post(
  //     uri,
  //     headers: headers(token),
  //     body: json.encode(assembleRequest.toJson()),
  //   );
  //   final Map<String, dynamic> body = json.decode(response.body);

  //   try {
  //     if (body["success"]) {
  //       final String msg = body["data"]["message"];
  //       return msg;
  //     } else {
  //       final String msg = body["message"];
  //       return msg;
  //     }
  //   } catch (e) {
  //     return 'تمت العملية';
  //   }
  // }

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
}
