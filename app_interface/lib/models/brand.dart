// ignore: depend_on_referenced_packages
import 'package:e_commerce/models/category.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'brand.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
// @JsonSerializable()
@JsonSerializable(explicitToJson: true)
class Brand {
  final String id;
  final String title;
  final List<String>? productIDs;
  final List<Category>? categories;
  final String? image;

  Brand(
      {required this.id,
      this.productIDs,
      required this.title,
      this.categories,
      this.image});
  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);
  Map<String, dynamic> toJson() => _$BrandToJson(this);
}
