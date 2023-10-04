import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AppInputDate extends StatelessWidget {
  final String name;
  final String label;
  final List<String? Function(dynamic)> validators;
  final bool disabled;

  const AppInputDate(
      {Key? key,
      required this.name,
      required this.label,
      this.validators = const [],
      this.disabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      valueTransformer: (date) => date?.toIso8601String(),
      name: name,
      validator: FormBuilderValidators.compose(validators),
      fieldLabelText: label,
      enabled: !disabled,
      inputType: InputType.date,
      decoration: InputDecoration(
        label: Text(label),
          suffixIcon: const Icon(Icons.calendar_month)),
    );
  }
}
