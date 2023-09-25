import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:ssmis_tz/app/utils/helpers.dart';

class AddPackageInputField extends StatefulWidget {
  final String name;
  final bool canEdit;

  const AddPackageInputField(
      {Key? key, required this.name, this.canEdit = true})
      : super(key: key);

  @override
  State<AddPackageInputField> createState() => _AddPackageInputFieldState();
}

class _AddPackageInputFieldState extends State<AddPackageInputField> {
  Widget packageTitle(Map<String, dynamic> package) =>
      Text("${package['productName']} | ${package['qrCodeNumber']}");

  Widget packageSubTitle(Map<String, dynamic> package) =>
      Text("${package['quantity']} kg | ${currency.format(package['price'])} TZS");

  void deletePackage(FormFieldState field, String qrCodeNumber) {
    List<Map<String, dynamic>> currentPackages = field.value;
    currentPackages
        .removeWhere((element) => element['qrCodeNumber'] == qrCodeNumber);
    field.didChange(currentPackages);
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<List<Map<String, dynamic>>>(
      name: widget.name,
      validator: FormBuilderValidators.minLength(1,
          errorText: "At least 1 package is required"),
      builder: (field) {
        double totalPrice = (field.value ?? [])
            .fold(0.0, (sum, item) => sum + (item['price'] ?? 0.0));
        return Column(children: [
          ListTile(
            onTap: () => _openQrScanner(field),
            style: ListTileStyle.drawer,
            contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            title: Text(
                "Total packages  ${field.value?.length}, Amount(TZS):${currency.format(totalPrice)}"),
            dense: true,
            subtitle: field.hasError
                ? Text(field.errorText!,
                    style: const TextStyle(color: Colors.red))
                : null,
            trailing: widget.canEdit
                ? IconButton(
                    icon: const Icon(
                      Icons.qr_code,
                      color: Colors.green,
                    ),
                    onPressed: () => _openQrScanner(field),
                  )
                : const Chip(
                    label: Text(
                      'SOLD',
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
          SingleChildScrollView(
            child: Column(
              children: [
                if (field.value?.isNotEmpty == true)
                  ...field.value!
                      .map(
                        (value) => ListTile(
                          dense: true,
                          title: field.value!.isNotEmpty
                              ? packageTitle(value)
                              : const Text("No data"),
                          subtitle: field.value!.isNotEmpty
                              ? packageSubTitle(value)
                              : null,
                          leading: const Icon(Icons.shopping_bag),
                          trailing: widget.canEdit
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Color.fromARGB(255, 255, 107, 97),
                                  ),
                                  onPressed: () {
                                    deletePackage(field, value['qrCodeNumber']);
                                  },
                                )
                              : null,
                          onTap: () {
                            debugPrint("Edit");
                          },
                        ),
                      )
                      .toList()
              ],
            ),
          )
        ]);
      },
    );
  }

  Future<void> _openQrScanner(FormFieldState field) async {
    try {
      final cameraPerm = await Permission.camera.request();
      if (cameraPerm.isGranted) {
        String? cameraScanResult = await scanner.scan();
        if (cameraScanResult != null) {
          Map<String, dynamic> fromScanner = jsonDecode(cameraScanResult);
          debugPrint("**************Sanned**********************");
          List<Map<String, dynamic>> currentPackages = field.value;
          bool exist = currentPackages
              .any((element) => element['qrCodeNumber'] == fromScanner['qr']);

          if (!exist) {
            currentPackages.add({
              'productName': fromScanner['product'],
              'agroDealerName': fromScanner['brand'],
              'qrCodeNumber': fromScanner['qr'],
              'price': fromScanner['price'],
              'quantity': fromScanner['quantity'],
            });
            field.didChange(currentPackages);
          }
        }
      } else {
        throw Exception("No permission to use camera");
      }
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
