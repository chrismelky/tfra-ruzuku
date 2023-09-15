import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const AppMenuItem(
      {Key? key,
      required this.icon,
      required this.label,
      required this.route})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColorDark,
      ),
      title: Text(
        label,
        style: TextStyle(color: Theme.of(context).primaryColorDark),
      ),
      onTap: () {
         context.go(route);
        Navigator.pop(context);
      },
    );

  }
}
