import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AppInputDropDown<T extends dynamic> extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String name;
  final String displayValue;
  final String label;
  final List<String? Function(dynamic)> validators;
  final Function? onChange;
  final bool isLoading;

  const AppInputDropDown(
      {super.key,
      required this.items,
      required this.name,
      this.displayValue = 'name',
      required this.label,
        this.isLoading = false,
      this.validators = const [],
      this.onChange});

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<T>(
        name: name,
        validator: FormBuilderValidators.compose(validators),
        builder: ((field) {
          return DropdownButtonFormField<T>(
            value: field.value,
            decoration:
                InputDecoration(
                    label: isLoading ? Text("Loading $label..") : Text(label),
                    errorText: field.errorText,
                ),
            items: items.map((dynamic value) {
              return DropdownMenuItem<T>(
                value: value['id'],
                child: Text(value[displayValue],
                    style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                field.didChange( value);
              }
              if (onChange != null) {
                onChange!(field.value);
              }
            },
          );
        }));
  }
}
