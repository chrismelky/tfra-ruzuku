import 'package:flutter/cupertino.dart';
import 'package:ssmis_tz/app/api/api.dart';
import 'package:ssmis_tz/app/models/stock_declaration.dart';
import 'package:ssmis_tz/app/providers/base_provider.dart';

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
    isLoading = true;
    try {
      var resp = await Api().dio.get('/premises');
      premises = (resp.data['data'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      notifyListeners();
    } catch (e) {
      notifyError(e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<Map<String, dynamic>?> save(payload) async {
    isLoading = true;
    try {
      var resp = await (payload['id'] != null
          ? Api()
              .dio
              .put('/subsidy-declarations/${payload['id']}', data: payload)
          : Api().dio.post('/subsidy-declarations', data: payload));
      debugPrint("********");
      debugPrint(resp.data['data'].toString());
      return resp.data['data'] as Map<String, dynamic>;
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      notifyError(e.toString());
    } finally {
      isLoading = false;
    }
    return null;
  }

  Future<Map<String, dynamic>?> findByUuid(String uuid) async {
    isLoading = true;
    try {
      var resp = await Api().dio.get('/subsidy-declarations/${uuid}');
      return resp.data['data'] as Map<String, dynamic>;
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      notifyError(e.toString());
    } finally {
      isLoading = false;
    }
    return null;
  }

  Future<bool> addPackage(Map<String, dynamic> payload) async {
    isLoading = true;
    try {
      var resp = await Api()
          .dio
          .post('/subsidy-declarations/add-packaging-requests', data: payload);
      return resp.statusCode == 200;
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      notifyError(e.toString());
    } finally {
      isLoading = false;
    }
    return false;
  }
}
