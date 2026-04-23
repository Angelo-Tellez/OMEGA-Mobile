// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : asistencia_model.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
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
      id:           json['id']            as int,
      sesionId:     json['sesion_id']     as int,
      alumnoId:     json['alumno_id']     as int,
      estado:       json['estado']        as int,
      horaRegistro: DateTime.parse(json['hora_registro'] as String),
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