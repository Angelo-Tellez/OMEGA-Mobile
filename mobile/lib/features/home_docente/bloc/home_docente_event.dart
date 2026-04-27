// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : home_docente_event.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martínez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Eventos del BLoC home docente
// ============================================================

import 'package:equatable/equatable.dart';

abstract class HomeDocenteEvent extends Equatable
{
  const HomeDocenteEvent();

  @override
  List<Object?> get props => [];
}

class HomeDocenteStarted extends HomeDocenteEvent
{
  final int docenteId;
  const HomeDocenteStarted({required this.docenteId});

  @override
  List<Object?> get props => [docenteId];
}

class InstitucionSeleccionada extends HomeDocenteEvent
{
  final int institucionId;
  const InstitucionSeleccionada({required this.institucionId});

  @override
  List<Object?> get props => [institucionId];
}

class SesionAbierta extends HomeDocenteEvent
{
  final int grupoId;
  const SesionAbierta({required this.grupoId});

  @override
  List<Object?> get props => [grupoId];
}

class SesionCerrada extends HomeDocenteEvent
{
  final int sesionId;
  const SesionCerrada({required this.sesionId});

  @override
  List<Object?> get props => [sesionId];
}