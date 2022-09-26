import 'package:flutter/material.dart';

InputDecoration appInputDecoration(String label) => InputDecoration(
      filled: true,
      labelText: label,
      fillColor: Colors.transparent,
      hintStyle: const TextStyle(fontSize: 10),
    );

InputDecoration saleDropdownDecoration(String label) => InputDecoration(
      filled: true,
      labelText: label,
      isDense: true,
      fillColor: Colors.transparent,
      hintStyle: const TextStyle(fontSize: 10),
    );

InputDecoration saleDatePickerDecoration(String label) => InputDecoration(
      filled: true,
      labelText: label,
      fillColor: Colors.transparent,
      suffixIcon: const Icon(Icons.calendar_month),
      hintStyle: const TextStyle(fontSize: 10),
    );
