import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:ssmis_tz/app/app.dart';
import 'package:ssmis_tz/app/db/db.dart';
import 'package:ssmis_tz/app/providers/app_state.dart';
import 'package:ssmis_tz/app/providers/invoice_provider.dart';
import 'package:ssmis_tz/app/providers/payment_provider.dart';
import 'package:ssmis_tz/app/providers/receive_stock_provider.dart';
import 'package:ssmis_tz/app/providers/sale_provider.dart';
import 'package:ssmis_tz/app/providers/stock_declaration_provider.dart';
import 'package:ssmis_tz/app/providers/stock_transfer_provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await DbProvider().migrate();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => appState),
        ChangeNotifierProvider<SaleProvider>(create: (_) => saleProvider),
        ChangeNotifierProvider<StockDeclarationProvider>(
            create: (_) => StockDeclarationProvider()),
        ChangeNotifierProvider<StockTransferProvider>(
            create: (_) => StockTransferProvider()),
        ChangeNotifierProvider<ReceiveStockProvider>(
            create: (_) => ReceiveStockProvider()),
        ChangeNotifierProvider<InvoiceProvider>(
            create: (_) => InvoiceProvider()),
        ChangeNotifierProvider<PaymentProvider>(
            create: (_) => PaymentProvider())
      ],
      child: App(),
    ),
  );
}
