import 'package:json_annotation/json_annotation.dart';
import 'package:ssmis_tz/app/models/declaration_premise.dart';

part 'stock_declaration.g.dart';

@JsonSerializable(explicitToJson: true)
class StockDeclaration {
  final int id;
  final String uuid;
  final int agroDealerId;
  final double quantity;
  final int productId;
  final bool approved;
  final String declarationType;
  final String productName;
  final String agroDealerName;
  final String financialYearName;
  final bool qrCodesGenerated;
  final bool rejected;
  final String? rejectionComments;
  final List<DeclarationPremise> declarationPremises;

  StockDeclaration(
      this.id,
      this.uuid,
      this.agroDealerId,
      this.quantity,
      this.productId,
      this.approved,
      this.declarationType,
      this.productName,
      this.agroDealerName,
      this.financialYearName,
      this.qrCodesGenerated,
      this.rejected,
      this.rejectionComments,
      this.declarationPremises);

  factory StockDeclaration.fromJson(Map<String,dynamic> json)=>_$StockDeclarationFromJson(json);
  Map<String, dynamic> toJson()=> _$StockDeclarationToJson(this);
}
