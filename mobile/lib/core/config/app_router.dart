// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : app_router.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [002] Configuracion inicial de rutas
// ============================================================

import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home_docente/presentation/screens/home_docente_screen.dart';
import '../../features/home_docente/presentation/screens/agregar_grupo_screen.dart';
import '../../features/home_docente/presentation/screens/alumnos_grupo_screen.dart';
import '../../features/home_alumno/presentation/screens/home_alumno_screen.dart';
import '../../features/home_alumno/presentation/screens/unirse_materia_screen.dart';
import '../../features/perfil/presentation/screens/perfil_screen.dart';

class AppRouter
{
  AppRouter._();

  static const String login          = '/login';
  static const String register       = '/register';
  static const String homeDocente    = '/home-docente';
  static const String agregarGrupo   = '/agregar-grupo';
  static const String alumnosGrupo   = '/alumnos-grupo';
  static const String homeAlumno     = '/home-alumno';
  static const String unirseMateria  = '/unirse-materia';
  static const String perfil         = '/perfil';

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
        path:    homeDocente,
        builder: (context, state) => const HomeDocenteScreen(),
      ),
      GoRoute(
        path:    agregarGrupo,
        builder: (context, state) => const AgregarGrupoScreen(),
      ),
      GoRoute(
        path:    alumnosGrupo,
        builder: (context, state)
        {
          final args = state.extra as Map<String, dynamic>;
          return AlumnosGrupoScreen(
            grupoId:      args['grupoId']      as int,
            nombreGrupo:  args['nombreGrupo']  as String,
            nombreMateria: args['nombreMateria'] as String,
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
        path:    perfil,
        builder: (context, state) => const PerfilScreen(),
      ),
    ],
  );
}