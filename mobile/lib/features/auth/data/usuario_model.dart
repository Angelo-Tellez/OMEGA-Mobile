// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : usuario_model.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martínez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Modelo de usuario segun entidad del ER
// ============================================================

class UsuarioModel
{
  final int     id;
  final String  nombre;
  final String  apPat;
  final String  apMat;
  final String  email;
  final int     rol;

  const UsuarioModel({
    required this.id,
    required this.nombre,
    required this.apPat,
    required this.apMat,
    required this.email,
    required this.rol,
  });

  // rol 1 = Docente, rol 2 = Alumno
  bool get isDocente => rol == 1;
  bool get isAlumno  => rol == 2;

  factory UsuarioModel.fromJson(Map<String, dynamic> json)
  {
    return UsuarioModel(
      id:     json['id']     as int,
      nombre: json['nombre'] as String,
      apPat:  json['ap_pat'] as String,
      apMat:  json['ap_mat'] as String,
      email:  json['email']  as String,
      rol:    json['rol']    as int,
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      'id':     id,
      'nombre': nombre,
      'ap_pat': apPat,
      'ap_mat': apMat,
      'email':  email,
      'rol':    rol,
    };
  }
}