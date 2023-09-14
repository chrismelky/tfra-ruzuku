import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final double? elevation;

  const AppCard({Key? key, required this.child, this.elevation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: child,
      ),
    );
  }
}
