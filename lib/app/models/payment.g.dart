// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      json['id'] as int,
      json['uuid'] as String,
      (json['amount'] as num).toDouble(),
      json['referenceNumber'] as String,
      json['invoiceId'] as int,
      DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'amount': instance.amount,
      'referenceNumber': instance.referenceNumber,
      'invoiceId': instance.invoiceId,
      'date': instance.date.toIso8601String(),
    };
