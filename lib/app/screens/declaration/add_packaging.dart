import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tfra_mobile/app/widgets/app_button.dart';
import 'package:tfra_mobile/app/widgets/app_fetcher.dart';
import 'package:tfra_mobile/app/widgets/app_form.dart';
import 'package:tfra_mobile/app/widgets/app_input_dropdown.dart';
import 'package:tfra_mobile/app/widgets/app_input_form_array.dart';
import 'package:tfra_mobile/app/widgets/app_input_hidden.dart';
import 'package:tfra_mobile/app/widgets/app_input_number.dart';

class AddPackaging extends StatefulWidget {
  final Map<String, dynamic> declarationPremise;

  const AddPackaging({Key? key, required this.declarationPremise})
      : super(key: key);

  @override
  State<AddPackaging> createState() => _AddPackagingState();
}

class _AddPackagingState extends State<AddPackaging> {
  final _packagingForm = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return AppForm(
      formKey: _packagingForm,
      controls: [
        AppInputHidden(
          fieldName: 'declarationPremiseId',
          value: widget.declarationPremise['declarationPremiseId'],
        ),
        AppInputFormArray(
            name: 'packagingRequests',
            label: 'Packaging options',
            formKey: _packagingForm,
            formControls: [
              AppFetcher(
                  api: '/packaging-options',
                  builder: (items, isLoading) => AppInputDropDown(
                      items: items,
                      name: 'packagingOptionId',
                      label: 'Packaging Option')),
              AppInputNumber(name: 'quantity', label: 'Quantity'),
              AppButton(
                  onPress: () {
                    debugPrint(_packagingForm.currentState?.value.toString());
                  },
                  label: 'Save')
            ],
            displayColumns: [
              AppFormArrayDisplayColumn(
                  label: 'Quantity', valueField: 'quantity')
            ],
            uniqueKeyField: 'packagingOptionId')
      ],
    );
  }
}
