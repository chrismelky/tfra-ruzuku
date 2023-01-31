import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/screens/app_notifier.dart';
import 'package:tfra_mobile/app/screens/login/login.dart';
import 'package:tfra_mobile/app/screens/sales/create_sale_screen.dart';
import 'package:tfra_mobile/app/screens/sales/sale-screen.dart';
import 'package:tfra_mobile/app/screens/splash_screen.dart';
import 'package:tfra_mobile/app/state/app_state.dart';

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    Provider.of<AppState>(context, listen: false).getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AppState, bool>(
        selector: ((_, appState) => appState.sessionHasBeenFetched),
        builder: (context, sessionHasBeenFetched, child) =>
            sessionHasBeenFetched
                ? MaterialApp.router(
                    routeInformationProvider: _router.routeInformationProvider,
                    routeInformationParser: _router.routeInformationParser,
                    routerDelegate: _router.routerDelegate,
                    title: 'Fis',
                    localizationsDelegates: const [
                      FormBuilderLocalizations.delegate,
                    ],
                    theme: ThemeData(
                      primarySwatch: Colors.green,
                    ),
                  )
                : const SplashScreen());
  }

  late final GoRouter _router = GoRouter(
    refreshListenable: appState,
    routes: [
      ShellRoute(
          builder: (context, state, child) => AppNotifier(child: child),
          routes: <RouteBase>[
            GoRoute(
                path: '/',
                builder: (BuildContext context, GoRouterState state) =>
                    const SaleScreen(),
                routes: [
                  GoRoute(
                    path: "create-or-update",
                    builder: (context, state) => const CreateSaleScreen(),
                  ),
                ]),
            GoRoute(
              path: '/login',
              builder: (BuildContext context, GoRouterState state) =>
                  const Login(),
            ),
          ])
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

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Text("Home")],
    );
  }
}
