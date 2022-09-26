import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/state/app_state.dart';
import 'package:tfra_mobile/app/theme/form_controls.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _onSumbit() {
    if (_formKey.currentState!.saveAndValidate()) {
      context.read<AppState>().login(_formKey.currentState?.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              CircleAvatar(
                child: Text("FIS"),
              ),
              SizedBox(height: 18),
              Text("Login")
            ],
          ),
          FormBuilderTextField(
              name: 'email',
              decoration: appInputDecoration("Email"),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Email is required"),
                FormBuilderValidators.email(
                    errorText: "Please enter valid email")
              ])),
          const SizedBox(height: 2),
          FormBuilderTextField(
            name: 'password',
            decoration: appInputDecoration("Password"),
            obscureText: true,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: "Password is required")
            ]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () => _onSumbit(), child: const Text('Login'))
        ]));
  }
}
