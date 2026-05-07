// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : app_config.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 7/05/2026 - Jorge Alejandro Martinez Toris - Configuracion de baseurl
// ============================================================

class AppConfig
{
  AppConfig._();

  // Cambia esta URL cuando el backend este listo
  static const String baseUrl = 'http://192.168.1.81:8000/api';

  // PayPal sandbox — reemplazar con produccion cuando este listo
  static const String paypalClientId   = 'TU_PAYPAL_CLIENT_ID_SANDBOX';
  static const String paypalReturnUrl  = 'https://tu-dominio.com/paypal/success';
  static const String paypalCancelUrl  = 'https://tu-dominio.com/paypal/cancel';

  // Configuracion general
  static const int    sesionInactivaMin = 15;
  static const int    gracePeriodHoras  = 72;
  static const int    maxAlumnosBasico  = 15;
  static const int    maxAlumnosMensual = 50;
  static const int    historialDiasBasico = 7;
}