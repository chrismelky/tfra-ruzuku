import 'package:flutter/foundation.dart';
import 'package:ssmis_tz/app/api/api.dart';
import 'package:ssmis_tz/app/models/payment.dart';
import 'package:ssmis_tz/app/providers/base_provider.dart';

class PaymentProvider extends BaseProvider {
  final String api = '/invoice-payments';
  List<Payment> _payments = List.empty(growable: true);
  int _page = 0;

  List<Payment> get payments => _payments;

  set payments(List<Payment> value) {
    if (value.isNotEmpty) {
      _payments.addAll(value);
      notifyListeners();
    } else {
      _page = _page > 0 ? _page - 1 : 0;
    }
  }

  init(String invoiceUuid) {
    _payments = List.empty(growable: true);
    _page = 0;
    fetchPayments(invoiceUuid);
  }

  fetchPayments(String invoiceUuid) async {
    isLoading = true;
    try {
      var resp =
          await Api().dio.get('$api?invoiceUuid=$invoiceUuid&page=$_page');
      payments = (resp.data['data'] as List<dynamic>)
          .map((e) => Payment.fromJson(e))
          .toList();
    } catch (e, stackTrace) {
      notifyError(e.toString());
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isLoading = false;
    }
  }
}
