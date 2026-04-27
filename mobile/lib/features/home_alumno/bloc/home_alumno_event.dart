// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : home_alumno_event.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Eventos del BLoC home alumno
// ============================================================

import 'package:equatable/equatable.dart';

abstract class HomeAlumnoEvent extends Equatable
{
  const HomeAlumnoEvent();

  @override
  List<Object?> get props => [];
}

class HomeAlumnoStarted extends HomeAlumnoEvent
{
  final int alumnoId;
  const HomeAlumnoStarted({required this.alumnoId});

  @override
  List<Object?> get props => [alumnoId];
}

class RegistroAsistenciaSolicitado extends HomeAlumnoEvent
{
  final String clave;
  final int    grupoId;

  const RegistroAsistenciaSolicitado({
    required this.clave,
    required this.grupoId,
  });

  @override
  List<Object?> get props => [clave, grupoId];
}

class MateriaSeleccionada extends HomeAlumnoEvent
{
  final int grupoId;
  const MateriaSeleccionada({required this.grupoId});

  @override
  List<Object?> get props => [grupoId];
}