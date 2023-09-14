import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/providers/app_state.dart';
import 'package:tfra_mobile/app/screens/app_notifier.dart';
import 'package:tfra_mobile/app/screens/declaration/declaration_list.dart';
import 'package:tfra_mobile/app/screens/login/login.dart';
import 'package:tfra_mobile/app/screens/sales/create_sale_screen.dart';

class AppRoutes {
  static const String dashboard = "/";
  static const String loan = "/loan";
  static const String loanGuarantors = "/loan-guarantors";

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
              const StockDeclarationScreen(),
          routes: [
            GoRoute(
              path: "create-or-update",
              builder: (context, state) => const CreateSaleScreen(),
            ),
          ]),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) => const Login(),
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
