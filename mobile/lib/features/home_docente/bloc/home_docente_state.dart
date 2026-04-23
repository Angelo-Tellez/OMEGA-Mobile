// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : home_docente_state.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martínez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Estados del BLoC home docente
// ============================================================

import 'package:equatable/equatable.dart';
import '../data/institucion_model.dart';
import '../data/grupo_model.dart';
import '../data/sesion_model.dart';

abstract class HomeDocenteState extends Equatable
{
  const HomeDocenteState();

  @override
  List<Object?> get props => [];
}

class HomeDocenteInitial extends HomeDocenteState
{
  const HomeDocenteInitial();
}

class HomeDocenteLoading extends HomeDocenteState
{
  const HomeDocenteLoading();
}

class HomeDocenteLoaded extends HomeDocenteState
{
  final List<InstitucionModel> instituciones;
  final InstitucionModel?      institucionActiva;
  final List<GrupoModel>       grupos;
  final SesionModel?           sesionActiva;

  const HomeDocenteLoaded({
    required this.instituciones,
    this.institucionActiva,
    required this.grupos,
    this.sesionActiva,
  });

  HomeDocenteLoaded copyWith({
    List<InstitucionModel>? instituciones,
    InstitucionModel?       institucionActiva,
    List<GrupoModel>?       grupos,
    SesionModel?            sesionActiva,
    bool                    clearSesion = false,
  })
  {
    return HomeDocenteLoaded(
      instituciones:    instituciones    ?? this.instituciones,
      institucionActiva: institucionActiva ?? this.institucionActiva,
      grupos:           grupos           ?? this.grupos,
      sesionActiva:     clearSesion ? null : (sesionActiva ?? this.sesionActiva),
    );
  }

  @override
  List<Object?> get props => [instituciones, institucionActiva, grupos, sesionActiva];
}

class HomeDocenteError extends HomeDocenteState
{
  final String mensaje;
  const HomeDocenteError({required this.mensaje});

  @override
  List<Object?> get props => [mensaje];
}