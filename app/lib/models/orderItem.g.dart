// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orderItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      id: json['id'] as String,
      productId: json['productId'] as String,
      skuId: json['skuId'] as String,
      barcode: json['barcode'] as String,
      qty: (json['qty'] as num).toInt(),
      title: json['title'] as String,
      image: json['image'] as String,
      skuImage: json['skuImage'] as String?,
      hashedColor: json['hashedColor'] as String?,
      price: (json['price'] as num).toDouble(),
      nameOfColor: json['nameOfColor'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      orderId: json['orderId'] as String?,
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'skuId': instance.skuId,
      'barcode': instance.barcode,
      'qty': instance.qty,
      'title': instance.title,
      'image': instance.image,
      'skuImage': instance.skuImage,
      'hashedColor': instance.hashedColor,
      'price': instance.price,
      'nameOfColor': instance.nameOfColor,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'orderId': instance.orderId,
    };
