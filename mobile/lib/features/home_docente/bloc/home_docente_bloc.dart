// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : home_docente_bloc.dart
// Created on : 24/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 24/04/2026 - Dev - BLoC home docente con datos mock
//   [002] 07/05/2026 - Jorge Alejandro Martinez Toris - Conexion real al backend
//   [003] 28/05/2026 - Jorge Alejandro Martinez Toris - Polling silencioso: preserva sesion e institucion activa
// ============================================================
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/connection/api_client.dart';
import '../../../../core/constants/api_routes.dart';
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

  Future<void> _onStarted(
      HomeDocenteStarted event,
      Emitter<HomeDocenteState> emit,
      ) async
  {
    // Preservar estado actual para polling silencioso
    final prev = state is HomeDocenteLoaded ? state as HomeDocenteLoaded : null;

    // Solo mostrar loading en la carga inicial
    if (prev == null) {
      emit(const HomeDocenteLoading());
    }

    try {
      final response = await ApiClient.instance.get(
        ApiRoutes.instituciones,
      );

      final instituciones = (response.data['data'] as List)
          .map((i) => InstitucionModel.fromJson(i as Map<String, dynamic>))
          .toList();

      if (instituciones.isEmpty) {
        emit(const HomeDocenteLoaded(
          instituciones: [],
          grupos:        [],
        ));
        return;
      }

      // Mantener la institucion que el docente tenia seleccionada
      final instActiva = prev?.institucionActiva != null
          ? instituciones.firstWhere(
              (i) => i.id == prev!.institucionActiva!.id,
              orElse: () => instituciones.first,
            )
          : instituciones.first;

      final grupos = await _cargarGrupos(instActiva.id);

      emit(HomeDocenteLoaded(
        instituciones:     instituciones,
        institucionActiva: instActiva,
        grupos:            grupos,
        sesionActiva:      prev?.sesionActiva, // preservar sesion activa durante polling
        claveActiva:       prev?.claveActiva,
      ));
    } on DioException catch (e) {
      if (prev != null) return; // En polling silencioso no mostrar error
      emit(HomeDocenteError(
        mensaje: e.response?.data?['message'] as String?
            ?? 'Error al cargar los datos.',
      ));
    } catch (_) {
      if (prev != null) return; // En polling silencioso no mostrar error
      emit(const HomeDocenteError(mensaje: 'Error de conexion.'));
    }
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

    try {
      final grupos = await _cargarGrupos(event.institucionId);
      emit(current.copyWith(
        institucionActiva: institucion,
        grupos:            grupos,
        clearSesion:       true,
      ));
    } catch (_) {
      emit(current.copyWith(
        institucionActiva: institucion,
        grupos:            [],
        clearSesion:       true,
      ));
    }
  }

  Future<void> _onSesionAbierta(
      SesionAbierta event,
      Emitter<HomeDocenteState> emit,
      ) async
  {
    if (state is! HomeDocenteLoaded) return;
    final current = state as HomeDocenteLoaded;

    try {
      final response = await ApiClient.instance.post(
        ApiRoutes.abrirSesion(event.grupoId),
      );

      final sesion = SesionModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      emit(current.copyWith(
        sesionActiva: sesion,
        claveActiva:  sesion.clave,
      ));
    } on DioException catch (e) {
      final mensaje = e.response?.data?['message'] as String?
          ?? 'No se pudo abrir la sesion.';
      emit(HomeDocenteError(mensaje: mensaje));
      await Future.delayed(const Duration(milliseconds: 300));
      emit(current);
    } catch (_) {
      emit(current);
    }
  }
  Future<void> _onSesionCerrada(
      SesionCerrada event,
      Emitter<HomeDocenteState> emit,
      ) async
  {
    if (state is! HomeDocenteLoaded) return;
    final current = state as HomeDocenteLoaded;

    try {
      await ApiClient.instance.post(
        ApiRoutes.cerrarSesion(event.sesionId),
      );
      emit(current.copyWith(clearSesion: true));
    } on DioException catch (_) {
      emit(current.copyWith(clearSesion: true));
    } catch (_) {
      emit(current.copyWith(clearSesion: true));
    }
  }

  Future<List<GrupoModel>> _cargarGrupos(int institucionId) async
  {
    final response = await ApiClient.instance.get(
      ApiRoutes.grupos(institucionId),
    );
    return (response.data['data'] as List)
        .map((g) => GrupoModel.fromJson(g as Map<String, dynamic>))
        .toList();
  }
}