  // ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : secure_storage.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Almacenamiento seguro de tokens
// ============================================================

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage
{
  SecureStorage._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keyAccessToken  = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUsuarioId    = 'usuario_id';
  static const _keyUsuarioRol   = 'usuario_rol';

  static Future<void> guardarTokens({
    required String accessToken,
    required String refreshToken,
  }) async
  {
    await _storage.write(key: _keyAccessToken,  value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
  }

  static Future<void> guardarUsuario({
    required int id,
    required int rol,
  }) async
  {
    await _storage.write(key: _keyUsuarioId,  value: id.toString());
    await _storage.write(key: _keyUsuarioRol, value: rol.toString());
  }

  static Future<String?> obtenerAccessToken()  async =>
      _storage.read(key: _keyAccessToken);

  static Future<String?> obtenerRefreshToken() async =>
      _storage.read(key: _keyRefreshToken);

  static Future<int?> obtenerUsuarioId() async
  {
    final valor = await _storage.read(key: _keyUsuarioId);
    return valor != null ? int.tryParse(valor) : null;
  }

  static Future<int?> obtenerUsuarioRol() async
  {
    final valor = await _storage.read(key: _keyUsuarioRol);
    return valor != null ? int.tryParse(valor) : null;
  }

  static Future<bool> hayTokenGuardado() async
  {
    final token = await _storage.read(key: _keyAccessToken);
    return token != null && token.isNotEmpty;
  }

  static Future<void> limpiarTodo() async
  {
    await _storage.deleteAll();
  }
}