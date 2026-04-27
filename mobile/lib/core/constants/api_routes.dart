// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : api_routes.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Rutas de la API del backend Laravel
// ============================================================

class ApiRoutes
{
  ApiRoutes._();

  // Auth
  static const String login             = '/auth/login';
  static const String register          = '/auth/register';
  static const String logout            = '/auth/logout';
  static const String recuperarPassword = '/auth/forgot-password';
  static const String resetPassword     = '/auth/reset-password';
  static const String refreshToken      = '/auth/refresh';

  // Usuarios
  static const String perfil            = '/usuarios/perfil';
  static const String actualizarPerfil  = '/usuarios/perfil';

  // Instituciones
  static const String instituciones     = '/instituciones';
  static String institucion(int id)     => '/instituciones/$id';

  // Rubros
  static String rubros(int institucionId) => '/instituciones/$institucionId/rubros';
  static String rubro(int institucionId, int rubroId) =>
      '/instituciones/$institucionId/rubros/$rubroId';

  // Grupos
  static String grupos(int institucionId) => '/instituciones/$institucionId/grupos';
  static String grupo(int institucionId, int grupoId) =>
      '/instituciones/$institucionId/grupos/$grupoId';
  static String unirseGrupo(String codigo) => '/grupos/unirse/$codigo';
  static String alumnosGrupo(int grupoId)  => '/grupos/$grupoId/alumnos';
  static String eliminarAlumno(int grupoId, int alumnoId) =>
      '/grupos/$grupoId/alumnos/$alumnoId';

  // Sesiones
  static String sesiones(int grupoId)           => '/grupos/$grupoId/sesiones';
  static String abrirSesion(int grupoId)        => '/grupos/$grupoId/sesiones/abrir';
  static String cerrarSesion(int sesionId)      => '/sesiones/$sesionId/cerrar';
  static String detalleSesion(int sesionId)     => '/sesiones/$sesionId';
  static String validarClave(int sesionId)      => '/sesiones/$sesionId/validar-clave';
  static String editarAsistencia(int sesionId, int alumnoId) =>
      '/sesiones/$sesionId/asistencias/$alumnoId';

  // Asistencias
  static String registrarAsistencia(int sesionId) => '/sesiones/$sesionId/asistencias';
  static String historialAlumno(int alumnoId)     => '/alumnos/$alumnoId/asistencias';

  // Suscripciones y pagos
  static const String suscripcion         = '/suscripcion';
  static const String crearOrdenPaypal    = '/pagos/paypal/crear-orden';
  static const String confirmarPagoPaypal = '/pagos/paypal/confirmar';
  static const String cancelarPagoPaypal  = '/pagos/paypal/cancelar';

  // Reportes
  static String reporteGrupo(int grupoId) => '/grupos/$grupoId/reporte';

  // Notificaciones
  static const String notificaciones        = '/notificaciones';
  static String marcarLeida(int id)         => '/notificaciones/$id/leer';
  static const String marcarTodasLeidas     = '/notificaciones/leer-todas';
}