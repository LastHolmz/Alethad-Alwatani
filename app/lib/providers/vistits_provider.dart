import 'package:e_commerce/utility/welcome.dart';
import 'package:flutter/material.dart';

class VisitProvider extends ChangeNotifier {
  bool _firstVisit = false;
  bool get firstVisit => _firstVisit;

  void setFirstVisit(bool val) {
    _firstVisit = val;
    notifyListeners();
  }

  void runAtFirst() async {
    _firstVisit = await isIsFirstVisit();
    notifyListeners();
  }
}
