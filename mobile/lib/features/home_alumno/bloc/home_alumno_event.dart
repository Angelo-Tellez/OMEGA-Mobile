// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : home_alumno_event.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martínez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Eventos del BLoC home alumno
//   [002] 07/05/2026 - Jorge Alejandro Martinez Toris - Remover alumnoId (lo maneja el backend)
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
  const HomeAlumnoStarted();
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