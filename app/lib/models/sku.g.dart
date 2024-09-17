// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sku.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sku _$SkuFromJson(Map<String, dynamic> json) => Sku(
      id: json['id'] as String,
      qty: (json['qty'] as num).toDouble(),
      hashedColor: json['hashedColor'] as String?,
      nameOfColor: json['nameOfColor'] as String?,
      productId: json['productId'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$SkuToJson(Sku instance) => <String, dynamic>{
      'id': instance.id,
      'qty': instance.qty,
      'hashedColor': instance.hashedColor,
      'nameOfColor': instance.nameOfColor,
      'productId': instance.productId,
      'image': instance.image,
    };
