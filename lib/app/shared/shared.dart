import 'package:flutter/material.dart';

Function appMessage(BuildContext context) {
  return (String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text(message),
    ));
  };
}

Function appError(BuildContext context) {
  return (String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(message),
    ));
  };
}
