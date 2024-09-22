import 'dart:convert';
import 'package:e_commerce/constants/global_variables.dart';
import 'package:e_commerce/models/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;
  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void setLodding(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkUser(BuildContext context, [String? defaultToken]) async {
    _isLoading = true;
    notifyListeners();

    final String token = await getStoredToken();

    Uri uri = apiUri(
        'auth/check-token/${defaultToken != null ? defaultToken : token}');

    http.Response res = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (res.statusCode == 200) {
      Map<String, dynamic> data = await json.decode(res.body);
      dynamic userData = data["data"];
      _user = User.fromJson(userData);
      _isLoggedIn = true;
      _isLoading = false;
      await updateToken(user?.token ?? "");
      context.push('/');
    } else {
      setUser(null);
      _isLoggedIn = false;
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    _isLoggedIn = false;
    _isLoading = true;
    notifyListeners();

    await updateToken("");

    _isLoading = false;

    notifyListeners();

    // if (!context.mounted) {
    //   return;
    // }
    // context.push('/login');
  }

  Future<void> updateToken(String? token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token ?? '');
  }

  bool renderToStatus(List<UserStatus> allowedStatus, UserStatus? userStatus) {
    if (userStatus == null) {
      return false;
    }
    if (allowedStatus.isEmpty) {
      return false;
    }
    for (final status in allowedStatus) {
      if (userStatus == status) {
        return true;
      }
      return false;
    }
    return false;
  }
}
