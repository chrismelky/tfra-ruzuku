import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/app_routes.dart';
import 'package:tfra_mobile/app/providers/app_state.dart';
import 'package:tfra_mobile/app/widgets/app_menu_item.dart';

class AppBaseScreen extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? floatingButton;
  final bool? isLoading;
  final List<Widget>? actions;
  final Widget? leading;

  const AppBaseScreen({
    Key? key,
    required this.title,
    required this.child,
    this.isLoading = false,
    this.floatingButton,
    this.actions,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(children: [
        DrawerHeader(
            decoration: const BoxDecoration(color: Colors.green),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: Text("U"),
                ),
                SizedBox(width: 10,),
                Text("${context.select<AppState, String?>(
                  (value) => value.user?.name,
                )}")
              ],
            )),
        SingleChildScrollView(
            child: Column(children: const [
          AppMenuItem(
              icon: Icons.home,
              label: 'Home',
              route: AppRoutes.dashboard),
              AppMenuItem(
              icon: Icons.launch,
              label: 'Stock Declaration',
              route: AppRoutes.declaration),
          AppMenuItem(
              icon: Icons.launch,
              label: 'Stock Transfer',
              route: AppRoutes.transfer),
          AppMenuItem(
              icon: Icons.launch,
              label: 'Receive Stock',
              route: AppRoutes.receive),
          AppMenuItem(
              icon: Icons.point_of_sale_outlined,
              label: 'Sales',
              route: AppRoutes.sales),
        ])),
        TextButton(
            onPressed: () => context.read<AppState>().logout(),
            child: const Text("Logout"))
      ])),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: actions,
        leading: leading,
      ),
      backgroundColor: Colors.indigo[50],
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
                child: child,
              ),
            ),
            isLoading! ? const CircularProgressIndicator() : Container(),
          ],
        ),
      ),
      floatingActionButton: floatingButton,
    );
  }
}
