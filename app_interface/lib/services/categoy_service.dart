import 'dart:convert';

import 'package:e_commerce/constants/global_variables.dart';
import 'package:e_commerce/models/category.dart';
import 'package:http/http.dart';

class CategoryService {
  Future<List<Category>> getCategories(String? params) async {
    try {
      final Uri uri = apiUri('categories');
      final token = await getStoredToken();
      final response = await get(uri, headers: headers(token));
      if (response.statusCode != 200) {
        return [];
      } else {
        final Map<String, dynamic> body = json.decode(response.body);
        final List<dynamic> categorysData = body["data"];

        final List<Category> categories = categorysData
            .map<Category>((category) => Category.fromJson(category))
            .toList();
        ;

        return categories;
      }
    } catch (e) {
      return [];
    }
  }

  Future<Category?> getCategory(String id) async {
    try {
      final Uri uri = apiUri('categories/$id');
      final token = await getStoredToken();
      final response = await get(uri, headers: headers(token));
      if (response.statusCode != 200) {
        return null;
      } else {
        final Map<String, dynamic> body = json.decode(response.body);
        final dynamic categoryData = body["data"];

        final Category category = Category.fromJson(categoryData);
        ;

        return category;
      }
    } catch (e) {
      return null;
    }
  }
}
