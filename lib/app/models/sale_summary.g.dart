// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleSummary _$SaleSummaryFromJson(Map<String, dynamic> json) => SaleSummary(
      json['id'] as int,
      json['partyName'] as String,
      (json['totalPrice'] as num).toDouble(),
      (json['totalQuantity'] as num).toDouble(),
      DateTime.parse(json['transactionDate'] as String),
    );

Map<String, dynamic> _$SaleSummaryToJson(SaleSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'partyName': instance.partyName,
      'totalPrice': instance.totalPrice,
      'totalQuantity': instance.totalQuantity,
      'transactionDate': instance.transactionDate.toIso8601String(),
    };
