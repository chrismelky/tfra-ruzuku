// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockTransfer _$StockTransferFromJson(Map<String, dynamic> json) =>
    StockTransfer(
      json['id'] as int,
      json['uuid'] as String,
      json['transactionType'] as String,
      json['financialYearId'] as int,
      json['financialYearName'] as String,
      json['transactionStatus'] as String,
      json['toAgroDealerId'] as int,
      json['toAgroDealerName'] as String,
      (json['totalQuantity'] as num).toDouble(),
      json['totalBags'] as int,
      json['toPremiseId'] as int,
      json['toPremiseName'] as String,
      (json['stockTransferItems'] as List<dynamic>)
          .map((e) => StockTransferItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['fromPremiseName'] as String?,
      json['fromAgroDealerName'] as String?,
    );

Map<String, dynamic> _$StockTransferToJson(StockTransfer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'transactionType': instance.transactionType,
      'financialYearId': instance.financialYearId,
      'financialYearName': instance.financialYearName,
      'transactionStatus': instance.transactionStatus,
      'toAgroDealerId': instance.toAgroDealerId,
      'toAgroDealerName': instance.toAgroDealerName,
      'totalQuantity': instance.totalQuantity,
      'totalBags': instance.totalBags,
      'toPremiseId': instance.toPremiseId,
      'toPremiseName': instance.toPremiseName,
      'stockTransferItems':
          instance.stockTransferItems.map((e) => e.toJson()).toList(),
      'fromPremiseName': instance.fromPremiseName,
      'fromAgroDealerName': instance.fromAgroDealerName,
    };
