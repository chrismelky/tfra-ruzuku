import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:ssmis_tz/app/providers/stock_declaration_provider.dart';
import 'package:ssmis_tz/app/widgets/app_button.dart';
import 'package:ssmis_tz/app/widgets/app_fetcher.dart';
import 'package:ssmis_tz/app/widgets/app_form.dart';
import 'package:ssmis_tz/app/widgets/app_input_dropdown.dart';
import 'package:ssmis_tz/app/widgets/app_input_form_array.dart';
import 'package:ssmis_tz/app/widgets/app_input_hidden.dart';
import 'package:ssmis_tz/app/widgets/app_input_number.dart';

class AddPackaging extends StatefulWidget {
  final Map<String, dynamic> declarationPremise;
  final Function onPackageStepSaved;

  const AddPackaging(
      {Key? key,
      required this.declarationPremise,
      required this.onPackageStepSaved})
      : super(key: key);

  @override
  State<AddPackaging> createState() => _AddPackagingState();
}

class _AddPackagingState extends State<AddPackaging> {
  final _packagingForm = GlobalKey<FormBuilderState>();
  late Map<String, dynamic> _declarationPremise;

  @override
  void initState() {
    if (widget.declarationPremise['packagingRequests'] != null &&
        widget.declarationPremise['packagingRequests'].length > 0) {
      _declarationPremise = {
        'declarationPremiseId': widget.declarationPremise['id'],
        'packagingRequests': widget.declarationPremise['packagingRequests']
      };
    } else {
      _declarationPremise = {
        'declarationPremiseId': widget.declarationPremise['id'],
        'packagingRequests': List<Map<String, dynamic>>.empty()
      };
    }

    super.initState();
  }

  _saveAndNext() async {
    if (_packagingForm.currentState?.saveAndValidate() == true) {
      var payload = _packagingForm.currentState!.value;
      debugPrint(payload.toString());
      var result =
          await context.read<StockDeclarationProvider>().addPackage(payload);
      if (result) {
        widget.onPackageStepSaved();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppForm(
      formKey: _packagingForm,
      initialValue: _declarationPremise,
      controls: [
        const AppInputHidden(
          fieldName: 'declarationPremiseId',
        ),
        AppInputFormArray(
            name: 'packagingRequests',
            label: 'Packaging options',
            formKey: _packagingForm,
            validators: [
              FormBuilderValidators.required(
                  errorText: "Add at least one packaging")
            ],
            formControls: [
              AppFetcher(
                  api: '/packaging-options',
                  builder: (items, isLoading) => AppInputDropDown(
                        items: items,
                        name: 'packagingOptionId',
                        label: 'Packaging Option',
                        validators: [FormBuilderValidators.required()],
                      )),
              AppInputNumber(
                  name: 'quantity',
                  label: 'Quantity',
                  validators: [FormBuilderValidators.required()]),
            ],
            displayColumns: [
              AppFormArrayDisplayColumn(
                  label: 'Package', valueField: 'packagingOptionId'),
              AppFormArrayDisplayColumn(
                  label: 'Quantity', valueField: 'quantity')
            ],
            uniqueKeyField: 'packagingOptionId'),
        AppButton(onPress: () => _saveAndNext(), label: 'NEXT')
      ],
    );
  }
}
