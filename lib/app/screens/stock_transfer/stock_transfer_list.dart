import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssmis_tz/app/api/api.dart';
import 'package:ssmis_tz/app/app_routes.dart';
import 'package:ssmis_tz/app/listeners/message_listener.dart';
import 'package:ssmis_tz/app/providers/stock_transfer_provider.dart';
import 'package:ssmis_tz/app/screens/stock_transfer/add_transfer.dart';
import 'package:ssmis_tz/app/widgets/app_base_screen.dart';
import 'package:ssmis_tz/app/widgets/app_detail_card.dart';

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
    Future.delayed(
        Duration.zero, () => context.read<StockTransferProvider>().init());
  }

  @override
  Widget build(BuildContext context) {
    return MessageListener<StockTransferProvider>(
        child: AppBaseScreen(
      title: 'Stock Transfers',
      actions: [
        IconButton(
            onPressed: () => _addTransfer(null), icon: const Icon(Icons.add))
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
                          header: 'To Agro Dealer',
                          value: transfer.toAgroDealerName),
                      AppDetailColumn(
                          header: 'To Premise', value: transfer.toPremiseName),
                      AppDetailColumn(
                          header: 'Status', value: transfer.transactionStatus),
                      AppDetailColumn(
                          header: 'Total Quantity',
                          value: transfer.totalQuantity),
                      AppDetailColumn(header: 'Bags', value: transfer.totalBags)
                    ],
                    actionBuilder: (item) {
                      if (item!['transactionStatus'] == 'NEW')
                    {
                      return Row(
                        children: [
                          Expanded(child: Container()),
                          TextButton(
                              onPressed: () => _approve(item['uuid']),
                              child: const Text('Approve')),
                          const SizedBox(
                            width: 4,
                          ),
                          IconButton(
                              onPressed: () => _addTransfer(item),
                              icon: const Icon(Icons.edit))
                        ],
                      );
                    } else {
                        return Container();
                      }

                    },
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    provider.isLoading
                        ? const CircularProgressIndicator()
                        : provider.stockTransfers.isEmpty
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
              itemCount: provider.stockTransfers.length + 1)),
    ));
  }

  _addTransfer(Map<String, dynamic>? data) async {
    final result = await appRouter.openDialogPage(AddStockTransferScreen(
      formValues: data,
    ));
    if (result != null && context.mounted) {
      context.read<StockTransferProvider>().init();
    }
  }

  _approve(String uuid) async {
    bool? approved = await _confirmApprove(uuid);
    if(approved == true && mounted) {
      context.read<StockTransferProvider>().init();
    }
  }
  _confirmApprove(String uuid)  {
   return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: const Text('Are you sure you want to do this?'),
            actions: [
              TextButton(
                onPressed: () async {
                  var resp =
                      await Api().dio.get('/stock-transfers/confirm/$uuid');
                  if ([200, 201].contains(resp.statusCode) && mounted) {
                    Navigator.of(context).pop(true);
                  }
                },
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }
}
