import 'package:flutter/cupertino.dart';
import 'package:ssmis_tz/app/mixin/message_notifier_mixin.dart';

class BaseProvider extends ChangeNotifier with MessageNotifierMixin {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

}