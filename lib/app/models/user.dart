import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final int id;
  final String? uuid;
  final String name;
  final String email;
  final String? adminHierarchyName;
  final String? levelName;
  final String? phone;
  final bool? isPremiseUser;
  final int? premiseId;
  final bool passwordChanged;

  User(
      this.id,
      this.name,
      this.email,
      this.adminHierarchyName,
      this.levelName,
      this.phone,
      this.isPremiseUser,
      this.premiseId,
      this.passwordChanged, this.uuid);

  factory User.fromJson(Map<String,dynamic> json)=>_$UserFromJson(json);
  Map<String, dynamic> toJson()=> _$UserToJson(this);
}
