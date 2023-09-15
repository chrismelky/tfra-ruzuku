import 'package:flutter/material.dart';
import 'package:tfra_mobile/app/models/stock_transfer.dart';
import 'package:tfra_mobile/app/widgets/app_base_popup_screen.dart';

class ReceiveStockDetailScreen extends StatefulWidget {
  final StockTransfer stock;

  const ReceiveStockDetailScreen({Key? key, required this.stock}) : super(key: key);

  @override
  State<ReceiveStockDetailScreen> createState() => _ReceiveStockDetailScreenState();
}

class _ReceiveStockDetailScreenState extends State<ReceiveStockDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBasePopUpScreen(title: 'Receive Stock', child: Container() );
  }
}
