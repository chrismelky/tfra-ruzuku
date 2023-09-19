import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
import 'package:tfra_mobile/app/models/packaging_option.dart';

part 'declaration_premise.g.dart';

@JsonSerializable(explicitToJson: true)
class DeclarationPremise {
  final int id;
  final String uuid;
  final double quantity;
  final String? premiseName;
  final int? premiseId;
  final List<PackagingOption> packagingRequests;

  DeclarationPremise(this.id, this.uuid, this.quantity, this.premiseName,
      this.packagingRequests, this.premiseId);

  factory DeclarationPremise.fromJson(Map<String, dynamic> json) =>
      _$DeclarationPremiseFromJson(json);

  Map<String, dynamic> toJson() => _$DeclarationPremiseToJson(this);
}
