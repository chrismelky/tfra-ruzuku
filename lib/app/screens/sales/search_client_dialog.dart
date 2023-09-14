import 'package:flutter/material.dart';
import 'package:tfra_mobile/app/api/api.dart';
import 'package:tfra_mobile/app/models/client_type.dart';
import 'package:tfra_mobile/app/models/searched_client.dart';
import 'package:tfra_mobile/app/shared/shared.dart';
import 'package:tfra_mobile/app/theme/form_controls.dart';

Future<SearchedClient?> searchClientDialog(
    BuildContext context, String clientType) {
  String? searchNumber;

  SearchedClient? client;
  Function showError = appError(context);

  void search() async {
    try {
      String api = clientType == ClientType.FARMER.name
          ? "/farmers/get-by-identification-number/$searchNumber"
          : '';
      var response = await Api().dio.get(api);
      client = clientType == ClientType.FARMER.name
          ? SearchedClient.formFarmer(response.data["data"])
          : SearchedClient.fromCooperative(response.data["data"]);
      debugPrint(response.toString());
    } catch (e) {
      debugPrint(e.toString());
      showError(e.toString());
    }
  }

  return showDialog<SearchedClient?>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Search $clientType",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          titlePadding: const EdgeInsets.fromLTRB(16.0, 12.0, 12.0, 0.0),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 12.0, 12.0),
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                        height: 48,
                        child: TextField(
                          decoration: appInputDecoration("Search ID"),
                          onChanged: (text) => searchNumber = text,
                        ),
                      )),
                      IconButton(
                          onPressed: (() => search()),
                          icon: const Icon(Icons.search))
                    ],
                  ),
                  ListTile(
                      title: client == null
                          ? const Text("No client selected")
                          : Text(client!.name!),
                      onTap: () {
                        if (client != null) {
                          Navigator.pop(context, client);
                        }
                      })
                ],
              ),
            ),
          ],
        );
      });
}
