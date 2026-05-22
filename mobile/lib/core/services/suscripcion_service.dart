// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : suscripcion_service.dart
// Created on : 22/05/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 22/05/2026 - Jorge Alejandro Martinez Toris - Singleton cache de suscripcion
// ============================================================

import '../connection/api_client.dart';
import '../constants/api_routes.dart';
import '../../features/suscripcion/data/suscripcion_model.dart';

/// Singleton que obtiene y cachea la suscripcion del usuario.
/// Llama [invalidar] despues de un pago exitoso para forzar recarga.
class SuscripcionService
{
  SuscripcionService._();

  static SuscripcionModel? _cache;

  static Future<SuscripcionModel?> obtener() async
  {
    if (_cache != null) return _cache;
    try {
      final resp = await ApiClient.instance.get(ApiRoutes.suscripcion);
      final data = (resp.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      _cache = SuscripcionModel.fromJson(data);
      return _cache;
    } catch (_) {
      return null;
    }
  }

  /// Fuerza recarga en la proxima llamada a [obtener].
  static void invalidar() => _cache = null;

  /// Devuelve el valor cacheado sin hacer llamada HTTP.
  static SuscripcionModel? get cached => _cache;
}
