import 'package:shared_preferences/shared_preferences.dart';

class GlobalVariables {
  static const double defalutRaduis = 40;
  static const double defaultPadding = 20;
}

Map<String, String> headers(String token) {
  return {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
}

Future<String> getStoredToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  return token;
}

const uri = 'http://10.0.2.2:10000/api/v1/';

Uri apiUri(String path) {
  return Uri.parse('$uri$path');
}
