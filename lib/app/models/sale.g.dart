// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sale _$SaleFromJson(Map<String, dynamic> json) => Sale(
      json['uuid'] as String?,
      json['partyId'] as int?,
      json['partyType'] as String?,
      json['partyName'] as String?,
      DateTime.parse(json['transactionDate'] as String),
      (json['totalPrice'] as num?)?.toDouble(),
      (json['totalQuantity'] as num?)?.toDouble(),
      json['saleStatus'] as String,
      (json['saleTransactionPackages'] as List<dynamic>)
          .map((e) => SalePackage.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['controlNumber'] as String?,
      json['id'] as int?,
    );

Map<String, dynamic> _$SaleToJson(Sale instance) => <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'partyId': instance.partyId,
      'partyType': instance.partyType,
      'partyName': instance.partyName,
      'transactionDate': instance.transactionDate.toIso8601String(),
      'totalPrice': instance.totalPrice,
      'totalQuantity': instance.totalQuantity,
      'saleStatus': instance.saleStatus,
      'controlNumber': instance.controlNumber,
      'saleTransactionPackages':
          instance.saleTransactionPackages.map((e) => e.toJson()).toList(),
    };
