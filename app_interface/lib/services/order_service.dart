import 'dart:convert';

import 'package:e_commerce/common/widgets/utils.dart';
import 'package:e_commerce/constants/global_variables.dart';
import 'package:e_commerce/models/order.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class OrderService {
  Future<Order?> createOrder(Order order, BuildContext context) async {
    Uri uri = apiUri('orders');
    final token = await getStoredToken();
    // Order in json format
    String OrderJson = json.encode(order.toJson());

    final response = await post(
      uri,
      headers: headers(token),
      body: OrderJson,
    );
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> body = json.decode(response.body);
        final dynamic orderData = body["data"];
        final Order newOrder = Order.fromJson(orderData);
        return newOrder;
      }
      if (context.mounted) {
        showSnackBar(context, json.decode(response.body)["message"]);
      }
      return null;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, json.decode(response.body)["message"]);
      }
      return null;
    }
  }

  Future<List<Order>> getOrders([String? params]) async {
    try {
      final Uri uri = apiUri('orders?$params');
      final token = await getStoredToken();
      final response = await get(
        uri,
        headers: headers(token),
      );

      if (response.statusCode != 200) {
        return [];
      } else {
        final Map<String, dynamic> body = json.decode(response.body);
        final List<dynamic> ordersData = body["data"];
        final List<Order> orders = ordersData
            .map(
              (order) => Order.fromJson(order),
            )
            .toList();
        return orders;
      }
    } catch (e) {
      return [];
    }
  }

  Future<Order?> getOrder(String? id) async {
    if (id == null) {
      return null;
    }
    try {
      final Uri uri = apiUri('orders/$id');
      final token = await getStoredToken();
      final response = await get(
        uri,
        headers: headers(token),
      );

      if (response.statusCode != 200) {
        return null;
      } else {
        final Map<String, dynamic> body = json.decode(response.body);
        final dynamic orderData = body["data"];
        final Order order = Order.fromJson(orderData);
        return order;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> cancleOrder(String? id, BuildContext context) async {
    if (id == null) {
      return null;
    }
    try {
      final Uri uri = apiUri('orders/$id/cancel');
      final token = await getStoredToken();
      final response = await put(
        uri,
        headers: headers(token),
        body: json.encode({"status": "rejected"}),
      );
      // print(object)

      final Map<String, dynamic> body = json.decode(response.body);
      if (context.mounted) {
        showSnackBar(context, body["message"]);
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, "فشلت العملية");
      }
    }
  }
}
