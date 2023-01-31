import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/models/client_type.dart';
import 'package:tfra_mobile/app/models/sale.dart';
import 'package:tfra_mobile/app/models/sale_package.dart';
import 'package:tfra_mobile/app/models/sale_status.dart';
import 'package:tfra_mobile/app/models/searched_client.dart';
import 'package:tfra_mobile/app/screens/sales/search_client_dialog.dart';
import 'package:tfra_mobile/app/shared/shared.dart';
import 'package:tfra_mobile/app/state/sale_state.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:tfra_mobile/app/theme/form_controls.dart';
import 'package:intl/intl.dart';

class CreateSaleScreen extends StatefulWidget {
  const CreateSaleScreen({super.key});

  @override
  State<CreateSaleScreen> createState() => _CreateSaleScreenState();
}

class _CreateSaleScreenState extends State<CreateSaleScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late Sale _selectedSale;

  late Function _showMessage;
  late Function _showError;

  @override
  void initState() {
    _selectedSale = context.read<SaleState>().sale!;
    _showMessage = appMessage(context);
    _showError = appError(context);
    super.initState();
  }

  Future<void> openClientDialog(BuildContext context, String partyType) async {
    SearchedClient? client = await searchClientDialog(context, partyType);
    if (client != null) {
      _selectedSale.partyName = client.name;
      _formKey.currentState?.fields['partyId']?.didChange(client.id);
    }
  }

  Future<void> openQrScanner() async {
    try {
      final cameraPerm = await Permission.camera.request();
      if (cameraPerm.isGranted) {
        String? cameraScanResult = await scanner.scan();
        if (cameraScanResult != null) {
          Map<String, dynamic> fromScanner = jsonDecode(cameraScanResult);
          List<Map<String, dynamic>> currentPackages =
              _formKey.currentState!.fields['saleTransactionPackages']!.value!;

          bool exist = currentPackages
              .any((element) => element['qrCodeNumber'] == fromScanner['qr']);

          if (!exist) {
            currentPackages.add(SalePackage.fromScanner(fromScanner).toJson());
            _formKey.currentState?.fields['saleTransactionPackages']
                ?.didChange(currentPackages);
          }
        }
      } else {
        throw Exception("No permission to use camera");
      }
    } catch (e) {
      debugPrint(e.toString());
      _showError(e.toString());
    }
  }

  void deletePackage(String qrCodeNumber) {
    List<Map<String, dynamic>> currentPackages =
        _formKey.currentState!.fields['saleTransactionPackages']!.value!;

    currentPackages
        .removeWhere((element) => element['qrCodeNumber'] == qrCodeNumber);

    _formKey.currentState?.fields['saleTransactionPackages']
        ?.didChange(currentPackages);
  }

  void saveSale(SaleStatus byStatus) {
    if (_formKey.currentState!.saveAndValidate()) {
      Map<String, dynamic> payload = {
        ..._formKey.currentState!.value,
        "uuid": _selectedSale.uuid,
        "saleStatus": byStatus.name,
        "transactionDate": DateFormat('yyyy-MM-dd')
            .format(_formKey.currentState!.fields["transactionDate"]!.value)
      };

      context
          .read<SaleState>()
          .saveSale(payload, _showMessage, _showError)
          .then((isSaved) {
        debugPrint(isSaved.toString());
        if (isSaved) {
          context.go("/");
          Provider.of<SaleState>(context, listen: false).loadSales(_showError);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create or Update Sale"),
        ),
        body: FormBuilder(
            key: _formKey,
            initialValue: _selectedSale.toJson(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(1.0, 8.0, 0.0, 8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: FormBuilderDateTimePicker(
                        name: "transactionDate",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        validator: FormBuilderValidators.required(
                            errorText: "Select transaction date"),
                        decoration: saleDatePickerDecoration("Select Date"),
                        inputType: InputType.date,
                      )),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: FormBuilderDropdown<String>(
                          name: 'partyType',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black),
                          decoration:
                              saleDropdownDecoration("Select Client Type"),
                          validator: FormBuilderValidators.required(
                              errorText: "Select client type"),
                          items: ClientType.values
                              .map((type) => DropdownMenuItem(
                                    value: type.name,
                                    child: Text(type.name),
                                  ))
                              .toList(growable: false),
                        ),
                      ),
                    ],
                  ),
                ),
                FormBuilderField(
                    name: "partyId",
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Please Select customer"),
                    ]),
                    builder: (FormFieldState<dynamic> field) {
                      return ListTile(
                        style: ListTileStyle.drawer,
                        contentPadding:
                            const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                        dense: true,
                        title: Text(
                            _selectedSale.partyName ?? "No Client selected"),
                        subtitle: field.hasError
                            ? Text(
                                field.errorText!,
                                style: const TextStyle(color: Colors.red),
                              )
                            : null,
                        trailing:
                            _selectedSale.saleStatus != SaleStatus.SOLD.name
                                ? IconButton(
                                    icon: const Icon(Icons.person),
                                    onPressed: () {
                                      openClientDialog(
                                          context,
                                          _formKey.currentState!
                                              .fields['partyType']!.value);
                                    },
                                  )
                                : null,
                        onTap: () {
                          openClientDialog(
                              context,
                              _formKey
                                  .currentState!.fields['partyType']!.value);
                        },
                      );
                    }),
                const Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 107, 107, 107),
                ),
                Expanded(
                    child: FormBuilderField<List<Map<String, dynamic>>>(
                  name: 'saleTransactionPackages',
                  validator: FormBuilderValidators.minLength(1,
                      errorText: "At least 1 package is required"),
                  builder: (field) {
                    return Column(children: [
                      ListTile(
                        onTap: () => openQrScanner(),
                        style: ListTileStyle.drawer,
                        contentPadding:
                            const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                        title: Text("Total packages  ${field.value?.length}"),
                        dense: true,
                        subtitle: field.hasError
                            ? Text(field.errorText!,
                                style: const TextStyle(color: Colors.red))
                            : null,
                        trailing: _selectedSale.saleStatus !=
                                SaleStatus.SOLD.name
                            ? IconButton(
                                icon: const Icon(
                                  Icons.qr_code,
                                  color: Colors.green,
                                ),
                                onPressed: () => openQrScanner(),
                              )
                            : Chip(
                                label: Text(
                                  _selectedSale.saleStatus,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.green,
                              ),
                      ),
                      const Divider(
                        thickness: 1,
                        height: 1,
                        color: Color.fromARGB(255, 107, 107, 107),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Expanded(
                          child: ListView.builder(
                              itemCount: field.value?.length,
                              itemBuilder: ((context, index) {
                                return Column(
                                  children: [
                                    ListTile(
                                      dense: true,
                                      title: field.value!.isNotEmpty
                                          ? packageTitle(field.value![index])
                                          : const Text("No data"),
                                      subtitle: field.value!.isNotEmpty
                                          ? packageSubTitle(field.value![index])
                                          : null,
                                      leading: const Icon(Icons.shopping_bag),
                                      trailing: _selectedSale.saleStatus !=
                                              SaleStatus.SOLD.name
                                          ? IconButton(
                                              icon: const Icon(
                                                Icons.remove_circle,
                                                color: Color.fromARGB(
                                                    255, 255, 107, 97),
                                              ),
                                              onPressed: () {
                                                deletePackage(
                                                    field.value![index]
                                                        ['qrCodeNumber']);
                                              },
                                            )
                                          : null,
                                      onTap: () {
                                        debugPrint("Edit");
                                      },
                                    ),
                                    const Divider(
                                      thickness: 1,
                                    )
                                  ],
                                );
                              })))
                    ]);
                  },
                ))
              ],
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: _selectedSale.saleStatus == SaleStatus.NEW.name
            ? Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 0.0, 0.0, 24.0),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: FloatingActionButton(
                        backgroundColor: Colors.black26,
                        child: const Icon(Icons.save_as_outlined),
                        onPressed: () {
                          saveSale(SaleStatus.NEW);
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        child: const Icon(Icons.payment),
                        onPressed: () {
                          saveSale(SaleStatus.SOLD);
                        },
                      ),
                    )
                  ],
                ),
              )
            : null);
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
