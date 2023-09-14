import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfra_mobile/app/services/login_service.dart';
import 'package:tfra_mobile/app/providers/app_state.dart';
import 'package:tfra_mobile/app/utils/app_const.dart';

class Api {
  final dio = createDio();

  Api._internal();

  static final _singleton = Api._internal();

  factory Api() => _singleton;

  static Dio createDio() {
    var dio = Dio(BaseOptions(
        baseUrl: dotenv.env['API_SERVER'] ?? 'http://noapi',
        connectTimeout:
            int.parse(dotenv.env['API_CONNECTION_TIMEOUT'] ?? '10000'),
        receiveTimeout: int.parse(dotenv.env['API_RECEIVE_TIMEOUT'] ?? '15000'),
        sendTimeout: int.parse(dotenv.env['API_SEND_TIMEOUT'] ?? '10000')));
    dio.interceptors.add(AppInterceptor(dio));
    return dio;
  }
}

class AppInterceptor extends Interceptor {
  final Dio dio;

  AppInterceptor(this.dio);

  //TODO use device serial number as cliendid and secret
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String clientAuth = base64.encode(utf8.encode(
      "${dotenv.env['0AUTH_CLIENT_ID']}:${dotenv.env['0AUTH_CLIENT_SECRET']}"));

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString(AppConst.tokenKey);
    debugPrint(accessToken);

    if (accessToken != null && !options.path.contains("/authenticate")) {
      String token = accessToken;
      bool isExpired = JwtDecoder.isExpired(accessToken);
      if(isExpired) {
        String? newToken = await _refreshToken(options,  dio);
        debugPrint(newToken);
        debugPrint("-----new  token-----");
        token = newToken ?? token;
      }
      options.headers['Authorization'] = 'Bearer $token';
      options.headers['Content-Type'] = 'application/json';
    }
    debugPrint(
        "Api request: [${options.method}] [${options.baseUrl}${options.path}]");
    debugPrint("Request Headers ${options.headers.toString()}");
    if (['PUT', 'POST', 'PATCH'].contains(options.method)) {
      debugPrint("Payload:  ${options.data.toString() ?? ''}");
    }
    debugPrint("---------------------------------------------------");
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint("Api response: [${response.statusCode}]");
    debugPrint("Api body: ${response.data}");
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint("Api response code: [${err.response?.statusCode}]");
    debugPrint("response data: [${err.response?.data}]");
    switch (err.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions);
      case DioErrorType.response:
        // debugPrint(err.response?.data);

        switch (err.response?.statusCode) {
          case 400:
            throw BadRequestException(
                err.requestOptions,
                err.response?.data['message'] ??
                    err.response?.data['errors'] ??
                    err.response?.data['error_description'] ??
                    'Bad request');
          case 401:
            throw UnauthorizedException(err.requestOptions);
          case 403:
            throw PermissionDenied(err.requestOptions,  err.response?.data['message']);
          case 404:
            throw NotFoundException(err.requestOptions);
          case 409:
            throw ConflictException(err.requestOptions);
          case 500:
            throw InternalServerErrorException(err.requestOptions);
        }
        break;
      case DioErrorType.cancel:
        break;
      case DioErrorType.other:
        debugPrint(err.toString());
        throw NoInternetConnectionException(err.requestOptions);
    }

    return handler.next(err);
  }

  Future<String?> _refreshToken(RequestOptions options, Dio dio) async {
    debugPrint("-----Refreshing token ----");

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? refreshToken =  prefs.getString(AppConst.refreshTokenKey);
    if (refreshToken == null) {
      debugPrint("----Found null refresh token");
      return null;
    }
    try {
      options.headers['Authorization'] = 'Basic $clientAuth';
      options.headers['Content-Type'] = 'application/x-www-form-urlencoded';
      // var resp = await Dio(
      //   BaseOptions(baseUrl: dotenv.env['API_SERVER'] ?? 'http://noapi'),
      // ).post(authenticationApi,
      //     options: Options(headers: options.headers),
      //     data: {'grant_type': 'refresh_token', 'refresh_token': refreshToken});

      var resp = await dio.post(authenticationApi,
          options: Options(headers: options.headers),
          data: {'grant_type': 'refresh_token', 'refresh_token': refreshToken});
      if(resp.statusCode == 200) {
        String token = resp.data['access_token'];
        String refreshToken = resp.data['refresh_token'];
        await prefs.setString(AppConst.tokenKey, token);
        await prefs.setString(AppConst.refreshTokenKey, refreshToken);
       return token;
      }
    } on UnauthorizedException {
      appState.logout();
    }
    catch (e) {
      return null;
    }
    return null;
  }
}

class BadRequestException extends DioError {
  final String _message;

  BadRequestException(RequestOptions r, this._message)
      : super(requestOptions: r);

  @override
  String toString() {
    return _message;
  }
}

class InternalServerErrorException extends DioError {
  InternalServerErrorException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Unknown error occurred, please try again later.';
  }
}

class ConflictException extends DioError {
  ConflictException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Conflict occurred';
  }
}

class PermissionDenied extends DioError {
  final String _message;
  PermissionDenied(RequestOptions r, this._message) : super(requestOptions: r);

  @override
  String toString() {
    return _message;
  }
}

class UnauthorizedException extends DioError {
  UnauthorizedException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return requestOptions.path.contains(authenticationApi)
        ? 'Invalid credentials'
        : '';
  }
}

class NotFoundException extends DioError {
  NotFoundException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Resource Not found';
  }
}

class NoInternetConnectionException extends DioError {
  NoInternetConnectionException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'No internet connection detected, please try again.';
  }
}

class DeadlineExceededException extends DioError {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The connection has timed out, please try again.';
  }
}
