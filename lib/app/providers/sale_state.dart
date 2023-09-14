import 'package:flutter/foundation.dart';
import 'package:tfra_mobile/app/api/api.dart';
import 'package:tfra_mobile/app/models/sale.dart';

class SaleState with ChangeNotifier {
  Sale? sale;
  final String api = "/sales";
  List<Sale>? sales = List.empty(growable: true);

  void loadSales(Function onError) async {
    try {
      var response = await Api().dio.get(api);
      debugPrint(response.data['data'].toString());
      sales = Sale.listFromJson(response.data['data']);
    } catch (e) {
      debugPrint(e.toString());
      onError(e.toString());
    }
    notifyListeners();
  }

  void selectSale(Sale? sale_) {
    sale = sale_;
    notifyListeners();
  }

  Future<bool> saveSale(
      dynamic payload, Function onSuccess, Function onError) async {
    try {
      var resp = payload['uuid'] == null
          ? await Api().dio.post(api, data: payload)
          : await Api().dio.put("$api/${payload['uuid']}", data: payload);
      onSuccess("Sale saved");
      return resp.statusCode == 200 || resp.statusCode == 201;
    } catch (e) {
      debugPrint(e.toString());
      onError(e.toString());
      return false;
    }
  }
}

final saleState = SaleState();
