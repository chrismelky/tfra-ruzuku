import 'package:json_annotation/json_annotation.dart';

part 'stock_transfer_item.g.dart';

@JsonSerializable(explicitToJson: true)
class StockTransferItem {
  final int id;
  final String uuid;
  final int productId;
  final String productName;
  final int packagingOptionId;
  final String packagingOptionName;
  final int bags;
  final double quantity;
  final double availableQuantity;
  final String stockCardUuid;

  StockTransferItem(
      this.id,
      this.uuid,
      this.productId,
      this.productName,
      this.packagingOptionId,
      this.packagingOptionName,
      this.bags,
      this.quantity,
      this.availableQuantity,
      this.stockCardUuid);

  factory StockTransferItem.fromJson(Map<String,dynamic> json)=>_$StockTransferItemFromJson(json);
  Map<String, dynamic> toJson()=> _$StockTransferItemToJson(this);
}
