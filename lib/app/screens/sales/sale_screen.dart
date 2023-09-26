import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssmis_tz/app/app_routes.dart';
import 'package:ssmis_tz/app/listeners/message_listener.dart';
import 'package:ssmis_tz/app/screens/sales/add_sale_screen.dart';
import 'package:ssmis_tz/app/providers/sale_provider.dart';
import 'package:ssmis_tz/app/utils/helpers.dart';
import 'package:ssmis_tz/app/widgets/app_base_screen.dart';
import 'package:ssmis_tz/app/widgets/app_detail_card.dart';
import 'package:ssmis_tz/app/widgets/app_no_item_found.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () => context.read<SaleProvider>().init());
    super.initState();
  }

  _addSale(sale) async {
    final result = await appRouter.openDialogPage(AddSaleScreen(
      sale: sale,
    ));
    if (result != null && context.mounted) {
      context.read<SaleProvider>().init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MessageListener<SaleProvider>(
        child: AppBaseScreen(
            title: 'Sales',
            actions: [
              IconButton(
                  onPressed: () => _addSale(null), icon: const Icon(Icons.add))
            ],
            child: Consumer<SaleProvider>(
              builder: (context, provider, child) {
                return !provider.isLoading && provider.sales.isEmpty
                    ? NoItemFound(
                        name: 'sales',
                        onReload: () => provider.init(),
                      )
                    : ListView.separated(
                        itemBuilder: (_, idx) {
                          if (idx < provider.sales.length) {
                            var sale = provider.sales[idx];
                            return AppDetailCard(
                              data: {},
                              columns: [
                                AppDetailColumn(
                                    header: 'Customer', value: sale.partyName),
                                AppDetailColumn(
                                    header: 'Items',
                                    value: sale.saleTransactionPackages.length),
                                AppDetailColumn(
                                    header: 'Quantity',
                                    value: sale.totalQuantity),
                                AppDetailColumn(
                                    header: 'Total Amount',
                                    value: currency.format(sale.totalPrice))
                              ],
                              title: sale.saleStatus,
                              actionBuilder: (item) => Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (sale.saleStatus == 'NEW')
                                    IconButton(
                                        onPressed: () => _addSale(sale),
                                        icon: const Icon(Icons.edit))
                                ],
                              ),
                            );
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              provider.isLoading
                                  ? const CircularProgressIndicator()
                                  : TextButton(
                                          onPressed: () => provider.loadMore(),
                                          child: const Text("Load more.."))
                            ],
                          );
                        },
                        separatorBuilder: (_, idx) => const Divider(),
                        itemCount: provider.sales.length +1);
              },
            )));
  }
}
