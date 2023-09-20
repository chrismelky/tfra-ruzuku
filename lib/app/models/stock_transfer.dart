import 'package:json_annotation/json_annotation.dart';
import 'package:tfra_mobile/app/models/stock_transfer_item.dart';

part 'stock_transfer.g.dart';

@JsonSerializable(explicitToJson: true)
class StockTransfer {
  final int id;
  final String uuid;
  final String transactionType;
  final int financialYearId;
  final String financialYearName;
  final String transactionStatus;
  final int toAgroDealerId;
  final String toAgroDealerName;
  final double totalQuantity;
  final int totalBags;
  final int toPremiseId;
  final String toPremiseName;
  final List<StockTransferItem> stockTransferItems;
  final String? fromPremiseName;
  final String? fromAgroDealerName;

  StockTransfer(
      this.id,
      this.uuid,
      this.transactionType,
      this.financialYearId,
      this.financialYearName,
      this.transactionStatus,
      this.toAgroDealerId,
      this.toAgroDealerName,
      this.totalQuantity,
      this.totalBags,
      this.toPremiseId,
      this.toPremiseName,
      this.stockTransferItems,
      this.fromPremiseName,
      this.fromAgroDealerName);

  factory StockTransfer.fromJson(Map<String, dynamic> json) =>
      _$StockTransferFromJson(json);

  Map<String, dynamic> toJson() => _$StockTransferToJson(this);
}
