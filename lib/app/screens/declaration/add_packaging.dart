import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tfra_mobile/app/api/api.dart';
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
  late Map<String, dynamic> _declarationPremise;

  @override
  void initState() {
    _declarationPremise = {
      'declarationPremiseId': widget.declarationPremise['id'],
      'packagingRequests': widget.declarationPremise['packagingRequests'] ?? []
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.declarationPremise['premiseName']),
        IconButton(onPressed: () => _add(), icon: Icon(Icons.add))
      ],
    );
  }

  _add() {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (BuildContext context) {

          save() async{
            //TODO amount validation
            if(_packagingForm.currentState?.saveAndValidate() == true) {
              var payload = _packagingForm.currentState!.value;
              debugPrint(payload.toString());
              var resp = await Api().dio.post("/subsidy-declarations/add-packaging-requests",data: payload);
              if(mounted){
                Navigator.pop(context);
              }
            }
          }
          return Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: ListView(
                children: [
                  AppForm(
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
                          formControls: [
                            AppFetcher(
                                api: '/packaging-options',
                                builder: (items, isLoading) => AppInputDropDown(
                                    items: items,
                                    name: 'packagingOptionId',
                                    label: 'Packaging Option')),
                            AppInputNumber(name: 'quantity', label: 'Quantity'),
                          ],
                          displayColumns: [
                            AppFormArrayDisplayColumn(
                                label: 'Quantity', valueField: 'quantity')
                          ],
                          uniqueKeyField: 'packagingOptionId')
                    ],
                  ),
                  AppButton(onPress: () => save(), label: 'Save')
                ],
              ));
        });
  }
}
