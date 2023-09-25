import 'package:flutter/material.dart';
import 'package:ssmis_tz/app/utils/format_type.dart';
import 'package:ssmis_tz/app/utils/helpers.dart';

class AppTableColumn {
  final String header;
  final String value;
  final double? width;
  final FormatType? format;
  final String? valueParent;

  AppTableColumn({
    required this.header,
    required this.value,
    this.width,
    this.format,
    this.valueParent,
  });
}

class AppTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  final List<AppTableColumn> columns;
  final List<IconButton>? actions;
  final bool vertical;
  final Widget Function(Map<String, dynamic> row)? actionBuilder;
  final Widget Function(Map<String, dynamic> row)? leadingBuilder;

  static const TextStyle headerStyle = TextStyle(
      fontWeight: FontWeight.normal, color: Color.fromARGB(255, 71, 85, 105));
  static const TextStyle cellStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 71, 85, 105));

  const AppTable(
      {Key? key,
      required this.data,
      required this.columns,
      this.vertical = false,
      this.actions,
      this.actionBuilder,
      this.leadingBuilder})
      : super(key: key);

  Widget _getTableHeader(AppTableColumn col) => col.width != null
      ? SizedBox(
          width: col.width,
          child: Text(
            col.header,
            style: headerStyle,
          ),
        )
      : Expanded(
          child: Text(
          col.header,
          style: headerStyle,
        ));

  Widget _getTableCell(AppTableColumn col, Map<String, dynamic> rowData) {
    return col.width != null
        ? SizedBox(
            width: col.width,
            child: _formatValue(col, rowData[col.value]),
          )
        : Expanded(child: _formatValue(col, rowData[col.value]));
  }

  Widget _formatValue(col, value) {
    String valueString;
    switch (col.format) {
      case FormatType.currency:
        valueString = currency.format(value ?? '');
        break;
      case FormatType.date:
        valueString =
            value != null ? dateFormat.format(DateTime.parse(value)) : '';
        break;
      default:
        valueString = value != null ? value.toString() : '';
    }
    return Text(
      valueString,
      textAlign: TextAlign.right,
      style: cellStyle,
    );
  }

  Widget _buildHorizontal() => Column(
        children: [
          ListTile(
            dense: true,
            tileColor: const Color.fromARGB(255, 224, 240, 255),
            title: Row(
              children: [
                ...columns.map((e) => _getTableHeader(e)).toList(),
                if (actionBuilder != null)
                  const SizedBox(
                    width: 50,
                    child: Text(""),
                  )
              ],
            ),
          ),
          const Divider(
            height: 0,
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: data.length,
              itemBuilder: ((context, index) => ListTile(
                    onTap: () => {},
                    title: Row(
                      children: [
                        ...columns.map((e) => _getTableCell(e, data[index])),
                        if (actionBuilder != null)
                          SizedBox(
                            width: 50,
                            child: actionBuilder!(data[index]),
                          )
                      ],
                    ),
                  )),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                height: 0,
              ),
            ),
          ),
        ],
      );

  Widget _buildVertical() => ListView.separated(
        itemBuilder: (context, index) {
          return Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ...columns.map((col) => Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                col.header,
                                style: headerStyle,
                              )),
                              SizedBox(
                                  width: 150,
                                  child: _formatValue(
                                      col,
                                      col.valueParent != null
                                          ? data[index][col.valueParent]
                                              [col.value]
                                          : data[index][col.value])),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          )
                        ],
                      )),
                  const Divider(
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (leadingBuilder != null)
                        SizedBox(
                          child: leadingBuilder!(data[index]),
                        ),
                      const Expanded(
                        child: Text(""),
                      ),
                      if (actionBuilder != null)
                        SizedBox(
                          child: actionBuilder!(data[index]),
                        ),
                      // IconButton(onPressed: () => {}, icon: Icon(Icons.delete))
                    ],
                  )
                ],
              ),
            ),
          );
        },
        itemCount: data.length,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          height: 6,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return _buildVertical();
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
