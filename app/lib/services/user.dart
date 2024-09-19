import 'dart:convert';

import 'package:e_commerce/common/widgets/utils.dart';
import 'package:e_commerce/constants/global_variables.dart';
import 'package:e_commerce/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UserService {
  Future<User?> register(User user, BuildContext context) async {
    Uri uri = apiUri('auth/register');
    final token = await getStoredToken();
    // user in json format
    String userJson = json.encode(user.toJson());

    final response = await post(
      uri,
      headers: headers(token),
      body: userJson,
    );
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> body = json.decode(response.body);
        final dynamic userData = body["data"];
        final User newUser = User.fromJson(userData);
        return newUser;
      }
      if (context.mounted) {
        showSnackBar(context, json.decode(response.body)["message"]);
      }
      return null;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, json.decode(response.body)["message"]);
      }
      return null;
    }
  }
}
