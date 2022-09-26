import 'package:flutter/material.dart';

class AppSnackbar {
  AppSnackbar._();
  static buildErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
