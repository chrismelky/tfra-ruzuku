import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppNumberFormatter extends TextInputFormatter {
  String _newString = '';
  num _newNum = 0;
  final bool noDecimal;

  final _currency = NumberFormat.currency(
      locale: "en_US", customPattern: "#,###.##", decimalDigits: 0);

  AppNumberFormatter({this.noDecimal = false});

  void _formatter(String newText) {
    _newNum = num.tryParse(newText) ?? 0;
    _newNum /= noDecimal ? pow(10, 0) : pow(10, 2);
    _newString = _currency.format(_newNum).trim();
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    _formatter(newText);
    return TextEditingValue(
      text: _newString,
      selection: TextSelection.collapsed(offset: _newString.length),
    );
  }
}
