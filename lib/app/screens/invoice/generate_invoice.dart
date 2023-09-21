import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/listeners/message_listener.dart';
import 'package:tfra_mobile/app/models/sale.dart';
import 'package:tfra_mobile/app/models/sale_summary.dart';
import 'package:tfra_mobile/app/providers/invoice_provider.dart';
import 'package:tfra_mobile/app/utils/helpers.dart';
import 'package:tfra_mobile/app/widgets/app_base_popup_screen.dart';

class GenerateInvoiceScreen extends StatefulWidget {
  const GenerateInvoiceScreen({Key? key}) : super(key: key);

  @override
  State<GenerateInvoiceScreen> createState() => _GenerateInvoiceScreenState();
}

class _GenerateInvoiceScreenState extends State<GenerateInvoiceScreen> {
  List<int> selectedId = List.empty(growable: true);
  double amount = 0.00;

  @override
  void initState() {
    context.read<InvoiceProvider>().fetchPendingSales();
    super.initState();
  }

  _generateInvoice() async {
    if (selectedId.isNotEmpty && amount > 0) {
      bool generated = await context
          .read<InvoiceProvider>()
          .generaInvoice({'data': selectedId, 'amount': amount});
      if (generated && mounted) {
        Navigator.of(context).pop(generated);
      }
    }
  }

  _onSelectionChange(SaleSummary sale) {
    if (selectedId.contains(sale.id)) {
      setState(() {
        selectedId.remove(sale.id);
        amount = amount - sale.totalPrice;
      });
    } else {
      setState(() {
        selectedId.add(sale.id);
        amount = amount + sale.totalPrice;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MessageListener<InvoiceProvider>(child: Consumer<InvoiceProvider>(
      builder: (context, provider, child) {
        return AppBasePopUpScreen(
            isLoading: provider.isLoading,
            title: 'Generate Invoice',
            floatingButton: FloatingActionButton(
              child: Icon(Icons.save),
              onPressed: () => _generateInvoice(),
            ),
            child: Column(
              children: [
                CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text((selectedId.isEmpty ||
                            selectedId.length != provider.sales.length)
                        ? 'Select All'
                        : 'Un Select All'),
                    secondary: Text(currency.format(amount), style: TextStyle(fontWeight: FontWeight.w500),),

                    value: selectedId.isNotEmpty &&
                            selectedId.length != provider.sales.length
                        ? null
                        : selectedId.length == provider.sales.length,
                    tristate: true,
                    onChanged: (bool? value) {}),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (_, index) {
                        var sale = provider.sales[index];
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: selectedId.contains(sale.id),
                          selected: selectedId.contains(sale.id),
                          title: Text(sale.partyName),
                          secondary: Text(currency.format(sale.totalPrice)),
                          onChanged: (bool? value) {
                            _onSelectionChange(sale);
                          },
                        );
                      },
                      separatorBuilder: (_, idx) => const Divider(),
                      itemCount: provider.sales.length),
                ),
              ],
            ));
      },
    ));
  }
}
