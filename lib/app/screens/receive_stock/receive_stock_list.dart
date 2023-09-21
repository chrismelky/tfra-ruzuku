import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/app_routes.dart';
import 'package:tfra_mobile/app/listeners/message_listener.dart';
import 'package:tfra_mobile/app/models/stock_transfer.dart';
import 'package:tfra_mobile/app/providers/receive_stock_provider.dart';
import 'package:tfra_mobile/app/screens/receive_stock/receive_stock_detail.dart';
import 'package:tfra_mobile/app/widgets/app_base_screen.dart';
import 'package:tfra_mobile/app/widgets/app_detail_card.dart';
import 'package:tfra_mobile/app/widgets/app_icon_button.dart';

class ReceiveStockListScreen extends StatefulWidget {
  const ReceiveStockListScreen({Key? key}) : super(key: key);

  @override
  State<ReceiveStockListScreen> createState() => _ReceiveStockListScreenState();
}

class _ReceiveStockListScreenState extends State<ReceiveStockListScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration.zero, () => context.read<ReceiveStockProvider>().init());
  }

  _receiveStock(StockTransfer stock) async {
    final result = await appRouter
        .openDialogPage(ReceiveStockDetailScreen(stockTransfer: stock));
    if (result != null && context.mounted) {
      context.read<ReceiveStockProvider>().init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MessageListener<ReceiveStockProvider>(
        child: AppBaseScreen(
      title: 'Receive Stock',
      child: Consumer<ReceiveStockProvider>(
          builder: (_, provider, child) => ListView.separated(
              itemBuilder: (_, idx) {
                if (idx < provider.stockToReceive.length) {
                  var transfer = provider.stockToReceive[idx];
                  return AppDetailCard(
                    title: transfer.transactionType,
                    data: transfer.toJson(),
                    columns: [
                      AppDetailColumn(
                          header: 'From Agro Dealer',
                          value: transfer.fromAgroDealerName),
                      AppDetailColumn(
                          header: 'Total Quantity',
                          value: transfer.totalQuantity),
                      AppDetailColumn(header: 'Bags', value: transfer.totalBags)
                    ],
                    actionBuilder: (item) => AppIconButton(
                        onPressed: () => _receiveStock(transfer),
                        icon: Icons.launch),
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    provider.isLoading
                        ? const CircularProgressIndicator()
                        : provider.stockToReceive.isEmpty
                            ? const Center(
                                child: Text('No transfer found'),
                              )
                            : TextButton(
                                onPressed: () => provider.loadMore(),
                                child: const Text("Load more.."))
                  ],
                );
              },
              separatorBuilder: (context, idx) => const Divider(),
              itemCount: provider.stockToReceive.length + 1)),
    ));
  }
}
