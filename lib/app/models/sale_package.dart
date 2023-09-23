import 'package:json_annotation/json_annotation.dart';

part 'sale_package.g.dart';

@JsonSerializable(explicitToJson: true)
class SalePackage {
  final String? uuid;
  final int? id;
  final String qrCodeNumber;
  final String? agroDealerName;
  final int quantity;
  final String? productName;
  final double? price;

  SalePackage(this.uuid, this.id, this.qrCodeNumber, this.agroDealerName,
      this.quantity, this.productName, this.price);

  factory SalePackage.fromJson(Map<String, dynamic> json) =>
      _$SalePackageFromJson(json);

  Map<String, dynamic> toJson() => _$SalePackageToJson(this);

  static fromScanner(Map<String, dynamic> fromScanner) {}
}
