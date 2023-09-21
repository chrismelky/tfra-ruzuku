import 'package:flutter/cupertino.dart';
import 'package:tfra_mobile/app/api/api.dart';
import 'package:tfra_mobile/app/models/invoice.dart';
import 'package:tfra_mobile/app/models/sale_summary.dart';
import 'package:tfra_mobile/app/providers/base_provider.dart';

class InvoiceProvider extends BaseProvider {
  final String api = '/invoices';
  List<Invoice> _invoices = List.empty(growable: true);
  List<SaleSummary> _sales = List.empty(growable: true);

  List<SaleSummary> get sales => _sales;

  set sales(List<SaleSummary> value) {
    _sales = value;
    notifyListeners();
  }

  int _page = 0;

  List<Invoice> get invoices => _invoices;

  set invoices(List<Invoice> value) {
    if (value.isNotEmpty) {
      _invoices.addAll(value);
      notifyListeners();
    } else {
      _page = _page > 0 ? _page - 1 : 0;
    }
  }

  init() {
    _invoices = List.empty(growable: true);
    _page = 0;
    fetchInvoices();
  }

  Future<void> loadMore() async {
    _page++;
    fetchInvoices();
  }

  fetchInvoices() async {
    isLoading = true;
    try {
      var resp = await Api().dio.get('$api?page=$_page');
      invoices = (resp.data['data'] as List<dynamic>)
          .map((e) => Invoice.fromJson(e))
          .toList();
    } catch (e, stackTrace) {
      notifyError(e.toString());
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isLoading = false;
    }
  }

  fetchPendingSales() async {
    isLoading = true;
    try {
      var resp = await Api().dio.get('/sales/not-invoiced');
      sales = (resp.data['data'] as List<dynamic>)
          .map((e) => SaleSummary.fromJson(e))
          .toList();
    } catch (e, stackTrace) {
      notifyError(e.toString());
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isLoading = false;
    }
  }

 Future<bool> generaInvoice(payload) async {
    isLoading = true;
    try {
      var resp = await Api().dio.post(api, data: payload);
      return [200,201].contains(resp.statusCode);
    } catch (e, stackTrace) {
      notifyError(e.toString());
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isLoading = false;
    }
    return false;
  }
}
