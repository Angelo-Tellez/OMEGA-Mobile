// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : auth_bloc.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [002] 28/04/2026 - Jorge Alejandro Martinez Toris - BLoC de autenticacion con datos mock
// ============================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../data/usuario_model.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>
{
  AuthBloc() : super(const AuthInitial())
  {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  static const _mockDocente = UsuarioModel(
    id:     1,
    nombre: 'Juan',
    apPat:  'Perez',
    apMat:  'Lopez',
    email:  'docente@test.com',
    rol:    1,
  );

  static const _mockDocenteNuevo = UsuarioModel(
    id:     3,
    nombre: 'Pedro',
    apPat:  'Sanchez',
    apMat:  'Ruiz',
    email:  'docente.nuevo@test.com',
    rol:    1,
  );

  static const _mockAlumno = UsuarioModel(
    id:     2,
    nombre: 'Maria',
    apPat:  'Garcia',
    apMat:  'Torres',
    email:  'alumno@test.com',
    rol:    2,
  );

  Future<void> _onLoginSubmitted(
      LoginSubmitted event,
      Emitter<AuthState> emit,
      ) async
  {
    emit(const AuthLoading());

    await Future.delayed(const Duration(milliseconds: 800));

    if (event.email == 'docente@test.com' && event.password == '123456') {
      emit(const AuthSuccess(usuario: _mockDocente));
    } else if (event.email == 'docente.nuevo@test.com' && event.password == '123456') {
      emit(const AuthSuccess(usuario: _mockDocenteNuevo));
    } else if (event.email == 'alumno@test.com' && event.password == '123456') {
      emit(const AuthSuccess(usuario: _mockAlumno));
    } else {
      emit(const AuthFailure(mensaje: 'Correo o contrasena incorrectos'));
    }
  }

  Future<void> _onRegisterSubmitted(
      RegisterSubmitted event,
      Emitter<AuthState> emit,
      ) async
  {
    emit(const AuthLoading());

    await Future.delayed(const Duration(milliseconds: 800));

    final nuevoUsuario = UsuarioModel(
      id:     99,
      nombre: event.nombre,
      apPat:  event.apPat,
      apMat:  event.apMat,
      email:  event.email,
      rol:    event.rol,
    );

    emit(AuthSuccess(usuario: nuevoUsuario));
  }

  void _onLogoutRequested(
      AuthLogoutRequested event,
      Emitter<AuthState> emit,
      )
  {
    emit(const AuthInitial());
  }
}