// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : main.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martínez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Inicializacion con router y BLoC de auth
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/config/app_router.dart';
import 'features/auth/bloc/auth_bloc.dart';

void main()
{
  runApp(const AtnApp());
}

class AtnApp extends StatelessWidget
{
  const AtnApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'ATN App',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}