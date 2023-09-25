import 'package:dio/dio.dart';
import 'package:ssmis_tz/app/api/api.dart';
const String authenticationApi= "/authenticate";

Future<Response<dynamic>> login(Map<String, dynamic> payload) {
  return Api().dio.post(authenticationApi,data: payload);
}