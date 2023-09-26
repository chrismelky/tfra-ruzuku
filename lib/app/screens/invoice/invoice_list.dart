import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssmis_tz/app/app_routes.dart';
import 'package:ssmis_tz/app/listeners/message_listener.dart';
import 'package:ssmis_tz/app/models/invoice.dart';
import 'package:ssmis_tz/app/providers/invoice_provider.dart';
import 'package:ssmis_tz/app/screens/invoice/generate_invoice.dart';
import 'package:ssmis_tz/app/screens/invoice/payment_list.dart';
import 'package:ssmis_tz/app/utils/format_type.dart';
import 'package:ssmis_tz/app/widgets/app_base_screen.dart';
import 'package:ssmis_tz/app/widgets/app_detail_card.dart';
import 'package:ssmis_tz/app/widgets/app_no_item_found.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({Key? key}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () => context.read<InvoiceProvider>().init());
    super.initState();
  }

  _generateInvoice() async {
    final result =
        await appRouter.openDialogPage(const GenerateInvoiceScreen());
    if (result != null && context.mounted) {
      context.read<InvoiceProvider>().init();
    }
  }

  _submit(Invoice invoice) {
    context.read<InvoiceProvider>().submit(invoice.uuid);
  }

  @override
  Widget build(BuildContext context) {
    return MessageListener<InvoiceProvider>(
        child: AppBaseScreen(
      title: 'Invoices',
      actions: [
        IconButton(
            onPressed: () => _generateInvoice(), icon: const Icon(Icons.add))
      ],
      child: Consumer<InvoiceProvider>(
        builder: (context, provider, child) {
          return !provider.isLoading && provider.invoices.isEmpty
              ? NoItemFound(
                  name: 'invoice',
                  onReload: () => provider.init(),
                )
              : ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    if (index < provider.invoices.length) {
                      var invoice = provider.invoices[index];
                      return AppDetailCard(
                        title: invoice.number,
                        data: invoice.toJson(),
                        columns: [
                          AppDetailColumn(
                              header: 'Amount',
                              value: invoice.amount,
                              format: FormatType.currency),
                          AppDetailColumn(
                              header: 'Amount Paid',
                              value: invoice.amountPaid ?? 0,
                              format: FormatType.currency),
                          AppDetailColumn(
                              header: 'Status', value: invoice.status)
                        ],
                        actionBuilder: (item) => Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (invoice.status == 'CREATED')
                              IconButton(
                                  onPressed: () => _submit(invoice),
                                  icon: Icon(Icons.send)),
                            IconButton(
                                onPressed: () => _viewPayment(invoice),
                                icon: Icon(Icons.payments_outlined))
                          ],
                        ),
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        provider.isLoading
                            ? const CircularProgressIndicator()
                            :  TextButton(
                                    onPressed: () => provider.loadMore(),
                                    child: const Text("Load more.."))
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemCount: provider.invoices.length +1,
                );
        },
      ),
    ));
  }

  _viewPayment(Invoice invoice) async {
    appRouter.openDialogPage(PaymentListScreen(invoice: invoice));
  }
}
