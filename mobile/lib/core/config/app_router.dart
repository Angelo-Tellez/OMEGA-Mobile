// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : app_router.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martínez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Configuracion inicial de rutas con go_router
// ============================================================

import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home_docente/presentation/screens/home_docente_screen.dart';
import '../../features/home_alumno/presentation/screens/home_alumno_screen.dart';

class AppRouter
{
  AppRouter._();

  static const String login          = '/login';
  static const String register       = '/register';
  static const String homeDocente    = '/home-docente';
  static const String homeAlumno     = '/home-alumno';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: homeDocente,
        builder: (context, state) => const HomeDocenteScreen(),
      ),
      GoRoute(
        path: homeAlumno,
        builder: (context, state) => const HomeAlumnoScreen(),
      ),
    ],
  );
}