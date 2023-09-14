import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AppInputDate extends StatelessWidget {
  final String name;
  final String label;

  const AppInputDate({Key? key, required this.name, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      valueTransformer: (date) => date?.toIso8601String(),
      name: name,
      fieldLabelText: label,
      inputType: InputType.date,
      decoration: InputDecoration(
        hintText: label,
      ),
    );
  }
}
