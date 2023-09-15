import 'package:tfra_mobile/app/api/api.dart';
import 'package:tfra_mobile/app/models/stock_transfer.dart';
import 'package:tfra_mobile/app/providers/base_provider.dart';

class ReceiveStockProvider extends BaseProvider{
  List<StockTransfer> _stockToReceive = List.empty(growable: true);
  int _page = 0;
  final String api = '/stock-transfers';


  init() {
    _stockToReceive = [];
    _page = 0;
    fetchTransfers();
  }

  set stockToReceive(List<StockTransfer> value) {
    if (value.isNotEmpty) {
      _stockToReceive.addAll(value);
      notifyListeners();
    } else {
      _page = _page > 0 ? _page-- : 0;
    }
  }

  Future<void> loadMore() async {
    _page++;
    fetchTransfers();
  }

  List<StockTransfer> get stockToReceive => _stockToReceive;

  fetchTransfers() async {
    isLoading = true;
    try {
      var resp = await Api().dio.get('$api/on-transit?page=$_page');
      stockToReceive = (resp.data['data'] as List<dynamic>)
          .map((e) => StockTransfer.fromJson(e))
          .toList();
    } catch (e) {
      notifyError(e.toString());
    } finally {
      isLoading = false;
    }
  }

}