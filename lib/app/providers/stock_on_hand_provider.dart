import 'package:flutter/cupertino.dart';
import 'package:ssmis_tz/app/api/api.dart';
import 'package:ssmis_tz/app/models/stock_on_hand.dart';
import 'package:ssmis_tz/app/providers/base_provider.dart';

class StockOnHandProvider extends BaseProvider {
  List<StockOnHand> _stockOnHand = List.empty(growable: true);

  List<StockOnHand> get stockOnHand => _stockOnHand;

  set stockOnHand(List<StockOnHand> value) {
    if (value.isNotEmpty) {
      _stockOnHand.addAll(value);
      notifyListeners();
    } else {
      _page = _page > 0 ? _page - 1 : 0;
    }
  }

  int _page = 0;

  final String api = '/stock-cards';

  init() {
    _stockOnHand = List.empty(growable: true);
    _page = 0;
    fetchStock();
  }

  fetchStock() async {
    isLoading = true;
    try {
      var resp = await Api().dio.get('$api?page=$_page');
      stockOnHand = (resp.data['data'] as List<dynamic>)
          .map((e) => StockOnHand.fromJson(e))
          .toList();
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      notifyError(e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> loadMore() async {
    _page++;
    fetchStock();
  }

}
