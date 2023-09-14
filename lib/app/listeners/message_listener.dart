import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/mixin/message_notifier_mixin.dart';
import 'package:tuple/tuple.dart';

class MessageListener<T extends MessageNotifierMixin> extends StatelessWidget {
  final Widget child;

  const MessageListener({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<T, Tuple3<String?, String?, String?>>(
      selector: (context, model) => Tuple3(model.error, model.info, model.warning),
      shouldRebuild: (before, after) =>
          before.item1 != after.item1 || before.item2 != after.item2 || before.item3 != after.item3,
      builder: (context, tuple, child) {
        if (tuple.item1 != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleError(context, tuple.item1!);
          });
        }
        if (tuple.item2 != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleInfo(context, tuple.item2!);
          });
        }
        if (tuple.item3 != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleWarning(context, tuple.item3!);
          });
        }
        return child!;
      },
      child: child,
    );
  }

  void _handleError(BuildContext context, String error) {
    if (ModalRoute.of(context)!.isCurrent) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          duration: const Duration(seconds: 30),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: "CLOSE",
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
          content: Row(
            children: [
              Flexible(
                child: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      text: error,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                ),
              )
            ],
          ),
        ));
      Provider.of<T>(context, listen: false).clearError();
    }
  }

  void _handleWarning(BuildContext context, String warning) {
    if (ModalRoute.of(context)!.isCurrent) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.orangeAccent,
          action: SnackBarAction(
            label: "CLOSE",
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
          content: Row(
            children: [
              Flexible(
                child: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      text: warning,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                ),
              )
            ],
          ),
        ));
      Provider.of<T>(context, listen: false).clearWarning();
    }
  }

  void _handleInfo(BuildContext context, String info) {
    if (ModalRoute.of(context)!.isCurrent) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
          content: Row(
            children: [
              Flexible(
                child: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      text: info,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                ),
              )
            ],
          ),
        ));
      Provider.of<T>(context, listen: false).clearInfo();
    }
  }
}
