import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/app_routes.dart';
import 'package:tfra_mobile/app/listeners/message_listener.dart';
import 'package:tfra_mobile/app/providers/stock_declaration_provider.dart';
import 'package:tfra_mobile/app/screens/declaration/add_declaration.dart';
import 'package:tfra_mobile/app/widgets/app_base_screen.dart';

class StockDeclarationScreen extends StatefulWidget {
  const StockDeclarationScreen({Key? key}) : super(key: key);

  @override
  State<StockDeclarationScreen> createState() => _StockDeclarationScreenState();
}

class _StockDeclarationScreenState extends State<StockDeclarationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StockDeclarationProvider>().init();
  }

  _addDeclaration()  async {
    final result = await appRouter.openDialogPage(const AddStockDeclarationScreen());
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
                onPressed: () => _addDeclaration(),
                icon: const Icon(Icons.add))
          ],
          child: Consumer<StockDeclarationProvider>(
          builder: (_, provider, child) => ListView.separated(
            itemBuilder: (_, idx) {
              if(idx < provider.declarations.length) {
               var declaration = provider.declarations[idx];
               return ListTile(
                 title: Text(declaration.productName),
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
              itemCount: provider.declarations.length + 1
          )
          ),
          ),
        );
  }

}
