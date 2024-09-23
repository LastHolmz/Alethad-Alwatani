// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Brand _$BrandFromJson(Map<String, dynamic> json) => Brand(
      id: json['id'] as String,
      productIDs: (json['productIDs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      title: json['title'] as String,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      image: json['image'] as String?,
    );

Map<String, dynamic> _$BrandToJson(Brand instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'productIDs': instance.productIDs,
      'categories': instance.categories?.map((e) => e.toJson()).toList(),
      'image': instance.image,
    };
