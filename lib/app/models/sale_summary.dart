import 'package:json_annotation/json_annotation.dart';

part 'sale_summary.g.dart';

@JsonSerializable(explicitToJson: true)
class SaleSummary {
  final int id;
  final String partyName;
  final double totalPrice;
  final double totalQuantity;
  final DateTime transactionDate;

  SaleSummary(this.id, this.partyName, this.totalPrice, this.totalQuantity,
      this.transactionDate);

  factory SaleSummary.fromJson(Map<String,dynamic> json)=>_$SaleSummaryFromJson(json);
  Map<String, dynamic> toJson()=> _$SaleSummaryToJson(this);

}
