import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

// App hidden field no displayed control but bind values
class AppInputHidden extends StatelessWidget {
  final String fieldName;
  final dynamic value;
  const AppInputHidden({
    super.key,
    required this.fieldName,
    this.value
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<dynamic>(
        name: fieldName,
        initialValue: value,
        builder: ((field) {
          return Container();
        }));
  }
}
