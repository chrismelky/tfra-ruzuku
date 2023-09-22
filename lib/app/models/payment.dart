import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable(explicitToJson: true)
class Payment {
  final int id;
  final String uuid;
  final double amount;
  final String referenceNumber;
  final int invoiceId;
  final DateTime date;

  Payment(this.id, this.uuid, this.amount, this.referenceNumber, this.invoiceId,
      this.date);

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
