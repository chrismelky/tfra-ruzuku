import 'package:json_annotation/json_annotation.dart';

part 'stock_package.g.dart';

@JsonSerializable(explicitToJson: true)
class StockPackage {
  final String productName;
  final String agroDealerName;
  final String qrCodeNumber;
  final num price;
  final num quantity;
  final String packagingOptionName;

  StockPackage(this.productName, this.agroDealerName, this.qrCodeNumber,
      this.price, this.quantity, this.packagingOptionName);

  factory StockPackage.fromJson(Map<String,dynamic> json)=>_$StockPackageFromJson(json);
  Map<String, dynamic> toJson()=> _$StockPackageToJson(this);
}
