// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : auth_bloc.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Jorge Alejandro Martinez Toris - BLoC de autenticacion con datos mock
//   [002] 07/05/2026 - Jorge Alejandro Martinez Toris - Conexion real al backend Laravel
//   [003] 21/05/2026 - Jorge Alejandro Martinez Toris - Handler actualizar perfil
// ============================================================
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/connection/api_client.dart';
import '../../../../core/connection/secure_storage.dart';
import '../../../../core/constants/api_routes.dart';
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
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<PerfilActualizado>(_onPerfilActualizado);
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event,
      Emitter<AuthState> emit,
      ) async
  {
    final token = await SecureStorage.obtenerAccessToken();
    if (token == null) {
      emit(const AuthInitial());
      return;
    }
    try {
      ApiClient.setToken(token);
      final response = await ApiClient.instance.get(ApiRoutes.perfil);
      final usuario = UsuarioModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
      emit(AuthSuccess(usuario: usuario));
    } catch (_) {
      await SecureStorage.limpiarTodo();
      ApiClient.clearToken();
      emit(const AuthInitial());
    }
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event,
      Emitter<AuthState> emit,
      ) async
  {
    emit(const AuthLoading());
    try {
      final response = await ApiClient.instance.post(
        ApiRoutes.login,
        data: {
          'email':    event.email,
          'password': event.password,
        },
      );

      final data    = response.data['data'] as Map<String, dynamic>;
      final token   = data['token']   as String;
      final usuario = UsuarioModel.fromJson(
        data['usuario'] as Map<String, dynamic>,
      );

      ApiClient.setToken(token);
      await SecureStorage.guardarTokens(
        accessToken:  token,
        refreshToken: token,
      );
      await SecureStorage.guardarUsuario(
        id:  usuario.id,
        rol: usuario.rol,
      );

      emit(AuthSuccess(usuario: usuario));
    } on DioException catch (e) {
      final mensaje = e.response?.data?['message'] as String?
          ?? 'Correo o contrasena incorrectos.';
      emit(AuthFailure(mensaje: mensaje));
    } catch (e) {
      emit(const AuthFailure(mensaje: 'Error de conexion. Verifica tu red.'));
    }
  }

  Future<void> _onRegisterSubmitted(
      RegisterSubmitted event,
      Emitter<AuthState> emit,
      ) async
  {
    emit(const AuthLoading());
    try {
      final response = await ApiClient.instance.post(
        ApiRoutes.register,
        data: {
          'nombre':   event.nombre,
          'ap_pat':   event.apPat,
          'ap_mat':   event.apMat,
          'email':    event.email,
          'password': event.password,
          'rol':      event.rol,
        },
      );

      final data    = response.data['data'] as Map<String, dynamic>;
      final token   = data['token']   as String;
      final usuario = UsuarioModel.fromJson(
        data['usuario'] as Map<String, dynamic>,
      );


      ApiClient.setToken(token);
      await SecureStorage.guardarTokens(
        accessToken:  token,
        refreshToken: token,
      );
      await SecureStorage.guardarUsuario(
        id:  usuario.id,
        rol: usuario.rol,
      );

      emit(AuthSuccess(usuario: usuario));
    } on DioException catch (e) {
      final mensaje = e.response?.data?['message'] as String?
          ?? 'Error al registrar. Verifica los datos.';
      emit(AuthFailure(mensaje: mensaje));
    } catch (_) {
      emit(const AuthFailure(mensaje: 'Error de conexion. Verifica tu red.'));
    }
  }

  Future<void> _onLogoutRequested(
      AuthLogoutRequested event,
      Emitter<AuthState> emit,
      ) async
  {
    try {
      await ApiClient.instance.post(ApiRoutes.logout);
    } catch (_) {}
    await SecureStorage.limpiarTodo();
    ApiClient.clearToken();
    emit(const AuthInitial());
  }

  Future<void> _onPerfilActualizado(
      PerfilActualizado event,
      Emitter<AuthState> emit,
      ) async
  {
    final estadoActual = state;
    if (estadoActual is! AuthSuccess) return;

    emit(const AuthLoading());
    try {
      final body = <String, dynamic>{
        'nombre': event.nombre,
        'ap_pat': event.apPat,
        'ap_mat': event.apMat,
        'email':  event.email,
      };
      if (event.password != null && event.password!.isNotEmpty) {
        body['password'] = event.password;
      }

      final response = await ApiClient.instance.patch(
        ApiRoutes.actualizarPerfil,
        data: body,
      );

      final usuario = UsuarioModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      emit(AuthSuccess(usuario: usuario));
    } on DioException catch (e) {
      final mensaje = e.response?.data?['message'] as String?
          ?? 'No se pudo actualizar el perfil.';
      emit(AuthFailure(mensaje: mensaje));
    } catch (_) {
      emit(const AuthFailure(mensaje: 'Error de conexion. Verifica tu red.'));
    }
  }
}