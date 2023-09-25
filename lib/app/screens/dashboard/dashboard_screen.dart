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
          buildCard("Sales", Icons.point_of_sale_rounded, AppRoutes.sales),
          buildCard("Invoices", Icons.monetization_on_rounded, AppRoutes.invoice),
          buildCard(
              "Declarations", Icons.list_alt_outlined, AppRoutes.declaration),
          buildCard("Transfer Stock", Icons.send, AppRoutes.transfer),
          buildCard("Receive Stock", Icons.send, AppRoutes.receive)
        ],
      ),
    );
  }

  Widget buildCard(String title, IconData icon, String route) => InkWell(
      // onTap: () => AddRevenueItemDialog(context).addItem(item),
      onTap: () => context.go(route),
      child: Card(
        elevation: 3,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              Icon(icon)
            ]),
      ));
}
