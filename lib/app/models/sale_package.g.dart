// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalePackage _$SalePackageFromJson(Map<String, dynamic> json) => SalePackage(
      json['uuid'] as String?,
      json['id'] as int?,
      json['qrCodeNumber'] as String,
      json['agroDealerName'] as String?,
      (json['quantity'] as num).toDouble(),
      json['productName'] as String?,
      (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SalePackageToJson(SalePackage instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'id': instance.id,
      'qrCodeNumber': instance.qrCodeNumber,
      'agroDealerName': instance.agroDealerName,
      'quantity': instance.quantity,
      'productName': instance.productName,
      'price': instance.price,
    };
