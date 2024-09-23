// ignore: depend_on_referenced_packages
import 'package:e_commerce/models/brand.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'category.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
// @JsonSerializable()
@JsonSerializable(explicitToJson: true)
class Category {
  final String id;
  final String title;
  final List<String>? productIDs;
  final bool main;
  final String? image;
  final List<Brand>? brands;

  Category({
    required this.id,
    this.productIDs,
    required this.title,
    required this.brands,
    required this.main,
    this.image,
  });
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
