import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssmis_tz/app/api/api.dart';
import 'package:ssmis_tz/app/mixin/message_notifier_mixin.dart';
import 'package:ssmis_tz/app/models/user.dart';
import 'package:ssmis_tz/app/utils/app_const.dart';

class AppState with ChangeNotifier, MessageNotifierMixin {
  bool isAuthenticated = false;
  bool sessionHasBeenFetched = false;
  bool isLoading = false;
  User? user;
  String? errorMessage;

  void getSession() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString(AppConst.tokenKey);
      final String? userString = prefs.getString(AppConst.userKey);
      if (token != null && userString != null) {
        user = User.fromJson(jsonDecode(userString));
        isAuthenticated = true;
      }
      sessionHasBeenFetched = true;
      notifyListeners();
    } catch (e) {
      notifyError(e.toString());
      debugPrint(e.toString());
    }
  }

  void onUnAuthorized() {
    isAuthenticated = false;
    notifyListeners();
  }

  void login(dynamic logins) async {
    try {
      var response = await Api().dio.post("/users/authenticate", data: logins);
      user = User.fromJson(response.data['data']['user']);
      final String token = response.data['data']['token'];
      debugPrint(response.data['data']['token']);
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString(AppConst.userKey, jsonEncode(user));
      await prefs.setString(AppConst.tokenKey, token);
      isAuthenticated = true;
      sessionHasBeenFetched = true;
      notifyListeners();
    } catch (e) {
      notifyError(e.toString());
      debugPrint(e.toString());
    }
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConst.userKey);
    await prefs.remove(AppConst.tokenKey);
    isAuthenticated = false;
    sessionHasBeenFetched = true;
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    errorMessage = message;
    notifyListeners();
  }
}

final appState = AppState();
