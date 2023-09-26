import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:ssmis_tz/app/providers/stock_declaration_provider.dart';
import 'package:ssmis_tz/app/widgets/app_button.dart';
import 'package:ssmis_tz/app/widgets/app_form.dart';
import 'package:ssmis_tz/app/widgets/app_input_dropdown.dart';
import 'package:ssmis_tz/app/widgets/app_input_form_array.dart';
import 'package:ssmis_tz/app/widgets/app_input_number.dart';


class PremiseStep extends StatefulWidget {
  final Map<String, dynamic> formValues;
  final Function? onNextStep;

  const PremiseStep({Key? key, required this.formValues, this.onNextStep}) : super(key: key);

  @override
  State<PremiseStep> createState() => _PremiseStepState();
}

class _PremiseStepState extends State<PremiseStep> {
  final _premiseForm = GlobalKey<FormBuilderState>();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StockDeclarationProvider>(
      builder: (context, provider, child) {
        return AppForm(
          formKey: _premiseForm,
          initialValue: widget.formValues,
          controls: [
            AppInputFormArray(
              formKey: _premiseForm,
              name: 'declarationPremises',
              label: 'Premise Stock',
              uniqueKeyField: 'premiseId',
              validators: [
                FormBuilderValidators.required(
                    errorText: "Add at least one premise")
              ],
              displayColumns: [
                AppFormArrayDisplayColumn(
                    label: "Premise",
                    valueField: 'premiseId',
                    displayValueBuilder: (premiseId) =>
                        Text(
                            provider.premises.firstWhere(
                                    (e) => e['id'] == premiseId,
                                orElse: () => {})['name'] ??
                                ''),
                    width: 170.0),
                AppFormArrayDisplayColumn(
                    label: "Quantity",
                    valueField: 'quantity',
                    width: 80.0),
              ],
              formControls: [
                AppInputDropDown(
                    items: provider.premises,
                    name: 'premiseId',
                    label: 'Premise'),
                AppInputNumber(
                  name: 'quantity',
                  label: 'Quantity',
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Quantity is required"),
                  ],
                ),
              ],
            ),
            AppButton(onPress: () => _validateAndNext(), label: 'NEXT')
          ],
        );
      },
    );
  }

  _validateAndNext() async {
    if (_premiseForm.currentState?.saveAndValidate() == true)  {

      widget.onNextStep!(_premiseForm.currentState?.value);
    }
  }
}
