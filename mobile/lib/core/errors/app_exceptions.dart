// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : app_exceptions.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Definicion de excepciones personalizadas por capa
// ============================================================

class NetworkException implements Exception
{
  final String message;
  const NetworkException({this.message = 'Sin conexion a Internet. Revisa tu red y vuelve a intentarlo.'});

  @override
  String toString() => message;
}

class ServerException implements Exception
{
  final String message;
  final int? statusCode;
  const ServerException({this.message = 'Algo salio mal. Ya trabajamos en ello. Intenta mas tarde.', this.statusCode});

  @override
  String toString() => message;
}

class ValidationException implements Exception
{
  final String message;
  const ValidationException({required this.message});

  @override
  String toString() => message;
}

class AuthException implements Exception
{
  final String message;
  const AuthException({this.message = 'Tu sesion ha expirado. Inicia sesion de nuevo para continuar.'});

  @override
  String toString() => message;
}