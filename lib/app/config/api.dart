import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfra_mobile/app/app_const.dart';
import 'package:tfra_mobile/app/state/app_state.dart';

class Api {
  final dio = createDio();

  Api._internal();

  static final _singleton = Api._internal();

  factory Api() => _singleton;

  static Dio createDio() {
    var dio = Dio(BaseOptions(
        baseUrl: 'http://196.192.77.30:8080/api/v1',
        connectTimeout: 10000,
        receiveTimeout: 15000,
        sendTimeout: 15000));
    dio.interceptors.add(AppInterceptor());
    return dio;
  }
}

class AppInterceptor extends Interceptor {
  AppInterceptor();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    appState.setLoading(true);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString(AppConst.tokenKey);

    debugPrint(
        "App Http request [${options.method}] [${options.baseUrl}${options.path}]");

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    options.headers['Content-Type'] = 'application/json';
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint("App Http response code [${response.statusCode}]");

    appState.setLoading(false);

    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint("App Http response code [${err.response?.statusCode}]");

    appState.setLoading(false);
    debugPrint(err.response?.data.toString());
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
                err.requestOptions, err.response?.data['message']);
          case 401:
            appState.onUnAuthorized();
            throw UnauthorizedException(err.requestOptions);
          case 403:
            throw PermissionDenied(err.requestOptions);
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
        throw NoInternetConnectionException(err.requestOptions);
    }

    return handler.next(err);
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
  PermissionDenied(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Permission Denied';
  }
}

class UnauthorizedException extends DioError {
  UnauthorizedException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Access denied';
  }
}

class NotFoundException extends DioError {
  NotFoundException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The requested information could not be found';
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
