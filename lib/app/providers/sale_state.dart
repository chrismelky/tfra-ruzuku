import 'package:flutter/foundation.dart';
import 'package:tfra_mobile/app/api/api.dart';
import 'package:tfra_mobile/app/models/sale.dart';
import 'package:tfra_mobile/app/providers/base_provider.dart';

class SaleState extends BaseProvider {
  Sale? sale;
  final String api = "/sales";
  List<Sale> sales = List.empty(growable: true);

  void loadSales() async {
    try {
      var response = await Api().dio.get(api);
      debugPrint(response.data['data'].toString());
      sales = Sale.listFromJson(response.data['data']);
    } catch (e) {
      debugPrint(e.toString());
      notifyError(e.toString());
    }
    notifyListeners();
  }

  void selectSale(Sale? sale_) {
    sale = sale_;
    notifyListeners();
  }

  Future<bool> saveSale(dynamic payload, String? otp) async {
    try {
      var resp = payload['uuid'] == null
          ? await Api().dio.post('$api?otp=$otp', data: payload)
          : await Api().dio.put("$api/${payload['uuid']}", data: payload);
      notifyInfo("Sale saved");
      return resp.statusCode == 200 || resp.statusCode == 201;
    } catch (e) {
      debugPrint(e.toString());
      notifyError(e.toString());
      return false;
    }
  }
}

final saleState = SaleState();
