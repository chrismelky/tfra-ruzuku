class SalePackage {
  String? uuid;
  int? id;
  String qrCodeNumber;
  String? fertilizerDealerName;
  double quantity;
  String? fertilizerName;
  double? price = 0;

  SalePackage(
      {this.uuid,
      this.id,
      required this.qrCodeNumber,
      required this.fertilizerDealerName,
      required this.quantity,
      this.fertilizerName,
      required this.price});

  factory SalePackage.fromJson(Map<String, dynamic> json) => SalePackage(
      uuid: json["uuid"],
      id: json["id"],
      qrCodeNumber: json["qrCodeNumber"],
      fertilizerDealerName: json["fertilizerDealerName"],
      fertilizerName: json['fertilizerName'],
      quantity: json["quantity"],
      price: json["price"] ?? 0);

  factory SalePackage.fromScanner(Map<String, dynamic> json) => SalePackage(
      qrCodeNumber: json['qr'],
      fertilizerDealerName: json['brand'],
      fertilizerName: json['fertilizer'],
      quantity: json['quantity'].toDouble(),
      price: json['price'] ?? 0);

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "qrCodeNumber": qrCodeNumber,
        "fertilizerDealerName": fertilizerDealerName,
        "quantity": quantity,
        "fertilizerName": fertilizerName,
        "price": price
      };
}
