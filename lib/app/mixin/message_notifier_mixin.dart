import 'package:flutter/foundation.dart';

mixin MessageNotifierMixin on ChangeNotifier {
  String? _error;
  String? get error => _error;

  String? _info;
  String? get info => _info;

  String? _warning;
  String? get warning => _warning;

  void notifyError(dynamic error) {
    _error = error.toString();
    notifyListeners();
  }

  void notifyWarning(dynamic message) {
    _warning = message.toString();
    notifyListeners();
  }

  void clearError() {
    _error = null;
  }

  void notifyInfo(String info) {
    _info = info;
    notifyListeners();
  }

  void clearInfo() {
    _info = null;
  }
  void clearWarning() {
    _warning = null;
  }
}
