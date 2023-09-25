import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:ssmis_tz/app/api/api.dart';
import 'package:ssmis_tz/app/listeners/message_listener.dart';
import 'package:ssmis_tz/app/providers/stock_declaration_provider.dart';
import 'package:ssmis_tz/app/screens/declaration/add_packaging.dart';
import 'package:ssmis_tz/app/widgets/app_base_popup_screen.dart';
import 'package:ssmis_tz/app/widgets/app_fetcher.dart';
import 'package:ssmis_tz/app/widgets/app_form.dart';
import 'package:ssmis_tz/app/widgets/app_input_dropdown.dart';
import 'package:ssmis_tz/app/widgets/app_input_form_array.dart';
import 'package:ssmis_tz/app/widgets/app_input_number.dart';

class AddStockDeclarationScreen extends StatefulWidget {
  final Map<String, dynamic>? formValues;

  const AddStockDeclarationScreen({Key? key, this.formValues})
      : super(key: key);

  @override
  State<AddStockDeclarationScreen> createState() =>
      _AddStockDeclarationScreenState();
}

class _AddStockDeclarationScreenState extends State<AddStockDeclarationScreen> {
  final _productForm = GlobalKey<FormBuilderState>();
  final _premiseForm = GlobalKey<FormBuilderState>();
  bool _productFormError = false;
  bool _premiseFormError = false;
  bool _totalPremiseError = false;
  late Map<String, dynamic> _declaration;
  late Map<String, dynamic> _declarationPremises;
  List<Map<String, dynamic>> products = List.empty(growable: true);
  int _activeStep = 0;

  @override
  void initState() {
    List<Map<String, dynamic>> declarationPremises = [];
    _declarationPremises = {
      'declarationPremises':
          widget.formValues?['declarationPremises'] ?? declarationPremises
    };
    _declaration = widget.formValues ?? {};
    if (_declaration['cropId'] != null) {
      loadProduct(_declaration['cropId']);
    }
    Future.delayed(Duration.zero,
        () => context.read<StockDeclarationProvider>().fetchPremises());
    super.initState();
  }

  loadProduct(int cropId) async {
    var resp = await Api().dio.get("/crop-products?cropId=$cropId");
    if (resp.statusCode == 200) {
      setState(() => products = (resp.data['data'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList());
    } else {
      if (mounted) {
        context
            .read<StockDeclarationProvider>()
            .notifyError(resp.data['message']);
      }
    }
  }

  _onStepContinue() async {
    switch (_activeStep) {
      case 0:
        if (_productForm.currentState?.saveAndValidate() == true) {
          setState(() => {_premiseFormError = false, _activeStep = 1});
        } else {
          setState(() => {_premiseFormError = true});
        }
        _premiseForm.currentState?.saveAndValidate();
        debugPrint(_premiseForm.currentState?.value.toString());
        break;
      case 1:
        /*If premise form is valid check quantity of the product form equals to sum of premise quantity
       else set premise form has error.
       IF premise form is valid save the declaration and go to packaging option Step
      */
        if (_premiseForm.currentState?.saveAndValidate() == true) {
          setState(
              () => {_premiseFormError = false, _totalPremiseError = false});
          double totalQuantity = _productForm.currentState!.value['quantity'];
          double totalPremiseQuantity = (_premiseForm.currentState!
                  .value['declarationPremises'] as List<Map<String, dynamic>>)
              .map((e) => e['quantity'] as double)
              .fold(0, (value, next) => value + next);
          if (totalQuantity != totalPremiseQuantity) {
            setState(() => {_totalPremiseError = true});
          } else {
            //Save declaration first and go to
            Map<String, dynamic>? result = await _save();
            if (result != null) {
              setState(() => {
                    _premiseFormError = false,
                    _totalPremiseError = false,
                    _activeStep = 2,
                    _declaration = result
                  });
            }
          }
        } else {
          setState(() => {_premiseFormError = true});
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MessageListener<StockDeclarationProvider>(
      child: Consumer<StockDeclarationProvider>(
        builder: (context, provider, child) {
          return AppBasePopUpScreen(
              title: 'Add Declaration',
              child: SingleChildScrollView(
                  child: Stepper(
                physics: const ClampingScrollPhysics(),
                currentStep: _activeStep,
                elevation: 2,
                margin: const EdgeInsets.fromLTRB(52, 4, 16, 2),
                onStepContinue: () => _onStepContinue(),
                onStepCancel: () {
                  if (_activeStep > 0) {
                    setState(() => {_activeStep -= 1});
                  }
                },
                controlsBuilder: (context, details) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      if (_activeStep != 0)
                        TextButton(
                          onPressed: details.onStepCancel,
                          child: const Text('BACK'),
                        ),
                      _activeStep == 2
                          ? ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('DONE'))
                          : ElevatedButton(
                              onPressed: details.onStepContinue,
                              child: const Text('NEXT'),
                            ),
                    ],
                  );
                },
                steps: [
                  Step(
                      title: const Text('Product'),
                      content: AppForm(
                          formKey: _productForm,
                          initialValue: _declaration,
                          controls: [
                            AppFetcher(
                                api: '/subsidy-declarations/declaration-types',
                                builder: (items, isLoading) => AppInputDropDown(
                                      items: items,
                                      name: 'declarationType',
                                      label: isLoading
                                          ? 'Loading..'
                                          : 'Declaration Type',
                                    )),
                            AppFetcher(
                                api: '/crops',
                                builder: (items, isLoading) => AppInputDropDown(
                                    onChange: (cropId) => loadProduct(cropId),
                                    items: items,
                                    name: 'cropId',
                                    label: 'Crop')),
                            AppInputDropDown(
                              items: products,
                              name: 'productId',
                              valueColumn: 'productId',
                              label: 'Product',
                              displayValue: 'productName',
                            ),
                            const AppInputNumber(
                                name: 'quantity', label: 'Quantity'),
                          ])),
                  Step(
                      title: const Text('Premises'),
                      subtitle: _totalPremiseError
                          ? const Text(
                              "Total premise amount should be equal to total product amount",
                              style: TextStyle(
                                  fontSize: 10, color: Colors.redAccent))
                          : null,
                      content: AppForm(
                        formKey: _premiseForm,
                        initialValue: _declarationPremises,
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
                                  displayValueBuilder: (premiseId) => Text(
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
                        ],
                      )),
                  Step(
                      title: const Text('Packaging'),
                      content: Column(
                        children: [
                          ...(_declaration['declarationPremises'] ?? [])
                              .map((d) => AddPackaging(declarationPremise: d))
                        ],
                      ))
                ],
              )));
        },
      ),
    );
  }

  Future<Map<String, dynamic>?> _save() async {
    var payload = {
      ..._productForm.currentState!.value,
      'declarationPremises':
          _premiseForm.currentState!.value['declarationPremises']
    };
    try {
      var resp = await (payload['id'] != null
          ? Api()
              .dio
              .put('/subsidy-declarations/${payload['id']}', data: payload)
          : Api().dio.post('/subsidy-declarations', data: payload));
      if (mounted && [200, 201].contains(resp.statusCode)) {
        return resp.data['data'] as Map<String, dynamic>;
      }
    } catch (e) {
      context.read<StockDeclarationProvider>().notifyError(e.toString());
    }
    return null;
  }
}
