// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : api_client.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Cliente HTTP centralizado con Dio
// ============================================================

import 'package:dio/dio.dart';
import '../errors/app_exceptions.dart';

class ApiClient
{
  ApiClient._();

  static const String _baseUrl = 'http://192.168.1.81:8000/api';
  static const int    _timeoutMs   = 30000;

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl:        _baseUrl,
      connectTimeout: const Duration(milliseconds: _timeoutMs),
      receiveTimeout: const Duration(milliseconds: _timeoutMs),
      headers: {
        'Accept':       'application/json',
        'Content-Type': 'application/json',
      },
    ),
  )..interceptors.addAll([
    _AuthInterceptor(),
    _LogInterceptor(),
    _ErrorInterceptor(),
  ]);

  static Dio get instance => _dio;

  static void setToken(String token)
  {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static void clearToken()
  {
    _dio.options.headers.remove('Authorization');
  }
}

class _AuthInterceptor extends Interceptor
{
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler)
  {
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler)
  {
    if (err.response?.statusCode == 401) {
      ApiClient.clearToken();
    }
    handler.next(err);
  }
}

class _LogInterceptor extends Interceptor
{
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler)
  {
    // Solo log en debug — en produccion se omite
    assert(() {
      // ignore: avoid_print
      print('[ATN] ${options.method} ${options.path}');
      return true;
    }());
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler)
  {
    assert(() {
      // ignore: avoid_print
      print('[ATN] ERROR ${err.response?.statusCode} ${err.requestOptions.path}');
      return true;
    }());
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor
{
  @override
  void onError(DioException err, ErrorInterceptorHandler handler)
  {
    final exception = _mapearError(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error:          exception,
        type:           err.type,
        response:       err.response,
      ),
    );
  }

  Exception _mapearError(DioException err)
  {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout    ||
        err.type == DioExceptionType.connectionError) {
      return const NetworkException();
    }

    final status = err.response?.statusCode;

    if (status == 401 || status == 403) {
      return const AuthException();
    }

    if (status != null && status >= 500) {
      return ServerException(statusCode: status);
    }

    if (status == 400 || status == 422) {
      final mensaje = err.response?.data?['message'] as String?
          ?? 'Datos invalidos. Verifica la informacion ingresada.';
      return ValidationException(message: mensaje);
    }

    return const ServerException();
  }
}