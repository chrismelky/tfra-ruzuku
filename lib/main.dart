import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/app.dart';
import 'package:tfra_mobile/app/db/db.dart';
import 'package:tfra_mobile/app/providers/app_state.dart';
import 'package:tfra_mobile/app/providers/sale_state.dart';
import 'package:tfra_mobile/app/providers/stock_declaration_provider.dart';
import 'package:tfra_mobile/app/providers/stock_transfer_provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await DbProvider().migrate();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => appState),
        ChangeNotifierProvider<SaleState>(create: (_) => saleState),
        ChangeNotifierProvider<StockDeclarationProvider>(create: (_) => StockDeclarationProvider()),
        ChangeNotifierProvider<StockTransferProvider>(create: (_) => StockTransferProvider())
      ],
      child: App(),
    ),
  );
}
