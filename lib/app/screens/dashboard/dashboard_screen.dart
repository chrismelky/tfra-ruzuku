import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssmis_tz/app/app_routes.dart';
import 'package:ssmis_tz/app/widgets/app_base_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBaseScreen(
      title: 'Home',
      child: GridView(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 4, mainAxisSpacing: 4),
        children: [
          buildCard("Sales", Icons.point_of_sale_outlined, AppRoutes.sales),
          buildCard(
              "Invoices", Icons.monetization_on_outlined, AppRoutes.invoice),
          buildCard(
              "Declarations", Icons.list_alt_outlined, AppRoutes.declaration),
          buildCard("Transfer Stock", Icons.shopping_bag_outlined, AppRoutes.transfer),
          buildCard(
              "Receive Stock", Icons.receipt_long_sharp, AppRoutes.receive),
          buildCard(
              "Stock On Hand", Icons.inventory_2_outlined, AppRoutes.stockOnHand)
        ],
      ),
    );
  }

  Widget buildCard(String title, IconData icon, String route) => InkWell(
      // onTap: () => AddRevenueItemDialog(context).addItem(item),
      onTap: () => context.go(route),
      child: Card(
        elevation: 2,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 64, color: Theme.of(context).primaryColor.withOpacity(0.5)),
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(0.5),
                    ),
              ),
            ]),
      ));
}
