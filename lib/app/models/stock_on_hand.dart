import 'package:json_annotation/json_annotation.dart';

part 'stock_on_hand.g.dart';
@JsonSerializable(explicitToJson: true)
class StockOnHand {
  final int id;
  final String uuid;
  final int bags;
  final int packagingDealerId;
  final String packagingDealerName;
  final int packagingOptionId;
  final String packagingOptionName;
  final int packagingSize;
  final int productId;
  final String productName;
  final double quantity;

  StockOnHand(
      this.id,
      this.uuid,
      this.bags,
      this.packagingDealerId,
      this.packagingDealerName,
      this.packagingOptionId,
      this.packagingOptionName,
      this.packagingSize,
      this.productId,
      this.productName,
      this.quantity);

  factory StockOnHand.fromJson(Map<String,dynamic> json)=>_$StockOnHandFromJson(json);
  Map<String, dynamic> toJson()=> _$StockOnHandToJson(this);

}
