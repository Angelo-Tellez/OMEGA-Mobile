// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : asistencia_model.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Modelo de asistencia segun entidad del ER
// ============================================================

class AsistenciaModel
{
  final int      id;
  final int      sesionId;
  final int      alumnoId;
  final int      estado;
  final DateTime horaRegistro;

  const AsistenciaModel({
    required this.id,
    required this.sesionId,
    required this.alumnoId,
    required this.estado,
    required this.horaRegistro,
  });

  // estado 1 = presente, 2 = falta, 3 = justificada
  bool get isPresente    => estado == 1;
  bool get isFalta       => estado == 2;
  bool get isJustificada => estado == 3;

  factory AsistenciaModel.fromJson(Map<String, dynamic> json)
  {
    return AsistenciaModel(
      id:           json['id_asistencia']  as int,
      sesionId:     json['id_sesion']      as int,
      alumnoId:     json['id_alumno']      as int,
      estado:       json['est_asistencia'] as int,
      horaRegistro: json['hora_registro'] != null
          ? DateTime.parse(json['hora_registro'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      'id':            id,
      'sesion_id':     sesionId,
      'alumno_id':     alumnoId,
      'estado':        estado,
      'hora_registro': horaRegistro.toIso8601String(),
    };
  }
}