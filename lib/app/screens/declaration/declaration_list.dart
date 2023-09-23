import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/app_routes.dart';
import 'package:tfra_mobile/app/listeners/message_listener.dart';
import 'package:tfra_mobile/app/providers/stock_declaration_provider.dart';
import 'package:tfra_mobile/app/screens/declaration/add_declaration.dart';
import 'package:tfra_mobile/app/widgets/app_base_screen.dart';
import 'package:tfra_mobile/app/widgets/app_detail_card.dart';

class StockDeclarationScreen extends StatefulWidget {
  const StockDeclarationScreen({Key? key}) : super(key: key);

  @override
  State<StockDeclarationScreen> createState() => _StockDeclarationScreenState();
}

class _StockDeclarationScreenState extends State<StockDeclarationScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration.zero, () => context.read<StockDeclarationProvider>().init());
  }

  _addDeclaration(Map<String, dynamic>? data) async {
    final result = await appRouter.openDialogPage(AddStockDeclarationScreen(
      formValues: data,
    ));
    if (result != null && context.mounted) {
      context.read<StockDeclarationProvider>().init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MessageListener<StockDeclarationProvider>(
      child: AppBaseScreen(
        title: "Stock Declaration",
        actions: [
          IconButton(
              onPressed: () => _addDeclaration(null),
              icon: const Icon(Icons.add))
        ],
        child: Consumer<StockDeclarationProvider>(
            builder: (_, provider, child) => ListView.separated(
                itemBuilder: (_, idx) {
                  if (idx < provider.declarations.length) {
                    var declaration = provider.declarations[idx];
                    return AppDetailCard(
                        title: declaration.declarationType,
                        data: declaration.toJson(),
                        actionBuilder: (item) => Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  Icons.qr_code,
                                  color: Theme.of(context).primaryColor,
                                ),
                                Expanded(child: Container()),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.launch)),
                                const SizedBox(
                                  width: 4,
                                ),
                                IconButton(
                                    onPressed: () => _addDeclaration(item),
                                    icon: const Icon(Icons.edit))
                              ],
                            ),
                        columns: [
                          AppDetailColumn(
                              header: 'Product',
                              value: declaration.productName),
                          AppDetailColumn(
                              header: 'Quantity', value: declaration.quantity),
                          AppDetailColumn(
                              header: 'Premise',
                              value: declaration.declarationPremises.length),
                          AppDetailColumn(
                              header: 'Packaging',
                              value: declaration.declarationPremises.length),
                        ]);
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      provider.isLoading
                          ? const CircularProgressIndicator()
                          : provider.declarations.isEmpty
                              ? Center(
                                  child: Column(
                                    children: [
                                      const Text('No declaration found'),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      TextButton(
                                          onPressed: () => provider.init(),
                                          child: const Text('Reload'))
                                    ],
                                  ),
                                )
                              : TextButton(
                                  onPressed: () => provider.loadMore(),
                                  child: const Text("Load more.."))
                    ],
                  );
                },
                separatorBuilder: (context, idx) => const Divider(),
                itemCount: provider.declarations.length + 1)),
      ),
    );
  }
}
