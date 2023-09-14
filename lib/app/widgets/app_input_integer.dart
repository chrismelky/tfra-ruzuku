import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AppInputInteger extends StatelessWidget {
  final String name;
  final String displayValue;
  final String label;
  final Widget? suffix;
  final List<String? Function(int?)> validators;
  final num? initialValue;
  final Function? onChanged;

  const AppInputInteger(
      {super.key,
      required this.name,
      this.displayValue = 'name',
      required this.label,
      this.validators = const [],
      this.initialValue,
        this.suffix, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<int>(
        name: name,
        validator: FormBuilderValidators.compose(validators),
        builder: ((field) {
          return TextFormField(
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                  errorText: field.errorText,
                  label: Text(
                    label,
                  ),
                suffix: suffix
              ),
              initialValue: (field.value ?? initialValue ?? 0).toString(),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                field.didChange(value.isNotEmpty ? int.parse(value) : 0);
                if(onChanged != null) {
                  onChanged!(field.value);
                }
              });
        }));
  }
}
