import 'package:tfra_mobile/app/api/api.dart';
import 'package:tfra_mobile/app/models/stock_declaration.dart';
import 'package:tfra_mobile/app/providers/base_provider.dart';

class StockDeclarationProvider extends BaseProvider {
  List<StockDeclaration> _declarations = List.empty(growable: true);
  List<Map<String, dynamic>> premises = List.empty(growable: true);
  int _page = 0;
  final String api = '/subsidy-declarations';

  init() {
    _declarations = List.empty(growable: true);
    _page = 0;
    fetchDeclarations();
  }

  set declarations(List<StockDeclaration> value) {
    if (value.isNotEmpty) {
      _declarations.addAll(value);
      notifyListeners();
    } else {
      _page = _page > 0 ? _page - 1 : 0;
    }
  }

  List<StockDeclaration> get declarations => _declarations;

  Future<void> loadMore() async {
    _page++;
    fetchDeclarations();
  }

  fetchDeclarations() async {
    isLoading = true;
    try {
      var resp = await Api().dio.get('$api?page=$_page');
      declarations = (resp.data['data'] as List<dynamic>)
          .map((e) => StockDeclaration.fromJson(e))
          .toList();
    } catch (e) {
      notifyError(e.toString());
    } finally {
      isLoading = false;
    }
  }

  fetchPremises() async {
    try {
      var resp = await Api().dio.get('/premises');
      premises = (resp.data['data'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      notifyListeners();
    } catch (e) {
      notifyError(e.toString());
    }
  }
}
