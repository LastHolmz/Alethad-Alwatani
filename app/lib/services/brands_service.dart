import 'dart:convert';

import 'package:e_commerce/constants/global_variables.dart';
import 'package:e_commerce/models/brand.dart';
import 'package:http/http.dart';

class BrandsService {
  Future<List<Brand>> getBrands(String? params) async {
    try {
      final Uri uri = apiUri('brands');
      final token = await getStoredToken();
      final response = await get(uri, headers: headers(token));
      if (response.statusCode != 200) {
        return [];
      } else {
        final Map<String, dynamic> body = json.decode(response.body);
        final List<dynamic> brandsData = body["data"];

        final List<Brand> brands =
            brandsData.map<Brand>((brand) => Brand.fromJson(brand)).toList();
        ;

        return brands;
      }
    } catch (e) {
      return [];
    }
  }

  Future<Brand?> getBrand(String id) async {
    try {
      final Uri uri = apiUri('brands/$id');
      final token = await getStoredToken();
      final response = await get(uri, headers: headers(token));
      if (response.statusCode != 200) {
        return null;
      } else {
        final Map<String, dynamic> body = json.decode(response.body);
        final dynamic brandData = body["data"];

        final Brand brand = Brand.fromJson(brandData);
        ;

        return brand;
      }
    } catch (e) {
      return null;
    }
  }
}
