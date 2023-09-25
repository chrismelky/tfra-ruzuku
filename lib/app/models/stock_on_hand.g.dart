// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_on_hand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockOnHand _$StockOnHandFromJson(Map<String, dynamic> json) => StockOnHand(
      json['id'] as int,
      json['uuid'] as String,
      json['bags'] as int,
      json['packagingDealerId'] as int,
      json['packagingDealerName'] as String,
      json['packagingOptionId'] as int,
      json['packagingOptionName'] as String,
      json['packagingSize'] as int,
      json['productId'] as int,
      json['productName'] as String,
      (json['quantity'] as num).toDouble(),
    );

Map<String, dynamic> _$StockOnHandToJson(StockOnHand instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'bags': instance.bags,
      'packagingDealerId': instance.packagingDealerId,
      'packagingDealerName': instance.packagingDealerName,
      'packagingOptionId': instance.packagingOptionId,
      'packagingOptionName': instance.packagingOptionName,
      'packagingSize': instance.packagingSize,
      'productId': instance.productId,
      'productName': instance.productName,
      'quantity': instance.quantity,
    };
