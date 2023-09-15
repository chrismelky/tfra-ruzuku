import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/app_routes.dart';
import 'package:tfra_mobile/app/listeners/message_listener.dart';
import 'package:tfra_mobile/app/providers/stock_transfer_provider.dart';
import 'package:tfra_mobile/app/screens/stock_transfer/add_transfer.dart';
import 'package:tfra_mobile/app/widgets/app_base_screen.dart';
import 'package:tfra_mobile/app/widgets/app_detail_card.dart';
import 'package:tfra_mobile/app/widgets/app_table.dart';

class StockTransferListScreen extends StatefulWidget {
  const StockTransferListScreen({Key? key}) : super(key: key);

  @override
  State<StockTransferListScreen> createState() =>
      _StockTransferListScreenState();
}

class _StockTransferListScreenState extends State<StockTransferListScreen> {

  @override
  void initState() {
    super.initState();
    context.read<StockTransferProvider>().init();
  }

  @override
  Widget build(BuildContext context) {
    return MessageListener<StockTransferProvider>(
        child: AppBaseScreen(
      title: 'Stock Transfers',
      actions: [
        IconButton(
            onPressed: () => _addTransfer(),
            icon: const Icon(Icons.add))
      ],
      child: Consumer<StockTransferProvider>(
          builder: (_, provider, child) => ListView.separated(
              itemBuilder: (_, idx) {
                if (idx < provider.stockTransfers.length) {
                  var transfer = provider.stockTransfers[idx];
                  return AppDetailCard(
                      title: transfer.transactionType,
                      data: transfer.toJson(),
                      columns: [
                        AppDetailColumn(
                            header: 'To Agro Dealer', value: transfer.toAgroDealerName),
                        AppDetailColumn(
                            header: 'To Premise', value: transfer.toPremiseName),
                        AppDetailColumn(
                            header: 'Total Quantity', value: transfer.totalQuantity),
                        AppDetailColumn(
                            header: 'Bags', value: transfer.totalBags)
                      ]);
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
              separatorBuilder: (context, idx) => const Divider(),
              itemCount: provider.stockTransfers.length+1)),
    ));
  }

  _addTransfer() async{
    final result = await appRouter.openDialogPage(const AddStockTransferScreen());
    if (result != null && context.mounted) {
      context.read<StockTransferProvider>().init();
    }
  }
}
