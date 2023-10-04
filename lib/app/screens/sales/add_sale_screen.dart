import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ssmis_tz/app/listeners/message_listener.dart';
import 'package:ssmis_tz/app/models/client_type.dart';
import 'package:ssmis_tz/app/models/sale.dart';
import 'package:ssmis_tz/app/models/sale_status.dart';
import 'package:ssmis_tz/app/screens/sales/add_package_input.dart';
import 'package:ssmis_tz/app/screens/sales/client_select_field.dart';
import 'package:ssmis_tz/app/providers/sale_provider.dart';
import 'package:ssmis_tz/app/screens/sales/otp_dialog.dart';
import 'package:ssmis_tz/app/widgets/app_base_popup_screen.dart';
import 'package:ssmis_tz/app/widgets/app_form.dart';
import 'package:ssmis_tz/app/widgets/app_input_date.dart';
import 'package:ssmis_tz/app/widgets/app_input_dropdown.dart';

class AddSaleScreen extends StatefulWidget {
  final Sale? sale;

  const AddSaleScreen({super.key, this.sale});

  @override
  State<AddSaleScreen> createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends State<AddSaleScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late Map<String, dynamic> _initialFormValues;
  late Sale? _selectedSale;

  @override
  void initState() {
    _selectedSale = widget.sale;
    _initialFormValues = _selectedSale != null
        ? {
            ..._selectedSale!.toJson(),
            'transactionDate': _selectedSale?.transactionDate
          }
        : {
      "transactionDate": DateTime.now(),
      "saleTransactionPackages": List<Map<String, dynamic>>.empty(growable: true)};
    super.initState();
  }

  void saveSale(SaleStatus byStatus) async {
    if (_formKey.currentState!.saveAndValidate()) {
      Map<String, dynamic> payload = {
        ..._formKey.currentState!.value,
        "saleStatus": byStatus.name,
        "transactionDate": DateFormat('yyyy-MM-dd')
            .format(_formKey.currentState!.fields["transactionDate"]!.value)
      };
      if (byStatus == SaleStatus.SOLD) {
        bool? generated =
            await context.read<SaleProvider>().generateOtp(payload);
        if (generated == true && mounted) {
          String? otp = await otpDialog(context, payload);
          if (otp != null && mounted) {
            context
                .read<SaleProvider>()
                .confirmSale(payload, otp)
                .then((isSaved) {
              if (isSaved) {
                Navigator.of(context).pop(true);
              }
            });
          }
        }
      } else {
        context.read<SaleProvider>().saveAndHold(payload).then((isSaved) {
          if (isSaved) {
            Navigator.of(context).pop(true);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MessageListener<SaleProvider>(
      child: Consumer<SaleProvider>(
        builder: (context, provider, child) {
          return AppBasePopUpScreen(
            title: 'Add Sale',
            isLoading: provider.isLoading,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: OutlinedButton(
                              onPressed: () => saveSale(SaleStatus.NEW),
                              child: Text('Save and Hold',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor)))),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: OutlinedButton(
                              onPressed: () => saveSale(SaleStatus.SOLD),
                              child: Text('Confirm Sale',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor))))
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  AppForm(
                    formKey: _formKey,
                    initialValue: _initialFormValues,
                    controls: [
                      AppInputDate(
                          name: 'transactionDate',
                          label: 'Transaction Date',
                          disabled: true,
                          validators: [
                            FormBuilderValidators.required(
                                errorText: "Transaction date is required")
                          ]),
                      AppInputDropDown(
                        items: ClientType.values
                            .map((e) => {'id': e.name, 'name': e.name})
                            .toList(),
                        name: 'partyType',
                        label: 'Client Type',
                        validators: [
                          FormBuilderValidators.required(
                              errorText: "Client is required")
                        ],
                      ),
                      ClientSelectField(
                          name: 'partyId',
                          clientName: _selectedSale?.partyName,
                          clientType: ClientType.FARMER.name),
                      const AddPackageInputField(
                          name: 'saleTransactionPackages')
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget packageTitle(Map<String, dynamic> package) =>
      Text("${package['fertilizerName']} - ${package['qrCodeNumber']}");

  Widget packageSubTitle(Map<String, dynamic> package) => Text(
      "brand: ${package['fertilizerDealerName']}, (${package['quantity']})kg");

  @override
  void dispose() {
    super.dispose();
  }
}
