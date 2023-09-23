// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'searched_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchedClient _$SearchedClientFromJson(Map<String, dynamic> json) =>
    SearchedClient(
      json['id'] as int,
      json['firstName'] as String?,
      json['middleName'] as String?,
      json['lastName'] as String?,
      json['mobile'] as String?,
      json['email'] as String?,
      json['gender'] as String?,
      json['adminHierarchyName'] as String?,
      json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      json['name'] as String?,
    );

Map<String, dynamic> _$SearchedClientToJson(SearchedClient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'lastName': instance.lastName,
      'name': instance.name,
      'mobile': instance.mobile,
      'email': instance.email,
      'gender': instance.gender,
      'adminHierarchyName': instance.adminHierarchyName,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
    };
