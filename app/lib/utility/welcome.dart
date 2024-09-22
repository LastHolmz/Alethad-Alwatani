import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isIsFirstVisit() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? welcomeJson = prefs.getBool('second');
  if (welcomeJson == null) {
    await prefs.setBool('second', false);
    return true;
  }
  return false;
}
