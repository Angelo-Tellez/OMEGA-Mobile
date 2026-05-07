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
    emit(const HomeDocenteLoading());
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

      final primera = instituciones.first;
      final grupos  = await _cargarGrupos(primera.id);

      emit(HomeDocenteLoaded(
        instituciones:     instituciones,
        institucionActiva: primera,
        grupos:            grupos,
      ));
    } on DioException catch (e) {
      emit(HomeDocenteError(
        mensaje: e.response?.data?['message'] as String?
            ?? 'Error al cargar los datos.',
      ));
    } catch (_) {
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

      final claveGenerada = _generarClave();

      emit(current.copyWith(
        sesionActiva: sesion,
        claveActiva:  claveGenerada,
      ));
    } on DioException catch (e) {
      final mensaje = e.response?.data?['message'] as String?
          ?? 'No se pudo abrir la sesion.';
      emit(current.copyWith(sesionActiva: null));
      emit(HomeDocenteError(mensaje: mensaje));
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

  String _generarClave()
  {
    const chars  = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final buffer = StringBuffer();
    final now    = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < 6; i++) {
      buffer.write(chars[(now + i * 7) % chars.length]);
    }
    return buffer.toString();
  }
}