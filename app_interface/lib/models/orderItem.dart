// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'orderItem.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
// @JsonSerializable()
@JsonSerializable(explicitToJson: true)
class OrderItem {
  final String id; // Unique identifier for the order item
  final String productId; // ID of the product
  final String skuId; // Stock Keeping Unit ID
  final String barcode; // Barcode of the product
  final int qty; // Quantity of the item in the cart
  final String title; // Title of the product
  final String image; // URL of the product image
  final String? skuImage; // Optional URL for SKU-specific image
  final String? hashedColor; // Optional hashed color code
  final double price; // Price of the item
  final String? nameOfColor; // Optional name of the color
  final DateTime createdAt; // Timestamp for when the item was added to the cart
  final DateTime updatedAt; // Last update timestamp
  final String? orderId; // ID of the related order

  OrderItem({
    required this.id,
    required this.productId,
    required this.skuId,
    required this.barcode,
    required this.qty,
    required this.title,
    required this.image,
    this.skuImage,
    this.hashedColor,
    required this.price,
    this.nameOfColor,
    required this.createdAt,
    required this.updatedAt,
    this.orderId,
  });

  double calcPrice() {
    return price * qty;
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
