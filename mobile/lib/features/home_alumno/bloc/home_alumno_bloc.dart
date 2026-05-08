// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : home_alumno_bloc.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - BLoC home alumno con datos mock
//   [002] 07/05/2026 - Jorge Alejandro Martinez Toris - Conexion real al backend
//   [003] 07/05/2026 - Jorge Alejandro Martinez Toris - Fix: materiaActiva solo si hay sesion activa
// ============================================================
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/connection/api_client.dart';
import '../../../../core/constants/api_routes.dart';
import 'home_alumno_event.dart';
import 'home_alumno_state.dart';
import '../data/materia_alumno_model.dart';

class HomeAlumnoBloc extends Bloc<HomeAlumnoEvent, HomeAlumnoState>
{
  HomeAlumnoBloc() : super(const HomeAlumnoInitial())
  {
    on<HomeAlumnoStarted>(_onStarted);
    on<RegistroAsistenciaSolicitado>(_onRegistroSolicitado);
    on<MateriaSeleccionada>(_onMateriaSeleccionada);
  }

  Future<void> _onStarted(
      HomeAlumnoStarted event,
      Emitter<HomeAlumnoState> emit,
      ) async
  {
    emit(const HomeAlumnoLoading());
    try {
      final response = await ApiClient.instance.get(ApiRoutes.alumnoGrupos);

      final materias = (response.data['data'] as List)
          .map((m) => MateriaAlumnoModel.fromJson(m as Map<String, dynamic>))
          .toList();

      // Solo marcar activa la materia que tenga sesion abierta en este momento
      final activa = materias.where((m) => m.tieneSesionActiva).firstOrNull;

      emit(HomeAlumnoLoaded(
        materias:      materias,
        materiaActiva: activa,
      ));
    } on DioException catch (e) {
      emit(HomeAlumnoError(
        mensaje: e.response?.data?['message'] as String?
            ?? 'Error al cargar los datos.',
      ));
    } catch (_) {
      emit(const HomeAlumnoError(mensaje: 'Error de conexion.'));
    }
  }

  Future<void> _onRegistroSolicitado(
      RegistroAsistenciaSolicitado event,
      Emitter<HomeAlumnoState> emit,
      ) async
  {
    if (state is! HomeAlumnoLoaded) return;
    final current = state as HomeAlumnoLoaded;
    final sesionId = current.materiaActiva?.sesionActivaId;
    if (sesionId == null) return;

    emit(current.copyWith(registrando: true));
    try {
      await ApiClient.instance.post(
        ApiRoutes.registrarAsistencia(sesionId),
        data: {'clave': event.clave},
      );

      // Recargar grupos para actualizar contadores
      final response = await ApiClient.instance.get(ApiRoutes.alumnoGrupos);
      final materias = (response.data['data'] as List)
          .map((m) => MateriaAlumnoModel.fromJson(m as Map<String, dynamic>))
          .toList();

      final activa = materias.where((m) => m.tieneSesionActiva).firstOrNull;

      emit(HomeAlumnoLoaded(materias: materias, materiaActiva: activa));
      emit(const HomeAlumnoRegistroExitoso(mensaje: '¡Asistencia registrada correctamente!'));
      await Future.delayed(const Duration(milliseconds: 300));
      emit(HomeAlumnoLoaded(materias: materias, materiaActiva: activa));

    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String? ?? 'Error al registrar asistencia.';
      emit(current.copyWith(registrando: false));
      emit(HomeAlumnoError(mensaje: msg));
      await Future.delayed(const Duration(milliseconds: 300));
      emit(current.copyWith(registrando: false));
    } catch (_) {
      emit(current.copyWith(registrando: false));
      emit(const HomeAlumnoError(mensaje: 'Error de conexion.'));
      await Future.delayed(const Duration(milliseconds: 300));
      emit(current.copyWith(registrando: false));
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