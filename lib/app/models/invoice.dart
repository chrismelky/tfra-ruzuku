import 'package:json_annotation/json_annotation.dart';

part 'invoice.g.dart';

@JsonSerializable(explicitToJson: true)
class Invoice {
  final int id;
  final String uuid;
  final int agroDealerId;
  final String agroDealerName;
  final String number;
  final DateTime dateSubmitted;
  final DateTime? dateReceived;
  final double amount;
  final double amountPaid;
  final String status;
  final String? rejectionReason;

  Invoice(
      this.id,
      this.uuid,
      this.agroDealerId,
      this.agroDealerName,
      this.number,
      this.dateSubmitted,
      this.dateReceived,
      this.amount,
      this.amountPaid,
      this.status,
      this.rejectionReason);

  factory Invoice.fromJson(Map<String,dynamic> json)=>_$InvoiceFromJson(json);
  Map<String, dynamic> toJson()=> _$InvoiceToJson(this);
}
