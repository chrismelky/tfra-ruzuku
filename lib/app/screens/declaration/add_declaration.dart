import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/api/api.dart';
import 'package:tfra_mobile/app/providers/stock_declaration_provider.dart';
import 'package:tfra_mobile/app/widgets/app_base_popup_screen.dart';
import 'package:tfra_mobile/app/widgets/app_base_screen.dart';
import 'package:tfra_mobile/app/widgets/app_button.dart';
import 'package:tfra_mobile/app/widgets/app_fetcher.dart';
import 'package:tfra_mobile/app/widgets/app_form.dart';
import 'package:tfra_mobile/app/widgets/app_input_dropdown.dart';
import 'package:tfra_mobile/app/widgets/app_input_form_array.dart';
import 'package:tfra_mobile/app/widgets/app_input_number.dart';

class AddStockDeclarationScreen extends StatefulWidget {
  const AddStockDeclarationScreen({Key? key}) : super(key: key);

  @override
  State<AddStockDeclarationScreen> createState() =>
      _AddStockDeclarationScreenState();
}

class _AddStockDeclarationScreenState extends State<AddStockDeclarationScreen> {
  final _declarationForm = GlobalKey<FormBuilderState>();

  final List<Map<String, dynamic>> _stockTypes = [
    {'id': 'IMPORTATION', 'name': 'IMPORTATION'},
    {'id': 'MANUFACTURED', 'name': 'MANUFACTURED'}
  ];
  List<Map<String, dynamic>> products = List.empty(growable: true);

  loadProduct(int cropId) async {
    var resp = await Api().dio.get("/crop-products?cropId=$cropId");
    if (resp.statusCode == 200) {
      setState(() => products = (resp.data['data'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBasePopUpScreen(
        title: 'Add Declaration',
        child: SingleChildScrollView(
            child:
                AppForm(formKey: _declarationForm, initialValue: {}, controls: [
          AppInputDropDown(
            items: _stockTypes,
            name: 'declarationType',
            label: 'Declaration Type',
          ),
          AppFetcher(
              api: '/crops',
              builder: (items, isLoading) => AppInputDropDown(
                  onChange: (cropId) => loadProduct(cropId),
                  items: items,
                  name: 'productId',
                  label: 'Crop')),
          AppInputDropDown(
            items: products,
            name: 'productId',
            label: 'Product',
            displayValue: 'productName',
          ),
          const AppInputNumber(name: 'quantity', label: 'Quantity'),
          AppInputFormArray(
            formKey: _declarationForm,
            name: 'declarationPremises',
            label: 'Premise Stock',
            uniqueKeyField: 'id',
            validators: [
              FormBuilderValidators.required(
                  errorText: "Add at least one usage")
            ],
            displayColumns: [
              AppFormArrayDisplayColumn(
                  label: "Premise", valueField: 'premiseId', width: 170.0),
              AppFormArrayDisplayColumn(
                  label: "Quantity", valueField: 'quantity', width: 80.0),
            ],
            formControls: [
              AppFetcher(
                  api: '/premises',
                  builder: (items, isLoading) => AppInputDropDown(
                      items: items, name: 'premiseId', label: 'Premise')),
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
          AppButton(onPress: () => _save(), label: "Submit")
        ])));
  }

  _save() async {
    if (_declarationForm.currentState?.saveAndValidate() == true) {
      var payload = _declarationForm.currentState?.value;
      debugPrint(payload.toString());
      try {
        var resp = await Api().dio.post('/subsidy-declarations', data: payload);
        if (mounted && [200, 201].contains(resp.statusCode)) {
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        context.read<StockDeclarationProvider>().notifyError(e.toString());
      }
    }
  }
}
