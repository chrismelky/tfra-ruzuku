import 'package:flutter/material.dart';
import 'package:ssmis_tz/app/api/api.dart';
import 'package:ssmis_tz/app/models/client_type.dart';
import 'package:ssmis_tz/app/models/searched_client.dart';
import 'package:ssmis_tz/app/shared/shared.dart';
import 'package:ssmis_tz/app/theme/form_controls.dart';

Future<String?> otpDialog(BuildContext context, Map<String, dynamic> payload) {
  String? otp;
  Function showError = appError(context);
  String? error;
  void verifyOtp() async {
    error = null;
    try {
      String api = '/sales/verifyOtp';
      var data = {'data': payload, 'otp': otp};
      var response = await Api().dio.post(api, data: data);
      if (response.statusCode == 200 && context.mounted) {
        Navigator.pop(context, otp);
      } else {
        error = "Invalid Opt";
      }
    } catch (e) {
      debugPrint(e.toString());
      showError(e.toString());
    }
  }

  return showDialog<String?>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            "Please enter the otp sent you number",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          titlePadding: const EdgeInsets.fromLTRB(16.0, 12.0, 12.0, 0.0),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 12.0, 12.0),
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                        height: 48,
                        child: TextField(
                          decoration: appInputDecoration("OTP"),
                          onChanged: (text) => otp = text,
                        ),
                      )),
                      IconButton(
                          onPressed: (() => verifyOtp()),
                          icon: const Icon(Icons.send))
                    ],
                  ),
                  if (error != null) Text(error!)
                ],
              ),
            ),
          ],
        );
      });
}
