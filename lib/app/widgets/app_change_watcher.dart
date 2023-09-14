import 'package:flutter/material.dart';

class AppChangeWatcher extends StatelessWidget {

  final dynamic watch;
  final Widget child;
  const AppChangeWatcher({Key? key, this.watch, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return watch !=null ? child : child;
  }
}
