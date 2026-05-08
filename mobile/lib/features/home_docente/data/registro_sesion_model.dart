// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : registro_sesion_model.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Modelo de registro de asistencia en sesion
//   [002] 07/05/2026 - Jorge Alejandro Martinez Toris - Ajuste campos backend real
// ============================================================
class RegistroSesionModel
{
  final int     alumnoId;
  final String  nombreAlumno;
  final String? email;
  final int     estado;
  final String? horaRegistro;

  const RegistroSesionModel({
    required this.alumnoId,
    required this.nombreAlumno,
    this.email,
    required this.estado,
    this.horaRegistro,
  });

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
      alumnoId:     json['id_alumno']      as int,
      nombreAlumno: json['nombre_alumno']  as String? ?? 'Sin nombre',
      estado:       json['est_asistencia'] as int,
      horaRegistro: json['hora_registro']  as String?,
    );
  }
}