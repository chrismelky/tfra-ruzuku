import 'package:intl/intl.dart';
import 'package:ssmis_tz/app/utils/format_type.dart';

final currency = NumberFormat("#,##0.00", "en_US");
final dateFormat = DateFormat.yMMMd();
final dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

dynamic formatValue(FormatType? format, dynamic value) {
  String valueString;
  switch (format) {
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
  return valueString;
}
