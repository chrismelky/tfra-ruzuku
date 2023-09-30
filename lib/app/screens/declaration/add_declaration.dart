import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssmis_tz/app/listeners/message_listener.dart';
import 'package:ssmis_tz/app/models/stock_declaration.dart';
import 'package:ssmis_tz/app/providers/stock_declaration_provider.dart';
import 'package:ssmis_tz/app/screens/declaration/add_packaging.dart';
import 'package:ssmis_tz/app/screens/declaration/packaging_step.dart';
import 'package:ssmis_tz/app/screens/declaration/premise_step.dart';
import 'package:ssmis_tz/app/screens/declaration/product_step.dart';
import 'package:ssmis_tz/app/widgets/app_base_popup_screen.dart';

class AddStockDeclarationScreen extends StatefulWidget {
  final Map<String, dynamic>? formValues;

  const AddStockDeclarationScreen({Key? key, this.formValues})
      : super(key: key);

  @override
  State<AddStockDeclarationScreen> createState() =>
      _AddStockDeclarationScreenState();
}

class _AddStockDeclarationScreenState extends State<AddStockDeclarationScreen> {
  late Map<String, dynamic> _declaration;
  late Map<String, dynamic> _declarationPremises;
  int _activeStep = 0;

  @override
  void initState() {
    _declaration = widget.formValues ?? {};
    _declarationPremises = {
      'declarationPremises': widget.formValues?['declarationPremises'] ??
          List<Map<String, dynamic>>.empty(growable: true)
    };
    Future.delayed(Duration.zero,
        () => context.read<StockDeclarationProvider>().fetchPremises());
    super.initState();
  }

  _onStepContinue() async {}

  _onProductStep(value) {
    setState(() {
      _declaration = value;
      _activeStep++;
    });
  }

  _onPremiseStep(value) async {
    var payload = {
      ..._declaration,
      'declarationPremises': value['declarationPremises']
    };
    Map<String, dynamic>? result =
        await context.read<StockDeclarationProvider>().save(payload);
    if (result != null && mounted) {
      Map<String, dynamic>? declaration = await context
          .read<StockDeclarationProvider>()
          .findByUuid(result['uuid']);
      setState(() {
        _declaration = StockDeclaration.fromJson(declaration!).toJson();
        _activeStep++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MessageListener<StockDeclarationProvider>(
      child: Consumer<StockDeclarationProvider>(
        builder: (context, provider, child) {
          return AppBasePopUpScreen(
              title: 'Add Stock Request',
              padding: 0,
              isLoading: provider.isLoading,
              child: Stepper(
                  type: StepperType.horizontal,
                  physics: const ClampingScrollPhysics(),
                  currentStep: _activeStep,
                  elevation: 1,
                  margin: const EdgeInsets.all(0),
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
                      ],
                    );
                  },
                  steps: [
                    Step(
                        title: const Text('Product'),
                        state: _activeStep == 0
                            ? StepState.editing
                            : StepState.complete,
                        content: ProductStep(
                          formValues: _declaration,
                          onNextStep: (value) => _onProductStep(value),
                        )),
                    Step(
                        title: const Text('Premises'),
                        state: _activeStep == 1
                            ? StepState.editing
                            : _activeStep < 1
                                ? StepState.disabled
                                : StepState.complete,
                        content: PremiseStep(
                          formValues: _declarationPremises,
                          onNextStep: (value) => _onPremiseStep(value),
                        )),
                    Step(
                      state: _activeStep == 2 ? StepState.editing : StepState.disabled,
                      title: const Text("Packages"),
                      content: SingleChildScrollView(
                        child: PackagingStep(
                          requestPremises: _declaration['declarationPremises'] ??
                              List<Map<String, dynamic>>.empty(),
                          onPackageStepComplete: (value) => Navigator.of(context).pop(true),
                        ),
                      ),
                    )
                  ]));
        },
      ),
    );
  }
}
