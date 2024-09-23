// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cartItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
      productId: json['productId'] as String,
      skuId: json['skuId'] as String,
      qty: (json['qty'] as num).toInt(),
      barcode: json['barcode'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
      skuImage: json['skuImage'] as String?,
      hashedColor: json['hashedColor'] as String?,
      nameOfColor: json['nameOfColor'] as String?,
      price: (json['price'] as num).toDouble(),
      maxQty: (json['maxQty'] as num).toInt(),
      overQty: json['overQty'] as bool? ?? false,
      notVaildAnyMore: json['notVaildAnyMore'] as bool? ?? false,
    );

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'productId': instance.productId,
      'skuId': instance.skuId,
      'barcode': instance.barcode,
      'qty': instance.qty,
      'title': instance.title,
      'image': instance.image,
      'skuImage': instance.skuImage,
      'hashedColor': instance.hashedColor,
      'price': instance.price,
      'maxQty': instance.maxQty,
      'nameOfColor': instance.nameOfColor,
      'overQty': instance.overQty,
      'notVaildAnyMore': instance.notVaildAnyMore,
    };
