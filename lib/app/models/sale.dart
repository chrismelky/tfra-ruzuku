import 'package:json_annotation/json_annotation.dart';
import 'package:tfra_mobile/app/models/sale_package.dart';

part 'sale.g.dart';

@JsonSerializable(explicitToJson: true)
class Sale {
  final int? id;
  final String? uuid;
  final int? partyId;
  final String? partyType;
  final String? partyName;
  final DateTime transactionDate;
  final double? totalPrice;
  final double? totalQuantity;
  final String saleStatus;
  final String? controlNumber;
  final List<SalePackage> saleTransactionPackages;

  Sale(
      this.uuid,
      this.partyId,
      this.partyType,
      this.partyName,
      this.transactionDate,
      this.totalPrice,
      this.totalQuantity,
      this.saleStatus,
      this.saleTransactionPackages, this.controlNumber, this.id);

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);

  Map<String, dynamic> toJson() => _$SaleToJson(this);
}
