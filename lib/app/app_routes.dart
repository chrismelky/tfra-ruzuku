import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ssmis_tz/app/providers/app_state.dart';
import 'package:ssmis_tz/app/screens/app_notifier.dart';
import 'package:ssmis_tz/app/screens/dashboard/dashboard_screen.dart';
import 'package:ssmis_tz/app/screens/declaration/declaration_list.dart';
import 'package:ssmis_tz/app/screens/invoice/invoice_list.dart';
import 'package:ssmis_tz/app/screens/login/login.dart';
import 'package:ssmis_tz/app/screens/receive_stock/receive_stock_list.dart';
import 'package:ssmis_tz/app/screens/sales/sale_screen.dart';
import 'package:ssmis_tz/app/screens/stock_transfer/stock_transfer_list.dart';

class AppRoutes {
  static const String dashboard = "/";
  static const String sales = "/sales";
  static const String declaration = "/declaration";
  static const String transfer = "/transfer";
  static const String receive = "/receive";
  static const String invoice = "/invoice";
  static const String login = "/login";

  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _shellNavigatorKey = GlobalKey<NavigatorState>();

  _buildFlipTransition(GoRouterState state, Widget page) =>
      CustomTransitionPage(
        key: state.pageKey,
        child: page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeIn;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );

  List<GoRoute> getAppRoutes() {
    return [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const DashboardScreen(),
      ),
      GoRoute(
        path: login,
        builder: (BuildContext context, GoRouterState state) => const Login(),
      ),
      GoRoute(
        path: declaration,
        builder: (BuildContext context, GoRouterState state) =>
            const StockDeclarationScreen(),
      ),
      GoRoute(
        path: transfer,
        builder: (BuildContext context, GoRouterState state) =>
            const StockTransferListScreen(),
      ),
      GoRoute(
        path: receive,
        builder: (BuildContext context, GoRouterState state) =>
            const ReceiveStockListScreen(),
      ),
      GoRoute(
        path: sales,
        builder: (BuildContext context, GoRouterState state) =>
            const SaleScreen(),
      ),
      GoRoute(
        path: invoice,
        builder: (BuildContext context, GoRouterState state) =>
            const InvoiceScreen(),
      ),
    ];
  }

  Future? openDialogPage(Widget page) {
    return _rootNavigatorKey.currentState?.push(MaterialPageRoute(
        fullscreenDialog: true,
        settings: const RouteSettings(),
        builder: (context) => page));
  }

  void closeDialogPage(dynamic data) {
    _rootNavigatorKey.currentState!.pop(data);
  }

  GoRouter getRoutes() => GoRouter(
        refreshListenable: appState,
        navigatorKey: _rootNavigatorKey,
        routes: [
          ShellRoute(
              builder: (context, state, child) => AppNotifier(child: child),
              routes: <RouteBase>[...getAppRoutes()])
        ],
        redirect: (context, state) {
          final loggedIn = appState.isAuthenticated;
          final loggingIn = state.subloc == '/login';
          if (!loggedIn) return loggingIn ? null : '/login';

          if (loggingIn) return '/';

          return null;
        },
      );
}

final appRouter = AppRoutes();
