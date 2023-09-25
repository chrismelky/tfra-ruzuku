import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ssmis_tz/app/utils/format_type.dart';
import 'package:ssmis_tz/app/widgets/app_form.dart';

class AppFormArrayDisplayColumn {
  final String label;
  final String valueField;
  final String? parentObjectKey;
  final double? width;
  final FormatType? format;
  final Widget Function(dynamic value)? displayValueBuilder;

  AppFormArrayDisplayColumn(
      {required this.label,
      required this.valueField,
      this.parentObjectKey,
      this.format,
      this.displayValueBuilder,
      this.width});
}

class AppInputFormArray<T> extends StatelessWidget {
  final String name;
  final String label;
  final String uniqueKeyField;
  final String? parentUniqueKeyField;
  final List<String? Function(dynamic)> validators;
  final GlobalKey<FormBuilderState> formKey;
  final List<Widget> formControls;
  final List<AppFormArrayDisplayColumn> displayColumns;
  final bool canAdd;
  final bool canDelete;
  final bool canEdit;

  final _editForm = GlobalKey<FormBuilderState>();

  //Add to form array after pop up form have saved
  _onSave(Map<String, dynamic> item, int? rowIndex) {
    List<Map<String, dynamic>> items =
        List.from(formKey.currentState!.fields[name]!.value);

    final int idx = _getIndex(items, item);
    if (idx == -1) {
      if (rowIndex == null) {
        items.add(item);
      } else {
        items[rowIndex] = item;
      }
    } else {
      items[idx] = item;
    }
    formKey.currentState?.fields[name]?.didChange(items);
  }

  _onDelete(Map<String, dynamic> item, int index) {
    List<Map<String, dynamic>> items =
        List.from(formKey.currentState!.fields[name]!.value!);
    final int idx = _getIndex(items, item);
    if (idx != -1) {
      items.removeAt(idx);
    }
    formKey.currentState?.fields[name]?.didChange(items);
  }

  int _getIndex(items, item) {
    return items.indexWhere((e) {
      return parentUniqueKeyField != null
          ? e[parentUniqueKeyField][uniqueKeyField] ==
              item[parentUniqueKeyField][uniqueKeyField]
          : e[uniqueKeyField] == item[uniqueKeyField];
    });
  }

  AppInputFormArray(
      {super.key,
      required this.name,
      required this.label,
      this.validators = const [],
      required this.formKey,
      required this.formControls,
      required this.displayColumns,
      required this.uniqueKeyField,
      this.canAdd = true,
      this.canDelete = true,
      this.canEdit = true,
      this.parentUniqueKeyField});

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<List<Map<String, dynamic>>>(
        name: name,
        validator: FormBuilderValidators.compose(validators),
        builder: (field) {
          return _formArrayTable(context, field);
        });
  }

  Widget _formArrayTable(BuildContext context, FormFieldState field) {
    List<Map<String, dynamic>> items = field.value ?? [];
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           field.isValid ? Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ) : Text(field.errorText ?? '', style: const TextStyle(
               fontSize: 10, color: Colors.redAccent)),
            if (canAdd)
              IconButton(
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  Map<String, dynamic>? item = await _createOrUpdate(context);
                  if (item != null) {
                    _onSave(item, null);
                  }
                },
                icon: const Icon(Icons.add),
              )
          ],
        ),
        const Divider(),
        ...items.asMap().entries.map((entry) {
          var item = entry.value;
          var idx = entry.key;
          return Column(
            children: [
              Column(
                children: [
                  ...displayColumns.map((e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e.label),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                e.displayValueBuilder != null
                                    ? e.displayValueBuilder!(item[e.valueField])
                                    : Text(
                                        item[e.valueField].toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                //TODO    const Text('Error', style: TextStyle(fontSize: 9,color: Colors.redAccent),)
                              ],
                            )
                          ],
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (canEdit)
                        IconButton(
                            onPressed: () async {
                              Map<String, dynamic>? newItem =
                                  await _createOrUpdate(context, value: item);
                              if (newItem != null) {
                                _onSave(newItem, null);
                              }
                            },
                            icon: const Icon(Icons.edit)),
                      if (canDelete)
                        IconButton(
                            onPressed: () => _onDelete(item, idx),
                            icon: const Icon(Icons.delete))
                    ],
                  )
                ],
              ),
              const Divider()
            ],
          );
        })
      ],
    );
  }

  Future<dynamic> _createOrUpdate(BuildContext context,
      {Map<String, dynamic> value = const {}}) {
    return showDialog<dynamic>(
        context: context,
        builder: (context) {
          var width = MediaQuery.of(context).size.width - 32;
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: Text(label),
            content: SizedBox(
                width: width,
                child: SingleChildScrollView(
                  child: AppForm(
                    formKey: _editForm,
                    initialValue: value,
                    controls: [...formControls],
                  ),
                )),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_editForm.currentState!.saveAndValidate()) {
                    Navigator.pop(context, _editForm.currentState?.value);
                  }
                },
                child: const Text('ADD'),
              ),
            ],
          );
        });
  }
}
