import 'package:flutter/widgets.dart';
import 'package:tfra_mobile/app/api/api.dart';
import 'package:tfra_mobile/app/db/db.dart';

class AppFetcher extends StatefulWidget {
  final String? api;
  final String? table;
  final Widget Function(List<Map<String, dynamic>>, bool) builder;

  const AppFetcher({Key? key,  this.api, required this.builder, this.table})
      : super(key: key);

  @override
  State<AppFetcher> createState() => _AppFetcherState();
}

class _AppFetcherState extends State<AppFetcher> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _items = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    widget.table != null ? loadFromDb() : widget.api != null ? loadFromApi() : null;
  }

  loadFromDb() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var db = await DbProvider().database;
      List<Map<String, dynamic>> result = await db.query(widget.table!, where: 'isActive=?', whereArgs: [1]);
      setState(() {
        _isLoading = false;
        _items = result;
      });
    } catch(e) {
      debugPrint(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  loadFromApi() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var resp = await Api().dio.get(widget.api!);
      List<Map<String, dynamic>> result = (resp.data['data'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      setState(() {
        _isLoading = false;
        _items = result;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_items, _isLoading);
  }
}
