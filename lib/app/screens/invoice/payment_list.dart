import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/listeners/message_listener.dart';
import 'package:tfra_mobile/app/models/invoice.dart';
import 'package:tfra_mobile/app/providers/payment_provider.dart';
import 'package:tfra_mobile/app/utils/helpers.dart';
import 'package:tfra_mobile/app/widgets/app_base_popup_screen.dart';
import 'package:tfra_mobile/app/widgets/app_detail_card.dart';

class PaymentListScreen extends StatefulWidget {
  final Invoice invoice;

  const PaymentListScreen({Key? key, required this.invoice}) : super(key: key);

  @override
  State<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  late final Invoice _invoice;

  @override
  void initState() {
    _invoice = widget.invoice;
    context.read<PaymentProvider>().init(_invoice.uuid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MessageListener<PaymentProvider>(
        child: Consumer<PaymentProvider>(
      builder: (context, provider, child) => AppBasePopUpScreen(
        title: 'Payments',
        child: Column(

          children: [
            AppDetailCard(data: {}, columns: [
              AppDetailColumn(header: 'Dealer', value: _invoice.agroDealerName),
              AppDetailColumn(header: 'Invoice', value: _invoice.number),
              AppDetailColumn(
                  header: 'Date Submitted	',
                  value: dateFormat.format(_invoice.dateSubmitted)),
              AppDetailColumn(
                  header: 'Total Amount',
                  value: currency.format(_invoice.amount)),
              AppDetailColumn(
                  header: 'Amount Paid',
                  value: currency.format(_invoice.amountPaid)),
            ], title: 'Invoice'),
            const SizedBox(
              height: 8,
            ),
            Text('Payments', style: TextStyle(fontWeight: FontWeight.w500),),
            Expanded(
                child: Card(
                  child: ListView.separated(
                      itemBuilder: (_, idx) {
                        var payment = provider.payments[idx];
                        return ListTile(
                          title: Text(dateFormat.format(payment.date)),
                          trailing: Text(currency.format(payment.amount)),
                          subtitle: Text(payment.referenceNumber),
                        );
                      },
                      separatorBuilder: (_, idx) => const Divider(),
                      itemCount: provider.payments.length),
                ))
          ],
        ),
      ),
    ));
  }
}
