// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : home_alumno_bloc.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martínez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - BLoC home alumno con datos mock
// ============================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_alumno_event.dart';
import 'home_alumno_state.dart';
import '../data/materia_alumno_model.dart';
import '../data/asistencia_model.dart';

class HomeAlumnoBloc extends Bloc<HomeAlumnoEvent, HomeAlumnoState>
{
  HomeAlumnoBloc() : super(const HomeAlumnoInitial())
  {
    on<HomeAlumnoStarted>(_onStarted);
    on<RegistroAsistenciaSolicitado>(_onRegistroSolicitado);
    on<MateriaSeleccionada>(_onMateriaSeleccionada);
  }

  static final _mockMaterias = [
    MateriaAlumnoModel(
      grupoId:                    1,
      materia:                    'Matematicas Discretas',
      nombreGrupo:                'Grupo A',
      nombreDocente:              'Juan Perez Lopez',
      periodo:                    'Ene-Jun 2026',
      salon:                      'Aula 301',
      horario:                    'Lun-Mie 10:00 - 11:30',
      totalSesiones:              20,
      sesionesPresente:           15,
      sesionesFalta:              3,
      sesionesJustificada:        2,
      porcentajeMinOrdinario:     80,
      porcentajeMinExtraordinario: 60,
      historial: [
        AsistenciaModel(id: 1, sesionId: 1, alumnoId: 2, estado: 1, horaRegistro: DateTime.now().subtract(const Duration(days: 1))),
        AsistenciaModel(id: 2, sesionId: 2, alumnoId: 2, estado: 2, horaRegistro: DateTime.now().subtract(const Duration(days: 3))),
        AsistenciaModel(id: 3, sesionId: 3, alumnoId: 2, estado: 3, horaRegistro: DateTime.now().subtract(const Duration(days: 5))),
        AsistenciaModel(id: 4, sesionId: 4, alumnoId: 2, estado: 1, horaRegistro: DateTime.now().subtract(const Duration(days: 7))),
        AsistenciaModel(id: 5, sesionId: 5, alumnoId: 2, estado: 1, horaRegistro: DateTime.now().subtract(const Duration(days: 9))),
      ],
    ),
    MateriaAlumnoModel(
      grupoId:                    2,
      materia:                    'Programacion Orientada a Objetos',
      nombreGrupo:                'Grupo B',
      nombreDocente:              'Juan Perez Lopez',
      periodo:                    'Ene-Jun 2026',
      salon:                      'Lab 102',
      horario:                    'Mar-Jue 08:00 - 09:30',
      totalSesiones:              18,
      sesionesPresente:           18,
      sesionesFalta:              0,
      sesionesJustificada:        0,
      porcentajeMinOrdinario:     80,
      porcentajeMinExtraordinario: 60,
      historial: [
        AsistenciaModel(id: 6,  sesionId: 6,  alumnoId: 2, estado: 1, horaRegistro: DateTime.now().subtract(const Duration(days: 2))),
        AsistenciaModel(id: 7,  sesionId: 7,  alumnoId: 2, estado: 1, horaRegistro: DateTime.now().subtract(const Duration(days: 4))),
        AsistenciaModel(id: 8,  sesionId: 8,  alumnoId: 2, estado: 1, horaRegistro: DateTime.now().subtract(const Duration(days: 6))),
        AsistenciaModel(id: 9,  sesionId: 9,  alumnoId: 2, estado: 1, horaRegistro: DateTime.now().subtract(const Duration(days: 8))),
        AsistenciaModel(id: 10, sesionId: 10, alumnoId: 2, estado: 1, horaRegistro: DateTime.now().subtract(const Duration(days: 10))),
      ],
    ),
    MateriaAlumnoModel(
      grupoId:                    3,
      materia:                    'Bases de Datos',
      nombreGrupo:                'Grupo C',
      nombreDocente:              'Juan Perez Lopez',
      periodo:                    'Ene-Jun 2026',
      salon:                      'Aula 205',
      horario:                    'Vie 07:00 - 10:00',
      totalSesiones:              15,
      sesionesPresente:           8,
      sesionesFalta:              7,
      sesionesJustificada:        0,
      porcentajeMinOrdinario:     80,
      porcentajeMinExtraordinario: 60,
      historial: [
        AsistenciaModel(id: 11, sesionId: 11, alumnoId: 2, estado: 2, horaRegistro: DateTime.now().subtract(const Duration(days: 1))),
        AsistenciaModel(id: 12, sesionId: 12, alumnoId: 2, estado: 2, horaRegistro: DateTime.now().subtract(const Duration(days: 8))),
        AsistenciaModel(id: 13, sesionId: 13, alumnoId: 2, estado: 1, horaRegistro: DateTime.now().subtract(const Duration(days: 15))),
        AsistenciaModel(id: 14, sesionId: 14, alumnoId: 2, estado: 2, horaRegistro: DateTime.now().subtract(const Duration(days: 22))),
        AsistenciaModel(id: 15, sesionId: 15, alumnoId: 2, estado: 1, horaRegistro: DateTime.now().subtract(const Duration(days: 29))),
      ],
    ),
  ];

  Future<void> _onStarted(
      HomeAlumnoStarted event,
      Emitter<HomeAlumnoState> emit,
      ) async
  {
    emit(const HomeAlumnoLoading());
    await Future.delayed(const Duration(milliseconds: 600));
    emit(HomeAlumnoLoaded(
      materias:      _mockMaterias,
      materiaActiva: _mockMaterias.first,
    ));
  }

  Future<void> _onRegistroSolicitado(
      RegistroAsistenciaSolicitado event,
      Emitter<HomeAlumnoState> emit,
      ) async
  {
    if (state is! HomeAlumnoLoaded) return;
    final current = state as HomeAlumnoLoaded;

    emit(current.copyWith(registrando: true));
    await Future.delayed(const Duration(milliseconds: 800));

    // Clave mock valida para pruebas
    if (event.clave.toUpperCase() == 'ABC123') {
      emit(const HomeAlumnoRegistroExitoso(
        mensaje: 'Asistencia registrada correctamente',
      ));
      await Future.delayed(const Duration(milliseconds: 300));
      emit(HomeAlumnoLoaded(
        materias:      _mockMaterias,
        materiaActiva: current.materiaActiva,
      ));
    } else {
      emit(current.copyWith(registrando: false));
      emit(const HomeAlumnoError(mensaje: 'Clave incorrecta o sesion cerrada'));
      await Future.delayed(const Duration(milliseconds: 300));
      emit(HomeAlumnoLoaded(
        materias:      _mockMaterias,
        materiaActiva: current.materiaActiva,
      ));
    }
  }

  void _onMateriaSeleccionada(
      MateriaSeleccionada event,
      Emitter<HomeAlumnoState> emit,
      )
  {
    if (state is! HomeAlumnoLoaded) return;
    final current = state as HomeAlumnoLoaded;

    final materia = current.materias
        .firstWhere((m) => m.grupoId == event.grupoId);

    emit(current.copyWith(materiaActiva: materia));
  }
}