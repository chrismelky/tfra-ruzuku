import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/providers/app_state.dart';

class AppNotifier extends StatelessWidget {
  final Widget child;

  const AppNotifier({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, value, cchild) {
        String? error =
            context.select<AppState, String?>((value) => value.errorMessage);
        if (error != null) {}

        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            child,
            value.isLoading ? const CircularProgressIndicator() : Container(),
          ],
        );
      },
    );
  }
}
