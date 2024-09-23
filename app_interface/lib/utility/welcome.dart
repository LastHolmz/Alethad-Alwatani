import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isIsFirstVisit() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? welcomeJson = prefs.getBool('firstVisit');
  if (welcomeJson == null) {
    await prefs.setBool('firstVisit', false);
    return true;
  }
  return false;
}
