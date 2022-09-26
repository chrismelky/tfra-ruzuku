import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/app.dart';
import 'package:tfra_mobile/app/state/app_state.dart';
import 'package:tfra_mobile/app/state/sale_state.dart';

Future<void> main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => appState),
        ChangeNotifierProvider<SaleState>(create: (_) => saleState)
      ],
      child: App(),
    ),
  );
}
