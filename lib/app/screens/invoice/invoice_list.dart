import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/app_routes.dart';
import 'package:tfra_mobile/app/listeners/message_listener.dart';
import 'package:tfra_mobile/app/providers/invoice_provider.dart';
import 'package:tfra_mobile/app/screens/invoice/generate_invoice.dart';
import 'package:tfra_mobile/app/utils/format_type.dart';
import 'package:tfra_mobile/app/widgets/app_base_screen.dart';
import 'package:tfra_mobile/app/widgets/app_detail_card.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({Key? key}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  @override
  void initState() {
    context.read<InvoiceProvider>().init();
    super.initState();
  }

  _generateInvoice() async{
    final result = await appRouter.openDialogPage(const GenerateInvoiceScreen());
    if (result != null && context.mounted) {
      context.read<InvoiceProvider>().init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MessageListener<InvoiceProvider>(
        child: Consumer<InvoiceProvider>(
      builder: (context, provider, child) => AppBaseScreen(
        title: 'Invoices',
        actions: [
          IconButton(
              onPressed: () => _generateInvoice(), icon: const Icon(Icons.add))
        ],
        isLoading: provider.isLoading,
        child: ListView.separated(
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
                  AppDetailColumn(header: 'Status', value: invoice.status)
                ],
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                provider.isLoading
                    ? const CircularProgressIndicator()
                    : provider.invoices.isEmpty
                        ? const Center(
                            child: Text('No Invoices found'),
                          )
                        : TextButton(
                            onPressed: () => provider.loadMore(),
                            child: const Text("Load more.."))
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemCount: provider.invoices.length,
        ),
      ),
    ));
  }
}
