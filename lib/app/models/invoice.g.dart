// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice(
      json['id'] as int,
      json['uuid'] as String,
      json['agroDealerId'] as int,
      json['agroDealerName'] as String,
      json['number'] as String,
      DateTime.parse(json['dateSubmitted'] as String),
      json['dateReceived'] == null
          ? null
          : DateTime.parse(json['dateReceived'] as String),
      (json['amount'] as num).toDouble(),
      (json['amountPaid'] as num).toDouble(),
      json['status'] as String,
      json['rejectionReason'] as String?,
    );

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'agroDealerId': instance.agroDealerId,
      'agroDealerName': instance.agroDealerName,
      'number': instance.number,
      'dateSubmitted': instance.dateSubmitted.toIso8601String(),
      'dateReceived': instance.dateReceived?.toIso8601String(),
      'amount': instance.amount,
      'amountPaid': instance.amountPaid,
      'status': instance.status,
      'rejectionReason': instance.rejectionReason,
    };
