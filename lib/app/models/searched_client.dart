import 'package:json_annotation/json_annotation.dart';

part 'searched_client.g.dart';
@JsonSerializable(explicitToJson: true)
class SearchedClient {
  final int id;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? name;
  final String? mobile;
  final String? email;
  final String? gender;
  final String? adminHierarchyName;
  final DateTime? dateOfBirth;

  SearchedClient(
      this.id,
      this.firstName,
      this.middleName,
      this.lastName,
      this.mobile,
      this.email,
      this.gender,
      this.adminHierarchyName,
      this.dateOfBirth, this.name);

    factory SearchedClient.fromJson(Map<String,dynamic> json)=>_$SearchedClientFromJson(json);
    Map<String, dynamic> toJson()=> _$SearchedClientToJson(this);
}
