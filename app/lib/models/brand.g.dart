// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Brand _$BrandFromJson(Map<String, dynamic> json) => Brand(
      id: json['id'] as String,
      productId: json['productId'] as String?,
      title: json['title'] as String,
      categoryId: json['categoryId'] as String?,
    );

Map<String, dynamic> _$BrandToJson(Brand instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'productId': instance.productId,
      'categoryId': instance.categoryId,
    };
