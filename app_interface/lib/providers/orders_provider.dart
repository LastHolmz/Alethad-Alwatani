import 'package:e_commerce/models/order.dart';
import 'package:e_commerce/services/order_service.dart';
import 'package:flutter/cupertino.dart';

enum Sort { asc, desc }

class OrdersProvider extends ChangeNotifier {
  final OrderService _orderServices = OrderService();
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders([String? params]) async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _orderServices.getOrders(params);
      _orders = result;
    } catch (e) {
      _orders = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
