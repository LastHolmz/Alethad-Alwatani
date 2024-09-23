import 'package:e_commerce/models/order.dart';

double getSumOfOrderPrices(List<Order> orders) {
  double sum = 0;
  if (orders.isNotEmpty) {
    for (final order in orders) {
      sum += order.totalPrice;
    }
  }
  return sum;
}

double getDebt(List<Order> orders) {
  double sum = 0;
  if (orders.isNotEmpty) {
    for (final order in orders) {
      sum += order.rest;
    }
  }
  return sum;
}
