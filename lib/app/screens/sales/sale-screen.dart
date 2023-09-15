import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/app_routes.dart';
import 'package:tfra_mobile/app/listeners/message_listener.dart';
import 'package:tfra_mobile/app/models/sale.dart';
import 'package:tfra_mobile/app/screens/sales/create_sale_screen.dart';
import 'package:tfra_mobile/app/shared/shared.dart';
import 'package:tfra_mobile/app/providers/sale_state.dart';
import 'package:tfra_mobile/app/widgets/app_base_screen.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  late SaleState _saleState;
  late Function _showError;

  @override
  void initState() {
    _showError = appError(context);
    _saleState = Provider.of<SaleState>(context, listen: false);
    _saleState.loadSales();
    super.initState();
  }

  addSale(sale) async {
    context.read<SaleState>().selectSale(sale);
    final result = await appRouter.openDialogPage(const CreateSaleScreen());
    if (result != null && context.mounted) {
      context.read<SaleState>().loadSales();
      context.read<SaleState>().selectSale(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBaseScreen(
      title: 'Sales',
      actions: [
        IconButton(
            onPressed: (() => addSale(Sale(
                saleStatus: "NEW", saleTransactionPackages: List.empty()))),
            icon: const Icon(Icons.add))
      ],
      child: MessageListener<SaleState>(
        child: Consumer<SaleState>(
          builder: (context, saleState, child) {
            if (saleState.sales == null) {
              return const Text("No sales found");
            } else {
              return ListView.builder(
                  itemCount: saleState.sales?.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(saleState.sales![index].partyName!),
                          subtitle: Text(
                              "${saleState.sales![index].partyType!}, ${saleState.sales![index].transactionDate!} "),
                          onTap: () => addSale(saleState.sales![index]),
                          leading: CircleAvatar(
                              child: Text(saleState.sales![index].saleStatus
                                  .substring(0, 1))),
                        ),
                        const Divider(
                          thickness: 1,
                        )
                      ],
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
