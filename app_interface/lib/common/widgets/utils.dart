import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  final snackBar = SnackBar(
    content: Text(content),
    backgroundColor: Colors.teal,
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: 'إغلاق',
      disabledTextColor: Colors.white,
      textColor: Colors.yellow,
      onPressed: () {
        //Do whatever you want
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Color? getColorFromHex(String? hexCode) {
  if (hexCode == null) {
    return null;
  }
  String formattedHex = hexCode.replaceAll("#", "");
  return Color(
    int.parse("FF$formattedHex", radix: 16),
  ); // Add "FF" for full opacity
}
