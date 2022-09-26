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
      duration: const Duration(seconds: 5),
      // action: SnackBarAction(
      //   label: "Dismiss",
      //   onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      // ),
      content: Row(
        children: [
          Text(
            message,
            style: const TextStyle(
                fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),
          )
        ],
      ),
    ));
  };
}
