import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssmis_tz/app/providers/app_state.dart';
import 'package:ssmis_tz/app/screens/login/login_form.dart';
import 'package:ssmis_tz/app/listeners/message_listener.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MessageListener<AppState>(
      child: Consumer<AppState>(
        builder: (context, provider, child) {
          return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [LoginForm()],
                    ),
                    if(provider.isLoading)
                      const CircularProgressIndicator()
                  ],

                ),
              ));
        },
      ),
    );
  }
}
