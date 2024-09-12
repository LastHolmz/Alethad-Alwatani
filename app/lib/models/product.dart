// ignore: depend_on_referenced_packages
import 'package:e_commerce/models/brand.dart';
import 'package:e_commerce/models/category.dart';
import 'package:e_commerce/models/sku.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'product.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
// @JsonSerializable()
@JsonSerializable(explicitToJson: true)
class Product {
  final String id;
  final String title;
  final String? description;
  final double? originalPrice;
  final double price;
  final String barcode;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String image;
  final List<Sku>? skus;
  final List<Category>? categories;
  final List<Brand>? brands;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.barcode,
    required this.createdAt,
    required this.updatedAt,
    this.description = '',
    this.originalPrice = 0,
    required this.image,
    this.skus,
    this.categories,
    this.brands,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
  // brands      Brand[]
}
