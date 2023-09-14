import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AppInputText extends StatelessWidget {
  final String fieldName;
  final String displayValue;
  final String label;
  final List<String? Function(String?)> validators;
  final bool obscureText;
  final Widget? suffixIcon;

  const AppInputText(
      {super.key,
      required this.fieldName,
      this.displayValue = 'name',
      required this.label,
      this.validators = const [],
      this.obscureText = false, this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
        name: fieldName,
        validator: FormBuilderValidators.compose(validators),
        builder: ((field) {
          return TextFormField(

              decoration: InputDecoration(
                suffixIcon: suffixIcon,
                label: Text(label),
                errorText: field.errorText,
              ),
              initialValue: field.value,
              obscureText: obscureText,
              onChanged: (value) {
                field.didChange(value);
              });
        }));
  }
}
