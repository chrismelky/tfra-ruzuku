import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssmis_tz/app/app_routes.dart';
import 'package:ssmis_tz/app/providers/app_state.dart';
import 'package:ssmis_tz/app/widgets/app_menu_item.dart';

class AppBasePopUpScreen extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? floatingButton;
  final bool? isLoading;
  final List<Widget>? actions;
  final Widget? leading;

  const AppBasePopUpScreen({
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
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
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
