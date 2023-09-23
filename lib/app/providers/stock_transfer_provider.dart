import 'package:flutter/cupertino.dart';
import 'package:tfra_mobile/app/api/api.dart';
import 'package:tfra_mobile/app/models/stock_transfer.dart';
import 'package:tfra_mobile/app/providers/base_provider.dart';

class StockTransferProvider extends BaseProvider {
  List<StockTransfer> _stockTransfers = List.empty(growable: true);
  int _page = 0;
  final String api = '/stock-transfers';

  init() {
    _stockTransfers = [];
    _page = 0;
    fetchTransfers();
  }

  set stockTransfers(List<StockTransfer> value) {
    if (value.isNotEmpty) {
      _stockTransfers.addAll(value);
      notifyListeners();
    } else {
      _page = _page > 0 ? _page - 1 : 0;
    }
  }

  Future<void> loadMore() async {
    _page = _page + 1;
    fetchTransfers();
  }

  List<StockTransfer> get stockTransfers => _stockTransfers;

  fetchTransfers() async {
    isLoading = true;
    try {
      var resp = await Api().dio.get('$api?page=$_page');
      stockTransfers = (resp.data['data'] as List<dynamic>)
          .map((e) => StockTransfer.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      notifyError(e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<bool?> saveTransfer(payload) async {
    isLoading = true;
    try {
      var resp = await (payload['id'] != null
          ? Api().dio.put('/stock-transfers/${payload['uuid']}', data: payload)
          : Api().dio.post('/stock-transfers', data: payload));
      notifyInfo('Transfer created');
      return ([200, 201].contains(resp.statusCode));
    } catch (e) {
      notifyError(e.toString());
    } finally {
      isLoading = false;
    }
    return false;
  }
}
