import 'package:flutter/material.dart';

class BillsSceen extends StatefulWidget {
  const BillsSceen({super.key});
  static const String name = "bills";
  static const String path = "/bills";

  @override
  State<BillsSceen> createState() => _BillsSceenState();
}

class _BillsSceenState extends State<BillsSceen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text("bills"),
      ),
    );
  }
}
