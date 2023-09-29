// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as int,
      json['name'] as String,
      json['email'] as String,
      json['adminHierarchyName'] as String?,
      json['levelName'] as String?,
      json['phone'] as String?,
      json['isPremiseUser'] as bool?,
      json['premiseId'] as int?,
      json['passwordChanged'] as bool,
      json['uuid'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'name': instance.name,
      'email': instance.email,
      'adminHierarchyName': instance.adminHierarchyName,
      'levelName': instance.levelName,
      'phone': instance.phone,
      'isPremiseUser': instance.isPremiseUser,
      'premiseId': instance.premiseId,
      'passwordChanged': instance.passwordChanged,
    };
