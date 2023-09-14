// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_declaration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockDeclaration _$StockDeclarationFromJson(Map<String, dynamic> json) =>
    StockDeclaration(
      json['id'] as int,
      json['uuid'] as String,
      json['agroDealerId'] as int,
      (json['quantity'] as num).toDouble(),
      json['productId'] as int,
      json['approved'] as bool,
      json['declarationType'] as String,
      json['productName'] as String,
      json['agroDealerName'] as String,
      json['financialYearName'] as String,
      json['qrCodesGenerated'] as bool,
      json['rejected'] as bool,
      json['rejectionComments'] as String?,
      (json['declarationPremises'] as List<dynamic>)
          .map((e) => DeclarationPremise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StockDeclarationToJson(StockDeclaration instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'agroDealerId': instance.agroDealerId,
      'quantity': instance.quantity,
      'productId': instance.productId,
      'approved': instance.approved,
      'declarationType': instance.declarationType,
      'productName': instance.productName,
      'agroDealerName': instance.agroDealerName,
      'financialYearName': instance.financialYearName,
      'qrCodesGenerated': instance.qrCodesGenerated,
      'rejected': instance.rejected,
      'rejectionComments': instance.rejectionComments,
      'declarationPremises':
          instance.declarationPremises.map((e) => e.toJson()).toList(),
    };
