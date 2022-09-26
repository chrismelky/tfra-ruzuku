import 'package:tfra_mobile/app/models/sale_package.dart';
import 'package:intl/intl.dart';

class Sale {
  String? uuid;
  int? partyId;
  String? partyType;
  String? partyName;
  DateTime? transactionDate;
  double? totalPrice;
  double? totalQuantity;
  String saleStatus;
  List<SalePackage> saleTransactionPackages;

  Sale(
      {this.partyId,
      this.partyType,
      this.partyName,
      this.transactionDate,
      this.totalPrice,
      required this.saleStatus,
      this.totalQuantity,
      this.uuid,
      required this.saleTransactionPackages});

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
      uuid: json["uuid"],
      partyId: json["partyId"],
      partyType: json["partyType"],
      partyName: json["partyName"],
      transactionDate: DateFormat("yyyy-MM-dd").parse(json["transactionDate"]),
      totalPrice: json["totalPrice"],
      saleStatus: json["saleStatus"],
      totalQuantity: json["totalQuantity"],
      saleTransactionPackages: List<SalePackage>.from(
          json["saleTransactionPackages"]
              .map((model) => SalePackage.fromJson(model))));

  static listFromJson(dynamic json) =>
      List<Sale>.from(json.map((e) => Sale.fromJson(e)));

  Map<String, dynamic> toJson() => {
        "partyId": partyId,
        "partyType": partyType,
        "partyName": partyName,
        "transactionDate": transactionDate,
        "totalPrice": totalPrice,
        "saleStatus": saleStatus,
        "totalQuantity": totalQuantity,
        "saleTransactionPackages": List<Map<String, dynamic>>.from(
            saleTransactionPackages.map((e) => e.toJson()))
      };
}
