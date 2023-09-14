import 'package:json_annotation/json_annotation.dart';

part 'packaging_option.g.dart';

@JsonSerializable(explicitToJson: true)
class PackagingOption {
  final int id;
  final String uuid;
  final double quantity;
  final int packagingOptionId;
  final String? packagingOptionName;
  final int declarationPremiseId;

  PackagingOption(this.id, this.uuid, this.quantity, this.packagingOptionId,
      this.packagingOptionName, this.declarationPremiseId);
  
  factory PackagingOption.fromJson(Map<String,dynamic> json)=>_$PackagingOptionFromJson(json);
  
  Map<String, dynamic> toJson()=> _$PackagingOptionToJson(this);
}
