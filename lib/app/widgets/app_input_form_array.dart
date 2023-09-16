import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:tfra_mobile/app/utils/format_type.dart';
import 'package:tfra_mobile/app/widgets/app_form.dart';

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

  final _editForm = GlobalKey<FormBuilderState>();

  _onSave(Map<String, dynamic> item, int? rowIndex) {
    List<Map<String, dynamic>> items =
        List.from(formKey.currentState!.fields[name]!.value!);

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

  AppInputFormArray({
    super.key,
    required this.name,
    required this.label,
    this.validators = const [],
    required this.formKey,
    required this.formControls,
    required this.displayColumns,
    required this.uniqueKeyField,
    this.parentUniqueKeyField,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<List<Map<String, dynamic>>>(
        name: name,
        initialValue: const [],
        validator: FormBuilderValidators.compose(validators),
        builder: (field) {
          return _formArrayTable(context, field.value!);
        });
  }

  Widget _getTitle(Map<String, dynamic> u) {
    AppFormArrayDisplayColumn col = displayColumns[0];
    if (col != null) {
      var value = col.parentObjectKey != null
          ? u[col.parentObjectKey][col.valueField]
          : u[col.valueField];
      return col.displayValueBuilder != null
          ? col.displayValueBuilder!(value)
          : Text(
              value.toString(),
              style: const TextStyle(fontSize: 14),
            );
    }
    return Text("");
  }

  Widget? _getSubTitle(Map<String, dynamic> u) {
    if (displayColumns.length > 1) {
      var subCols = displayColumns.getRange(1, displayColumns.length);
      String value = subCols
          .map((col) => col.parentObjectKey != null
              ? u[col.parentObjectKey][col.valueField]
              : u[col.valueField])
          .join("|");
      return Text(value);
    }
    return null;
  }

  Widget _formArrayTable(
      BuildContext context, List<Map<String, dynamic>> items) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1, color: Theme.of(context).iconTheme.color!))),
          child: ListTile(
            title: Text("Items"),
            dense: true,
            trailing: IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                Map<String, dynamic>? item = await _createOrUpdate(context);
                if (item != null) {
                  _onSave(item, null);
                }
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ),
        ...items.asMap().entries.map((entry) {
          int idx = entry.key;
          var u = entry.value;
          return Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1, color: Theme.of(context).iconTheme.color!))),
            child: ListTile(
              dense: true,
              leading: CircleAvatar(
                radius: 12,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  "${idx + 1}",
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              title: _getTitle(u),
              subtitle: _getSubTitle(u),
              trailing: IconButton(
                onPressed: () => _onDelete(u, idx),
                icon: const Icon(Icons.remove),
              ),
              onTap: () async {
                Map<String, dynamic>? item =
                    await _createOrUpdate(context, value: u);
                if (item != null) {
                  _onSave(item, null);
                }
              },
            ),
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
