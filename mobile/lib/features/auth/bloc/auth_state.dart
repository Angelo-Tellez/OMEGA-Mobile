// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : auth_state.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martínez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Estados del BLoC de autenticacion
// ============================================================

import 'package:equatable/equatable.dart';
import '../data/usuario_model.dart';

abstract class AuthState extends Equatable
{
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState
{
  const AuthInitial();
}

class AuthLoading extends AuthState
{
  const AuthLoading();
}

class AuthSuccess extends AuthState
{
  final UsuarioModel usuario;

  const AuthSuccess({required this.usuario});

  @override
  List<Object?> get props => [usuario];
}

class AuthFailure extends AuthState
{
  final String mensaje;

  const AuthFailure({required this.mensaje});

  @override
  List<Object?> get props => [mensaje];
}