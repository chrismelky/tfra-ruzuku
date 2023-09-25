import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ssmis_tz/app/app_routes.dart';
import 'package:ssmis_tz/app/screens/splash_screen.dart';
import 'package:ssmis_tz/app/providers/app_state.dart';
import 'package:ssmis_tz/app/theme/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router = appRouter.getRoutes();

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
                    theme: defaultTheme,
                  )
                : const SplashScreen());
  }
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
