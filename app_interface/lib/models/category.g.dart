// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['id'] as String,
      productIDs: (json['productIDs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      title: json['title'] as String,
      brands: (json['brands'] as List<dynamic>?)
          ?.map((e) => Brand.fromJson(e as Map<String, dynamic>))
          .toList(),
      main: json['main'] as bool,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'productIDs': instance.productIDs,
      'main': instance.main,
      'image': instance.image,
      'brands': instance.brands?.map((e) => e.toJson()).toList(),
    };
