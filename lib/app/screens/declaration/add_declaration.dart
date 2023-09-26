import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssmis_tz/app/listeners/message_listener.dart';
import 'package:ssmis_tz/app/providers/stock_declaration_provider.dart';
import 'package:ssmis_tz/app/screens/declaration/add_packaging.dart';
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

  List<Step> _steps = List.empty();

  @override
  void initState() {
    _declaration = widget.formValues ?? {};
    _declarationPremises = {
      'declarationPremises': widget.formValues?['declarationPremises'] ??
          List<Map<String, dynamic>>.empty(growable: true)
    };
    Future.delayed(Duration.zero,
        () => context.read<StockDeclarationProvider>().fetchPremises());
    _steps = getSteps();
    super.initState();
  }

  _onStepContinue() async {

  }

  _onProductStep(value) {
    debugPrint(value.toString());
    setState(() {
      _declaration = value;
      _activeStep++;
    });
  }

  _onPremiseStep(value) async {
    debugPrint(value.toString());
    var payload = {
      ..._declaration,
      'declarationPremises': _declarationPremises['declarationPremises']
    };
    Map<String, dynamic>? result =
        await context.read<StockDeclarationProvider>().save(payload);
    if (result != null && mounted) {
      Map<String, dynamic>? declaration = await context
          .read<StockDeclarationProvider>()
          .findByUuid(result['uuid']);
      setState(() {
        _declaration = declaration!;
        _steps = getSteps();
      });
      Future.delayed(Duration.zero, ()=> setState(() => _activeStep++) );
    }
  }

  _onPackageStepSaved() {
    setState(() {
      _activeStep++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MessageListener<StockDeclarationProvider>(
      child: Consumer<StockDeclarationProvider>(
        builder: (context, provider, child) {
          return AppBasePopUpScreen(
              title: 'Add Stock Request',
              isLoading: provider.isLoading,
              child: SingleChildScrollView(
                  child: Stepper(
                    key: Key(Random.secure().nextDouble().toString()),
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
                          ],
                        );
                      },
                      steps: _steps)));
        },
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
            title: const Text('Product'),
            content: ProductStep(
              formValues: _declaration,
              onNextStep: (value) => _onProductStep(value),
            )),
        Step(
            title: const Text('Premises'),
            content: PremiseStep(
              formValues: _declarationPremises,
              onNextStep: (value) => _onPremiseStep(value),
            )),
        ...(_declaration['declarationPremises'] ??
                List<Map<String, dynamic>>.empty())
            .map((d) => Step(
                title: Text('${d['premiseName']} Packaging'),
                content: AddPackaging(
                  declarationPremise: d,
                  onPackageStepSaved: () => _onPackageStepSaved(),
                ))),
        Step(
            title: const Text("Done"),
            content: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('DONE'),
            ))
      ];
}
