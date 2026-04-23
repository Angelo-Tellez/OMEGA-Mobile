// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : home_docente_bloc.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martínez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - BLoC home docente con datos mock
// ============================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_docente_event.dart';
import 'home_docente_state.dart';
import '../data/institucion_model.dart';
import '../data/grupo_model.dart';
import '../data/sesion_model.dart';

class HomeDocenteBloc extends Bloc<HomeDocenteEvent, HomeDocenteState>
{
  HomeDocenteBloc() : super(const HomeDocenteInitial())
  {
    on<HomeDocenteStarted>(_onStarted);
    on<InstitucionSeleccionada>(_onInstitucionSeleccionada);
    on<SesionAbierta>(_onSesionAbierta);
    on<SesionCerrada>(_onSesionCerrada);
  }

  static final _mockInstituciones = [
    const InstitucionModel(id: 1, docenteId: 1, nombre: 'Tecnologico de Toluca', logo: ''),
    const InstitucionModel(id: 2, docenteId: 1, nombre: 'Universidad Autonoma', logo: ''),
  ];

  static final _mockGrupos = [
    const GrupoModel(
      id: 1, institucionId: 1, docenteId: 1,
      nombre: 'Grupo A', materia: 'Matematicas Discretas',
      periodo: 'Ene-Jun 2026', noAlumnos: 28, codigoInv: 'MAT-001',
    ),
    const GrupoModel(
      id: 2, institucionId: 1, docenteId: 1,
      nombre: 'Grupo B', materia: 'Programacion Orientada a Objetos',
      periodo: 'Ene-Jun 2026', noAlumnos: 32, codigoInv: 'POO-002',
    ),
    const GrupoModel(
      id: 3, institucionId: 1, docenteId: 1,
      nombre: 'Grupo C', materia: 'Bases de Datos',
      periodo: 'Ene-Jun 2026', noAlumnos: 25, codigoInv: 'BD-003',
    ),
  ];

  Future<void> _onStarted(
      HomeDocenteStarted event,
      Emitter<HomeDocenteState> emit,
      ) async
  {
    emit(const HomeDocenteLoading());
    await Future.delayed(const Duration(milliseconds: 600));
    emit(HomeDocenteLoaded(
      instituciones:     _mockInstituciones,
      institucionActiva: _mockInstituciones.first,
      grupos:            _mockGrupos,
    ));
  }

  Future<void> _onInstitucionSeleccionada(
      InstitucionSeleccionada event,
      Emitter<HomeDocenteState> emit,
      ) async
  {
    if (state is! HomeDocenteLoaded) return;
    final current = state as HomeDocenteLoaded;

    final institucion = current.instituciones
        .firstWhere((i) => i.id == event.institucionId);

    emit(current.copyWith(
      institucionActiva: institucion,
      grupos:            _mockGrupos
          .where((g) => g.institucionId == event.institucionId)
          .toList(),
      clearSesion: true,
    ));
  }

  Future<void> _onSesionAbierta(
      SesionAbierta event,
      Emitter<HomeDocenteState> emit,
      ) async
  {
    if (state is! HomeDocenteLoaded) return;
    final current = state as HomeDocenteLoaded;

    await Future.delayed(const Duration(milliseconds: 400));

    final clave = _generarClave();
    final sesion = SesionModel(
      id:           DateTime.now().millisecondsSinceEpoch,
      grupoId:      event.grupoId,
      clave:        clave,
      estado:       1,
      fecha:        DateTime.now(),
      horaApertura: DateTime.now(),
    );

    emit(current.copyWith(sesionActiva: sesion));
  }

  Future<void> _onSesionCerrada(
      SesionCerrada event,
      Emitter<HomeDocenteState> emit,
      ) async
  {
    if (state is! HomeDocenteLoaded) return;
    final current = state as HomeDocenteLoaded;
    emit(current.copyWith(clearSesion: true));
  }

  String _generarClave()
  {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final buffer = StringBuffer();
    final now = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < 6; i++) {
      buffer.write(chars[(now + i * 7) % chars.length]);
    }
    return buffer.toString();
  }
}