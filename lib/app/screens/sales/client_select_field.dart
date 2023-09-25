import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:ssmis_tz/app/api/api.dart';
import 'package:ssmis_tz/app/app_routes.dart';
import 'package:ssmis_tz/app/listeners/message_listener.dart';
import 'package:ssmis_tz/app/mixin/message_notifier_mixin.dart';
import 'package:ssmis_tz/app/models/client_type.dart';
import 'package:ssmis_tz/app/models/searched_client.dart';
import 'package:ssmis_tz/app/widgets/app_base_popup_screen.dart';
import 'package:ssmis_tz/app/widgets/app_button.dart';
import 'package:ssmis_tz/app/widgets/app_detail_card.dart';
import 'package:ssmis_tz/app/widgets/app_form.dart';
import 'package:ssmis_tz/app/widgets/app_input_hidden.dart';
import 'package:ssmis_tz/app/widgets/app_input_text.dart';

class ClientSelectField extends StatefulWidget {
  final String clientType;
  final String? clientName;
  final String name;
  final bool canEdit;

  const ClientSelectField({
    Key? key,
    required this.name,
    required this.clientType,
    this.clientName,
    this.canEdit = true,
  }) : super(key: key);

  @override
  State<ClientSelectField> createState() => _ClientSelectFieldState();
}

class _ClientSelectFieldState extends State<ClientSelectField> {
  TextEditingController clientNameController = TextEditingController();

  @override
  void initState() {
    clientNameController.text = widget.clientName ?? '';
    super.initState();
  }

  void _openClientDialog(FormFieldState<dynamic> field) async {
    var client = await appRouter.openDialogPage(_ClientSearchPopup(
      clientType: widget.clientType,
    )) as SearchedClient?;
    if (client != null) {
      field.didChange(client.id);

      var clientName = widget.clientType == ClientType.FARMER.name
          ? '${client.firstName ?? ''} ${client.middleName ?? ''} ${client.lastName}'
          : client.name;
      clientNameController.text= clientName?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
        name: widget.name,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(errorText: "Please Select customer"),
        ]),
        builder: (FormFieldState<dynamic> field) {
          return InkWell(
              onTap: () {
                if (widget.canEdit) {
                  _openClientDialog(field);
                }
              },
            child: TextFormField(
              controller: clientNameController,
              enabled: false,
              decoration: const InputDecoration(
                label: Text('Client'),
                suffixIcon:   Icon(Icons.person)
              ),
            ),
          );
        });
  }
}

class _ClientSearchPopup extends StatelessWidget {
  final String clientType;
  final _formKey = GlobalKey<FormBuilderState>();

  _ClientSearchPopup({super.key, required this.clientType});

  _select(BuildContext context, SearchedClient? client) {
    Navigator.of(context).pop(client);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_ClientSearchProvider>(
      create: (_) => _ClientSearchProvider(),
      child: MessageListener<_ClientSearchProvider>(
        child: Consumer<_ClientSearchProvider>(
          builder: (_, provider, child) {
            return AppBasePopUpScreen(
              title: 'Select Client',
              isLoading: provider.isLoading,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppForm(
                          formKey: _formKey,
                          controls: [
                            AppInputHidden(
                              fieldName: 'clientType',
                              value: clientType,
                            ),
                            AppInputText(
                              fieldName: 'clientId',
                              label: 'Enter $clientType ID',
                              validators: [FormBuilderValidators.required()],
                            )
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: (() => {
                                if (_formKey.currentState?.saveAndValidate() !=
                                    null)
                                  {
                                    provider
                                        .search(_formKey.currentState!.value)
                                  }
                              }),
                          icon: const Icon(Icons.search))
                    ],
                  ),
                  if (provider.client != null)
                    Builder(builder: (_) {
                      if (clientType == ClientType.FARMER.name) {
                        return AppDetailCard(
                            data: {},
                            title: 'Client Found',
                            columns: [
                              AppDetailColumn(
                                  header: 'First Name',
                                  value: provider.client?.firstName),
                              AppDetailColumn(
                                  header: 'Middle Name',
                                  value: provider.client?.middleName),
                              AppDetailColumn(
                                  header: 'Last Name',
                                  value: provider.client?.lastName),
                              AppDetailColumn(
                                  header: 'Area',
                                  value: provider.client?.adminHierarchyName),
                              AppDetailColumn(
                                  header: 'Mobile',
                                  value: provider.client?.mobile),
                              AppDetailColumn(
                                  header: 'Email',
                                  value: provider.client?.email)
                            ],
                            actionBuilder: (item) => AppButton(
                                onPress: () =>
                                    _select(context, provider.client),
                                label: 'Select'));
                      }
                      return AppDetailCard(
                          data: {},
                          title: 'Client Found',
                          columns: [
                            AppDetailColumn(
                                header: 'Name', value: provider.client?.name),
                            AppDetailColumn(
                                header: 'Area',
                                value: provider.client?.adminHierarchyName),
                            AppDetailColumn(
                                header: 'Mobile',
                                value: provider.client?.mobile),
                            AppDetailColumn(
                                header: 'Email', value: provider.client?.email)
                          ],
                          actionBuilder: (item) => AppButton(
                              onPress: () => _select(context, provider.client),
                              label: 'Select'));
                    })
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ClientSearchProvider with ChangeNotifier, MessageNotifierMixin {
  SearchedClient? client;
  bool isLoading = false;

  void search(search) async {
    isLoading = true;
    notifyListeners();
    try {
      String api = search['clientType'] == ClientType.FARMER.name
          ? "/farmers/by-identification-number/${search['clientId']}"
          : '/get-by-certificate-number/${search['clientId']}';
      var response = await Api().dio.get(api);
      client = SearchedClient.fromJson(response.data["data"]);
    } catch (e, stackTrace) {
      notifyError(e.toString());
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
