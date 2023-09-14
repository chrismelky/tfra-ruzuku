import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'app_input_hidden.dart';

/// App form as FormBuilder wrapper  that provide by default id and uuid as hidden fields
/// this allow automatic setting and retrieving this fields automatically during update
/// It accept child widget as entry point for adding more fields
class AppForm extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final Widget? customLayout;
  final List<Widget>? controls;
  final Map<String, dynamic> initialValue;

  const AppForm(
      {super.key,
      required this.formKey,
        this.customLayout,
      this.initialValue = const {},
        this.controls});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: formKey,
        initialValue: initialValue,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppInputHidden(fieldName: 'id'),
            const AppInputHidden(fieldName: 'uuid'),
            controls != null ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: controls!.map((e) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  e,
                  const SizedBox(height: 16,)
                ],
              )).toList(),
            ) : customLayout ?? Container()],
        )
    );
  }
}
