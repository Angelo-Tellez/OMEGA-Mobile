// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : auth_event.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martínez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Eventos del BLoC de autenticacion
// ============================================================

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable
{
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends AuthEvent
{
  final String email;
  final String password;

  const LoginSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterSubmitted extends AuthEvent
{
  final String nombre;
  final String apPat;
  final String apMat;
  final String email;
  final String password;
  final int    rol;

  const RegisterSubmitted({
    required this.nombre,
    required this.apPat,
    required this.apMat,
    required this.email,
    required this.password,
    required this.rol,
  });

  @override
  List<Object?> get props => [nombre, apPat, apMat, email, password, rol];
}

class AuthLogoutRequested extends AuthEvent
{
  const AuthLogoutRequested();
}