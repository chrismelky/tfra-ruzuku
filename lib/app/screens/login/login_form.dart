import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:tfra_mobile/app/listeners/message_listener.dart';
import 'package:tfra_mobile/app/providers/app_state.dart';
import 'package:tfra_mobile/app/widgets/app_button.dart';
import 'package:tfra_mobile/app/widgets/app_form.dart';
import 'package:tfra_mobile/app/widgets/app_input_text.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isObscure = true;

  @override
  void initState() {
    super.initState();
  }

  void _onSubmit() {
    if (_formKey.currentState!.saveAndValidate()) {
      context.read<AppState>().login(_formKey.currentState?.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    double logoSize = MediaQuery.of(context).size.width / 4;
    return MessageListener<AppState>(
      child: SingleChildScrollView(
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          color: Colors.white,
          elevation: 4,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 36, left: 24, right: 24, bottom: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                        width: logoSize,
                        height: logoSize,
                        image: const AssetImage('assets/images/logo.png')),
                  ],
                ),
                const SizedBox(height: 16),
                AppForm(formKey: _formKey, controls: [
                  AppInputText(
                    fieldName: 'email',
                    label: 'Email',
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Email is required")
                    ],
                  ),
                  AppInputText(
                    fieldName: "password",
                    obscureText: isObscure,
                    label: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() => isObscure = !isObscure);
                      },
                      icon: Icon(isObscure
                          ? Icons.remove_red_eye_outlined
                          : Icons.remove_red_eye_sharp),
                    ),
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Password is required")
                    ],
                  ),
                  AppButton(onPress: () => _onSubmit(), label: 'Login')
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
