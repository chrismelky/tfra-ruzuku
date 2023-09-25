import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ssmis_tz/app/utils/app_number_formatter.dart';
import 'package:ssmis_tz/app/utils/helpers.dart';

class AppInputNumber extends StatelessWidget {
  final String name;
  final String displayValue;
  final String label;
  final List<String? Function(double?)> validators;
  final num? initialValue;
  final bool enabled;
  final Function? onChanged;


  const AppInputNumber(
      {super.key,
      required this.name,
      this.displayValue = 'name',
      required this.label,
      this.validators = const [],
      this.initialValue,
        this.enabled = true,
        this.onChanged});

  _toDouble(String value) {
    String asNumber = value.replaceAll(RegExp('[^0-9]'), '');
    num _newNum = num.tryParse(asNumber) ?? 0;
    _newNum /= pow(10, 2);
    return _newNum.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<double>(
        name: name,
        validator: FormBuilderValidators.compose(validators),
        builder: ((field) {
          return TextFormField(
            textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 14),
              inputFormatters: [AppNumberFormatter()],
              enabled: enabled,
              decoration: InputDecoration(
                label: Text(label),
                errorText: field.errorText,
              ),
              initialValue:
                  (currency.format(field.value ?? initialValue ?? 0.0)),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                field.didChange(value.isNotEmpty ? _toDouble(value) : 0.00);
                if(onChanged != null) {
                  onChanged!(field.value);
                }
              },

              );
        }));
  }
}
