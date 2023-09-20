import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/api/api.dart';
import 'package:tfra_mobile/app/providers/stock_transfer_provider.dart';
import 'package:tfra_mobile/app/widgets/app_base_popup_screen.dart';
import 'package:tfra_mobile/app/widgets/app_button.dart';
import 'package:tfra_mobile/app/widgets/app_fetcher.dart';
import 'package:tfra_mobile/app/widgets/app_form.dart';
import 'package:tfra_mobile/app/widgets/app_input_dropdown.dart';
import 'package:tfra_mobile/app/widgets/app_input_form_array.dart';
import 'package:tfra_mobile/app/widgets/app_input_hidden.dart';
import 'package:tfra_mobile/app/widgets/app_input_number.dart';

class AddStockTransferScreen extends StatefulWidget {
  final Map<String, dynamic>? formValues;

  const AddStockTransferScreen({Key? key, this.formValues}) : super(key: key);

  @override
  State<AddStockTransferScreen> createState() => _AddStockTransferScreenState();
}

class _AddStockTransferScreenState extends State<AddStockTransferScreen> {
  final _transferForm = GlobalKey<FormBuilderState>();
  String? selectedType;
  List<Map<String, dynamic>> premises = List.empty(growable: true);
  List<Map<String, dynamic>> stockCards = List.empty(growable: true);
  late Map<String, dynamic> _transferFormInitValues;

  @override
  void initState() {
    loadStockCards();
    if (widget.formValues != null) {
      selectedType = widget.formValues!['transactionType'];
      _transferFormInitValues = {
        ...widget.formValues!,
        'transferType': selectedType
      };
    } else {
      List<Map<String, dynamic>> stockTransferItems = [];
      _transferFormInitValues = {'stockTransferItems': stockTransferItems};
    }
    super.initState();
  }

  loadStockCards() async {
    var resp = await Api().dio.get("/stock-cards");
    if (resp.statusCode == 200) {
      setState(() => stockCards = (resp.data['data'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .map((e) =>
              {...e, 'name': "${e['productName']} ${e['packagingOptionName']}"})
          .toList());
    }
  }

  loadPremise(int agroDealerId) async {
    var resp = await Api().dio.get("/premises/by-agro-dealer/$agroDealerId");
    if (resp.statusCode == 200) {
      setState(() => premises = (resp.data['data'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList());
    }
  }

  final List<Map<String, dynamic>> _transferTypes = [
    {'id': 'PREMISE_TRANSFER', 'name': 'PREMISE_TRANSFER'},
    {'id': 'DEALER_TRANSFER', 'name': 'DEALER_TRANSFER'}
  ];

  @override
  Widget build(BuildContext context) {
    return AppBasePopUpScreen(
        title: 'Add Transfer',
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppForm(
                formKey: _transferForm,
                initialValue: _transferFormInitValues,
                controls: [
                  AppInputDropDown(
                    items: _transferTypes,
                    name: 'transferType',
                    label: 'Transfer Type',
                    onChange: (value) => setState(() => selectedType = value),
                  ),
                  Builder(builder: (_) {
                    if (selectedType == 'DEALER_TRANSFER') {
                      return AppFetcher(
                          api: '/agro-dealers/mapped-dealers',
                          builder: (items, isLoading) => AppInputDropDown(
                              items: items,
                              name: 'toAgroDealerId',
                              label: 'To AgroDealer'));
                    }
                    return const AppInputHidden(
                      fieldName: '_',
                      value: 0,
                    );
                  }),
                  if (selectedType != null)
                    Builder(builder: (_) {
                      if (selectedType == 'DEALER_TRANSFER') {
                        return AppInputDropDown(
                            items: premises,
                            name: 'toPremiseId',
                            label: 'Premise');
                      }
                      return AppFetcher(
                          api: '/premises',
                          builder: (items, isLoading) => AppInputDropDown(
                              items: items,
                              name: 'toPremiseId',
                              label: 'Premise'));
                    }),
                  AppInputFormArray(
                    name: 'stockTransferItems',
                    label: 'Stock Items',
                    uniqueKeyField: 'stockCardUuid',
                    formKey: _transferForm,
                    formControls: [
                      AppInputDropDown(
                        items: stockCards,
                        name: 'stockCardUuid',
                        valueColumn: 'uuid',
                        label: 'Stock Item',
                      ),
                      const AppInputNumber(name: 'quantity', label: 'Quantity'),
                      const AppInputNumber(
                          name: 'unitPricePaid', label: 'Price Pain'),
                    ],
                    displayColumns: [
                      AppFormArrayDisplayColumn(
                          label: 'Item',
                          valueField: 'stockCardUuid',
                          displayValueBuilder: (stockCardUuid) => Text(
                              stockCards.firstWhere(
                                  (e) => e['uuid'] == stockCardUuid,
                                  orElse: () => {})['name'])),
                      AppFormArrayDisplayColumn(
                          label: 'Quantity', valueField: 'quantity'),
                    ],
                  ),
                  AppButton(onPress: () => _save(), label: "Submit")
                ],
              ),
            ],
          ),
        ));
  }

  _save() async {
    if (_transferForm.currentState?.saveAndValidate() == true) {
      var formData = _transferForm.currentState!.value;
      debugPrint(formData.toString());
      var payload = {
        ...formData,
        'stockTransferItems': formData['stockTransferItems'].map((i) {
          var stockCard = stockCards.firstWhere(
              (e) => e['uuid'] == i['stockCardUuid'],
              orElse: () => {});
          return {
            ...i,
            'productId': stockCard['productId'],
            'packagingOptionId': stockCard['packagingOptionId'],
          };
        }).toList()
      };
      debugPrint(payload.toString());
      try {
        var resp = await (payload['id'] != null
            ? Api().dio.put('/stock-transfers/${payload['uuid']}', data: payload)
            : Api().dio.post('/stock-transfers', data: payload));
        if (mounted && [200, 201].contains(resp.statusCode)) {
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        context.read<StockTransferProvider>().notifyError(e.toString());
      }
    }
  }
}
