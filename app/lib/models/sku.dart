// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'sku.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
// @JsonSerializable()
@JsonSerializable(explicitToJson: true)
class Sku {
  final String id;
  final double qty;
  final String? hashedColor;
  final String? nameOfColor;
  final String size;
  final String? productId;
  final String? image;

  Sku(
      {required this.id,
      required this.qty,
      required this.hashedColor,
      required this.nameOfColor,
      required this.size,
      required this.productId,
      required this.image});
  factory Sku.fromJson(Map<String, dynamic> json) => _$SkuFromJson(json);
  Map<String, dynamic> toJson() => _$SkuToJson(this);
}
