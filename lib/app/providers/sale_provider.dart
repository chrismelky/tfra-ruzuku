import 'package:flutter/foundation.dart';
import 'package:ssmis_tz/app/api/api.dart';
import 'package:ssmis_tz/app/models/sale.dart';
import 'package:ssmis_tz/app/providers/base_provider.dart';

class SaleProvider extends BaseProvider {
  Sale? sale;
  final String api = "/sales";
  List<Sale> _sales = List.empty(growable: true);

  List<Sale> get sales => _sales;

  set sales(List<Sale> value) {
    if (value.isNotEmpty) {
      _sales.addAll(value);
      notifyListeners();
    } else {
      _page = _page > 0 ? _page - 1 : 0;
    }
  }

  int _page = 0;

  init() {
    _sales = List.empty(growable: true);
    _page = 0;
    fetchSales();
  }

  void fetchSales() async {
    isLoading = true;
    try {
      var resp = await Api().dio.get('$api?page=$_page');
      sales = (resp.data['data'] as List<dynamic>)
          .map((e) => Sale.fromJson(e))
          .toList();
    } catch (e, stackTrance) {
      debugPrintStack(stackTrace: stackTrance);
      notifyError(e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> loadMore() async {
    _page++;
    fetchSales();
  }

  void selectSale(Sale? sale_) {
    sale = sale_;
    notifyListeners();
  }

  Future<bool> confirmSale(dynamic payload, String? otp) async {
    isLoading = true;
    try {
      var resp = payload['uuid'] == null
          ? await Api().dio.post('$api?otp=$otp', data: payload)
          : await Api()
              .dio
              .put("$api/${payload['uuid']}?otp=$otp", data: payload);
      notifyInfo("Sale created");
      return resp.statusCode == 200 || resp.statusCode == 201;
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      notifyError(e.toString());
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> saveAndHold(dynamic payload) async {
    isLoading = true;
    try {
      var resp = await Api().dio.post('$api/save-and-hold', data: payload);
      notifyInfo("Sale saved");
      return resp.statusCode == 200 || resp.statusCode == 201;
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      notifyError(e.toString());
      return false;
    }finally {
      isLoading = false;
    }
  }

  Future<bool?> generateOtp(dynamic payload)  async {
    isLoading = true;
    try {
      var resp = await Api().dio.post("/sales/generate-otp", data: payload);
      return [200, 201].contains(resp.statusCode);
    }catch(e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      notifyError(e.toString());
    } finally {
      isLoading = false;
    }
    return null;
  }
}

final saleProvider = SaleProvider();
