// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'declaration_premise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeclarationPremise _$DeclarationPremiseFromJson(Map<String, dynamic> json) =>
    DeclarationPremise(
      json['id'] as int,
      json['uuid'] as String,
      (json['quantity'] as num).toDouble(),
      json['premiseName'] as String?,
      (json['packagingRequests'] as List<dynamic>)
          .map((e) => PackagingOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DeclarationPremiseToJson(DeclarationPremise instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'quantity': instance.quantity,
      'premiseName': instance.premiseName,
      'packagingRequests':
          instance.packagingRequests.map((e) => e.toJson()).toList(),
    };
