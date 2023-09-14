// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packaging_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackagingOption _$PackagingOptionFromJson(Map<String, dynamic> json) =>
    PackagingOption(
      json['id'] as int,
      json['uuid'] as String,
      (json['quantity'] as num).toDouble(),
      json['packagingOptionId'] as int,
      json['packagingOptionName'] as String?,
      json['declarationPremiseId'] as int,
    );

Map<String, dynamic> _$PackagingOptionToJson(PackagingOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'quantity': instance.quantity,
      'packagingOptionId': instance.packagingOptionId,
      'packagingOptionName': instance.packagingOptionName,
      'declarationPremiseId': instance.declarationPremiseId,
    };
