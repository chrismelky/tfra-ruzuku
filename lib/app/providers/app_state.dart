import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssmis_tz/app/api/api.dart';
import 'package:ssmis_tz/app/models/user.dart';
import 'package:ssmis_tz/app/providers/base_provider.dart';
import 'package:ssmis_tz/app/utils/app_const.dart';

class AppState extends BaseProvider {
  bool isAuthenticated = false;
  bool sessionHasBeenFetched = false;
  bool passwordChanged = true;
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
      passwordChanged = user?.passwordChanged ?? false;
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
      passwordChanged = user!.passwordChanged;
      sessionHasBeenFetched = true;
      notifyListeners();
    } catch (e) {
      notifyError(e.toString());
      debugPrint(e.toString());
    }
  }

  void changePassword(String newPassword) async {
    isLoading = true;
    try {
      var payload = {'newPassword': newPassword, 'userUuid': user!.uuid!};
      var response = await Api().dio.post("/users/change-password", data: payload);
      if(response.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? userString = prefs.getString(AppConst.userKey);
        Map<String, dynamic> userJson= await jsonDecode(userString!);
        userJson['passwordChanged'] = true;
        user = User.fromJson(jsonDecode(userString));
        await prefs.setString(AppConst.userKey, jsonEncode(user));
        passwordChanged = true;
        notifyListeners();
      }
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      notifyError(e.toString());
    } finally {
      isLoading = false;
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
