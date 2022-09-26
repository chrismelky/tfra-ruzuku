import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/models/sale.dart';
import 'package:tfra_mobile/app/shared/shared.dart';
import 'package:tfra_mobile/app/state/app_state.dart';
import 'package:tfra_mobile/app/state/sale_state.dart';

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
    _saleState.loadSales(_showError);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
            child: ListView(children: [
          DrawerHeader(
              decoration: const BoxDecoration(color: Colors.green),
              child: Text("User ${context.select<AppState, String?>(
                (value) => value.user?.name,
              )}")),
          Expanded(child: Container()),
          TextButton(
              onPressed: () => context.read<AppState>().logout(),
              child: const Text("Logout"))
        ])),
        appBar: AppBar(
          title: const Text('Sales'),
          actions: [
            IconButton(
                onPressed: (() {
                  context.read<SaleState>().selectSale(Sale(
                      saleStatus: "NEW",
                      saleTransactionPackages: List.empty()));
                  context.go('/create-or-update');
                }),
                icon: const Icon(Icons.add))
          ],
        ),
        body: Consumer<SaleState>(
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
                          onTap: () {
                            context
                                .read<SaleState>()
                                .selectSale(saleState.sales![index]);
                            context.go("/create-or-update");
                          },
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
        ));
  }
}
