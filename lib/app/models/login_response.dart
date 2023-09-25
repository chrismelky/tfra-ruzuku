import 'package:ssmis_tz/app/models/user.dart';

class LoginResponse {
  final bool isAuthenticated;
  final User? user;
  final String? token;

  LoginResponse({required this.isAuthenticated, this.user, this.token});
}
