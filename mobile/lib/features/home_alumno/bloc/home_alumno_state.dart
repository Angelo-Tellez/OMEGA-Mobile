// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : home_alumno_state.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martínez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Estados del BLoC home alumno
// ============================================================

import 'package:equatable/equatable.dart';
import '../data/materia_alumno_model.dart';

abstract class HomeAlumnoState extends Equatable
{
  const HomeAlumnoState();

  @override
  List<Object?> get props => [];
}

class HomeAlumnoInitial extends HomeAlumnoState
{
  const HomeAlumnoInitial();
}

class HomeAlumnoLoading extends HomeAlumnoState
{
  const HomeAlumnoLoading();
}

class HomeAlumnoLoaded extends HomeAlumnoState
{
  final List<MateriaAlumnoModel> materias;
  final MateriaAlumnoModel?      materiaActiva;
  final bool                     registrando;

  const HomeAlumnoLoaded({
    required this.materias,
    this.materiaActiva,
    this.registrando = false,
  });

  HomeAlumnoLoaded copyWith({
    List<MateriaAlumnoModel>? materias,
    MateriaAlumnoModel?       materiaActiva,
    bool?                     registrando,
  })
  {
    return HomeAlumnoLoaded(
      materias:      materias      ?? this.materias,
      materiaActiva: materiaActiva ?? this.materiaActiva,
      registrando:   registrando   ?? this.registrando,
    );
  }

  @override
  List<Object?> get props => [materias, materiaActiva, registrando];
}

class HomeAlumnoRegistroExitoso extends HomeAlumnoState
{
  final String mensaje;
  const HomeAlumnoRegistroExitoso({required this.mensaje});

  @override
  List<Object?> get props => [mensaje];
}

class HomeAlumnoError extends HomeAlumnoState
{
  final String mensaje;
  const HomeAlumnoError({required this.mensaje});

  @override
  List<Object?> get props => [mensaje];
}