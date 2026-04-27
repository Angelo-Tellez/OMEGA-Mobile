// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : registro_sesion_model.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Modelo de registro de asistencia en sesion
// ============================================================

class RegistroSesionModel
{
  final int    alumnoId;
  final String nombreAlumno;
  final String email;
  final int    estado;
  final String horaRegistro;

  const RegistroSesionModel({
    required this.alumnoId,
    required this.nombreAlumno,
    required this.email,
    required this.estado,
    required this.horaRegistro,
  });

  // estado 1 = presente, 2 = falta, 3 = justificada
  bool get isPresente    => estado == 1;
  bool get isFalta       => estado == 2;
  bool get isJustificada => estado == 3;

  String get etiquetaEstado
  {
    if (isPresente)    return 'Presente';
    if (isJustificada) return 'Justificada';
    return 'Falta';
  }

  RegistroSesionModel copyWith({int? estado, String? horaRegistro})
  {
    return RegistroSesionModel(
      alumnoId:     alumnoId,
      nombreAlumno: nombreAlumno,
      email:        email,
      estado:       estado       ?? this.estado,
      horaRegistro: horaRegistro ?? this.horaRegistro,
    );
  }

  factory RegistroSesionModel.fromJson(Map<String, dynamic> json)
  {
    return RegistroSesionModel(
      alumnoId:     json['alumno_id']      as int,
      nombreAlumno: json['nombre_alumno']  as String,
      email:        json['email']          as String,
      estado:       json['estado']         as int,
      horaRegistro: json['hora_registro']  as String,
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      'alumno_id':     alumnoId,
      'nombre_alumno': nombreAlumno,
      'email':         email,
      'estado':        estado,
      'hora_registro': horaRegistro,
    };
  }
}