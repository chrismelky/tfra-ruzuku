import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssmis_tz/app/listeners/message_listener.dart';
import 'package:ssmis_tz/app/providers/stock_on_hand_provider.dart';
import 'package:ssmis_tz/app/widgets/app_base_screen.dart';
import 'package:ssmis_tz/app/widgets/app_detail_card.dart';

class StockOnHandScreen extends StatefulWidget {
  const StockOnHandScreen({Key? key}) : super(key: key);

  @override
  State<StockOnHandScreen> createState() => _StockOnHandScreenState();
}

class _StockOnHandScreenState extends State<StockOnHandScreen> {
  @override
  void initState() {
    Future.delayed(
        Duration.zero, () => context.read<StockOnHandProvider>().init());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MessageListener<StockOnHandProvider>(
        child: AppBaseScreen(
            title: 'Stock On Hand',
            child: Consumer<StockOnHandProvider>(
              builder: (context, provider, child) =>
              !provider.isLoading && provider.stockOnHand.isEmpty
                      ? const Center(
                          child: Text('No Stock on hand found'),
                        )
                      : ListView.separated(
                          itemBuilder: (_, idx) {
                            if (idx < provider.stockOnHand.length) {
                              var stockCard = provider.stockOnHand[idx];
                              return AppDetailCard(
                                title: stockCard.productName,
                                data: stockCard.toJson(),
                                columns: [
                                  AppDetailColumn(
                                      header: 'Brand',
                                      value: stockCard.packagingDealerName),
                                  AppDetailColumn(
                                      header: 'Packaging(Kg)',
                                      value: stockCard.packagingSize),
                                  AppDetailColumn(
                                      header: 'Stock Quantity',
                                      value: stockCard.quantity),
                                  AppDetailColumn(
                                      header: 'Stock Bags', value: stockCard.bags),
                                ],
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
                          separatorBuilder: (context, idx) => const Divider(),
                          itemCount: provider.stockOnHand.length + 1),
            )));
  }
}
