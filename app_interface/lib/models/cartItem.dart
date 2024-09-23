// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'cartItem.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
// @JsonSerializable()
@JsonSerializable(explicitToJson: true)
class CartItem {
  final String productId;
  final String skuId;
  final String barcode;
  int qty;
  final String title;
  final String image;
  final String? skuImage;
  final String? hashedColor;
  final double price;
  int maxQty;
  final String? nameOfColor;
  bool overQty;
  bool notVaildAnyMore;

  CartItem({
    required this.productId,
    required this.skuId,
    required this.qty,
    required this.barcode,
    required this.title,
    required this.image,
    this.skuImage,
    this.hashedColor,
    this.nameOfColor,
    required this.price,
    required this.maxQty,
    this.overQty = false,
    this.notVaildAnyMore = false,
  });

  void setMaxQty(int qty) {
    maxQty = qty;
  }

  void incrementQty() {
    if (qty < this.maxQty) {
      qty++;
    }
  }

  void decrementQty() {
    if (qty > 0) {
      if (qty == maxQty && overQty == true) {
        overQty = false;
      }
      qty--;
    }
  }

  void changeValidity(bool val) {
    this.notVaildAnyMore = val;
  }

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}
