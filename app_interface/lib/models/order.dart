// ignore: depend_on_referenced_packages
import 'package:e_commerce/models/orderItem.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'order.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
// @JsonSerializable()
@JsonSerializable(explicitToJson: true)
class Order {
  final String id; // Unique identifier for the order
  final String? userId; // ID of the user
  final double totalPrice; // Total price of the order
  final double rest; // Remaining amount for the order
  final List<OrderItem> orderItems; // List of order items
  final OrderStatus status; // Status of the order
  final DateTime createdAt; // Creation timestamp
  final DateTime updatedAt; // Last update timestamp
  final String barcode; // Unique barcode for the order

  Order({
    required this.id,
    this.userId,
    required this.totalPrice,
    required this.rest,
    required this.orderItems,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
  });

  double sumTheQty() {
    double _sum = 0;
    for (final orderItem in orderItems) {
      _sum += orderItem.qty;
    }
    return _sum;
  }

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

// Enum for order status
enum OrderStatus {
  pending,
  inProgress,
  done,
  rejected,
  refused,
}
