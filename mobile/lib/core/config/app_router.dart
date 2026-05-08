// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : app_router.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [003] 28/04/2026 - Jorge Alejandro Martinez Toris - Agregación de rutas
// ============================================================

import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/recuperar_password_screen.dart';
import '../../features/home_docente/presentation/screens/home_docente_screen.dart';
import '../../features/home_docente/presentation/screens/bienvenida_docente_screen.dart';
import '../../features/home_docente/presentation/screens/agregar_institucion_screen.dart';
import '../../features/home_docente/presentation/screens/agregar_grupo_screen.dart';
import '../../features/home_docente/presentation/screens/alumnos_grupo_screen.dart';
import '../../features/home_docente/presentation/screens/historial_sesiones_screen.dart';
import '../../features/home_docente/presentation/screens/detalle_sesion_screen.dart';
import '../../features/home_docente/presentation/screens/rubros_screen.dart';
import '../../features/home_docente/presentation/screens/reportes_screen.dart';
import '../../features/suscripcion/presentation/screens/suscripcion_screen.dart';
import '../../features/suscripcion/presentation/screens/paypal_screen.dart';
import '../../features/home_alumno/presentation/screens/home_alumno_screen.dart';
import '../../features/home_alumno/presentation/screens/unirse_materia_screen.dart';
import '../../features/notificaciones/presentation/screens/notificaciones_screen.dart';
import '../../features/perfil/presentation/screens/perfil_screen.dart';

class AppRouter
{
  AppRouter._();

  static const String login              = '/login';
  static const String register           = '/register';
  static const String recuperarPassword  = '/recuperar-password';
  static const String homeDocente        = '/home-docente';
  static const String bienvenidaDocente  = '/bienvenida-docente';
  static const String agregarInstitucion = '/agregar-institucion';
  static const String agregarGrupo       = '/agregar-grupo';
  static const String alumnosGrupo       = '/alumnos-grupo';
  static const String historialSesiones  = '/historial-sesiones';
  static const String detalleSesion      = '/detalle-sesion';
  static const String rubros             = '/rubros';
  static const String reportes           = '/reportes';
  static const String suscripcion        = '/suscripcion';
  static const String paypal             = '/paypal';
  static const String homeAlumno         = '/home-alumno';
  static const String unirseMateria      = '/unirse-materia';
  static const String notificaciones     = '/notificaciones';
  static const String perfil             = '/perfil';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(
        path:    login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path:    register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path:    recuperarPassword,
        builder: (context, state) => const RecuperarPasswordScreen(),
      ),
      GoRoute(
        path:    bienvenidaDocente,
        builder: (context, state) => const BienvenidaDocenteScreen(),
      ),
      GoRoute(
        path:    agregarInstitucion,
        builder: (context, state)
        {
          final args = state.extra as Map<String, dynamic>?;
          return AgregarInstitucionScreen(
            esOnboarding: args?['esOnboarding'] as bool? ?? false,
          );
        },
      ),
      GoRoute(
        path:    homeDocente,
        builder: (context, state) => const HomeDocenteScreen(),
      ),GoRoute(
        path:    agregarGrupo,
        builder: (context, state)
        {
          final args = state.extra as Map<String, dynamic>;
          return AgregarGrupoScreen(
            institucionId:     args['institucionId']     as int,
            nombreInstitucion: args['nombreInstitucion'] as String,
          );
        },
      ),
      GoRoute(
        path:    alumnosGrupo,
        builder: (context, state)
        {
          final args = state.extra as Map<String, dynamic>;
          return AlumnosGrupoScreen(
            grupoId:       args['grupoId']       as int,
            nombreGrupo:   args['nombreGrupo']   as String,
            nombreMateria: args['nombreMateria'] as String,
          );
        },
      ),
      GoRoute(
        path:    historialSesiones,
        builder: (context, state)
        {
          final args = state.extra as Map<String, dynamic>;
          return HistorialSesionesScreen(
            grupoId:       args['grupoId']       as int,
            nombreGrupo:   args['nombreGrupo']   as String,
            nombreMateria: args['nombreMateria'] as String,
          );
        },
      ),
      GoRoute(
        path:    detalleSesion,
        builder: (context, state)
        {
          final args = state.extra as Map<String, dynamic>;
          return DetalleSesionScreen(
            sesionId:      args['sesionId']      as int,
            nombreGrupo:   args['nombreGrupo']   as String,
            nombreMateria: args['nombreMateria'] as String,
            fecha:         args['fecha']         as String,
          );
        },
      ),
      GoRoute(
        path:    rubros,
        builder: (context, state)
        {
          final args = state.extra as Map<String, dynamic>;
          return RubrosScreen(
            institucionId:     args['institucionId']     as int,
            nombreInstitucion: args['nombreInstitucion'] as String,
          );
        },
      ),
      GoRoute(
        path:    reportes,
        builder: (context, state) => const ReportesScreen(),
      ),
      GoRoute(
        path:    suscripcion,
        builder: (context, state) => const SuscripcionScreen(),
      ),
      GoRoute(
        path:    paypal,
        builder: (context, state)
        {
          final args = state.extra as Map<String, dynamic>;
          return PaypalScreen(
            approvalUrl: args['approvalUrl'] as String,
            planNombre:  args['planNombre']  as String,
            monto:       args['monto']       as String,
          );
        },
      ),
      GoRoute(
        path:    homeAlumno,
        builder: (context, state) => const HomeAlumnoScreen(),
      ),
      GoRoute(
        path:    unirseMateria,
        builder: (context, state) => const UnirseMateriaScreem(),
      ),
      GoRoute(
        path:    notificaciones,
        builder: (context, state) => const NotificacionesScreen(),
      ),
      GoRoute(
        path:    perfil,
        builder: (context, state) => const PerfilScreen(),
      ),
    ],
  );
}