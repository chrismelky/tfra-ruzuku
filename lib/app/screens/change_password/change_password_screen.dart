import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:ssmis_tz/app/listeners/message_listener.dart';
import 'package:ssmis_tz/app/providers/app_state.dart';
import 'package:ssmis_tz/app/widgets/app_base_popup_screen.dart';
import 'package:ssmis_tz/app/widgets/app_button.dart';
import 'package:ssmis_tz/app/widgets/app_form.dart';
import 'package:ssmis_tz/app/widgets/app_input_text.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _form = GlobalKey<FormBuilderState>();

  _changePassword() {
    if (_form.currentState?.saveAndValidate() == true) {
      context
          .read<AppState>()
          .changePassword(_form.currentState?.fields['password']?.value!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MessageListener<AppState>(child: Consumer<AppState>(
      builder: (context, provider, child) {
        return AppBasePopUpScreen(
          title: 'Change Password',
          child: AppForm(
            formKey: _form,
            controls: [
              AppInputText(
                fieldName: 'password',
                label: 'New Password',
                validators: [matchValidator],
              ),
              AppInputText(
                fieldName: 'confirmPassword',
                label: 'Confirm Password',
                validators: [conformValidator],
              ),
              AppButton(
                label: 'Change Password',
                onPress: () => _changePassword(),
              ),
              TextButton(
                  onPressed: () => provider.logout(),
                  child: const Text('Logout'))
            ],
          ),
        );
      },
    ));
  }

  String? matchValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    if (value.length < 4) {
      return 'Minimum length is 4 characters';
    }

    // Define a regular expression pattern to check for special characters.
    // You can modify this pattern to match the special characters you require.
    final specialCharPattern = RegExp(r'[!@#\$%^&*()_+{}\[\]:;<>,.?~\\-]');

    if (!specialCharPattern.hasMatch(value)) {
      return 'At least one special character is required';
    }

    return null; // Return null if the validation passes.
  }

  String? conformValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (_form.currentState?.fields['password']?.value != value) {
      return 'Password does not match';
    }
    return null; // Return null if the validation passes.
  }
}
