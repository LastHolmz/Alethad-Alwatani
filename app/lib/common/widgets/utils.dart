import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
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
