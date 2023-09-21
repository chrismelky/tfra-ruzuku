import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/listeners/message_listener.dart';
import 'package:tfra_mobile/app/models/stock_transfer.dart';
import 'package:tfra_mobile/app/providers/receive_stock_provider.dart';
import 'package:tfra_mobile/app/widgets/app_base_popup_screen.dart';
import 'package:tfra_mobile/app/widgets/app_button.dart';
import 'package:tfra_mobile/app/widgets/app_form.dart';
import 'package:tfra_mobile/app/widgets/app_input_form_array.dart';
import 'package:tfra_mobile/app/widgets/app_input_number.dart';
import 'package:tfra_mobile/app/widgets/app_input_text.dart';

class ReceiveStockDetailScreen extends StatefulWidget {
  final StockTransfer stockTransfer;

  const ReceiveStockDetailScreen({Key? key, required this.stockTransfer})
      : super(key: key);

  @override
  State<ReceiveStockDetailScreen> createState() =>
      _ReceiveStockDetailScreenState();
}

class _ReceiveStockDetailScreenState extends State<ReceiveStockDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late Map<String, dynamic> _formValues;
  late StockTransfer _transfer;

  @override
  void initState() {
    _transfer = widget.stockTransfer;
    _formValues = {
      'uuid': _transfer.uuid,
      'stockTransferItems': _transfer.stockTransferItems.map((e) =>
      {
        'uuid': e.uuid,
        'productName': '${e.productName} ${e.packagingOptionName}',
        'quantity': e.quantity,
        'receivedQuantity': null,
        'adjustmentReason': null
      }).toList()
    };
    super.initState();
  }

  _receive() async {
    if (_formKey.currentState!.saveAndValidate() == true) {
      var payload = _formKey.currentState!.value;
      (payload['stockTransferItems'] as List<Map<String, dynamic>>)
          .asMap()
          .forEach((key, item) {
        if (item['receivedQuantity'] == null) {

        }
      });
      bool received = await context.read<ReceiveStockProvider>().receive(
          payload);
      if (received && mounted) {
        Navigator.of(context).pop(received);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MessageListener<ReceiveStockProvider>(
      child: AppBasePopUpScreen(
          title: 'Receive Stock',
          child: SingleChildScrollView(
            child: AppForm(
              formKey: _formKey,
              initialValue: _formValues,
              controls: [
                AppInputFormArray(
                    name: 'stockTransferItems',
                    label: 'Items',
                    canAdd: false,
                    canDelete: false,
                    formKey: _formKey,
                    formControls: [
                      const AppInputText(
                        fieldName: 'productName',
                        label: 'Product',
                        enabled: false,
                      ),
                      const AppInputNumber(
                        name: 'quantity',
                        label: 'Quantity Transferred',
                        enabled: false,
                      ),
                      AppInputNumber(
                        name: 'receivedQuantity',
                        label: 'Quantity Received',
                        validators: [
                          FormBuilderValidators.required(
                              errorText: "Received quantity required")
                        ],
                      )
                    ],
                    displayColumns: [
                      AppFormArrayDisplayColumn(
                          label: 'Product', valueField: 'productName'),
                      AppFormArrayDisplayColumn(
                          label: 'Transferred Quantity',
                          valueField: 'quantity'),
                      AppFormArrayDisplayColumn(
                          label: 'Received Quantity',
                          valueField: 'receivedQuantity')
                    ],
                    uniqueKeyField: 'uuid'),

                AppButton(onPress: () => _receive(), label: 'RECEIVE')
              ],
            ),
          )),
    );
  }
}
