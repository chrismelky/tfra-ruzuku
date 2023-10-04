// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockPackage _$StockPackageFromJson(Map<String, dynamic> json) => StockPackage(
      json['productName'] as String,
      json['agroDealerName'] as String,
      json['qrCodeNumber'] as String,
      json['price'] as num,
      json['quantity'] as num,
      json['packagingOptionName'] as String,
    );

Map<String, dynamic> _$StockPackageToJson(StockPackage instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'agroDealerName': instance.agroDealerName,
      'qrCodeNumber': instance.qrCodeNumber,
      'price': instance.price,
      'quantity': instance.quantity,
      'packagingOptionName': instance.packagingOptionName,
    };
