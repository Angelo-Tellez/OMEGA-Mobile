// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : sesion_model.dart
// Created on : 24/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 24/04/2026 - Dev - Modelo de sesion segun entidad del ER
//   [002] 07/05/2026 - Jorge Alejandro Martinez Toris - Ajuste campos backend real
// ============================================================
class SesionModel
{
  final int       id;
  final int       grupoId;
  final int       estado;
  final DateTime  fecha;
  final DateTime  horaApertura;
  final DateTime? horaCierre;

  const SesionModel({
    required this.id,
    required this.grupoId,
    required this.estado,
    required this.fecha,
    required this.horaApertura,
    this.horaCierre,
  });

  bool get isActiva => estado == 1;

  factory SesionModel.fromJson(Map<String, dynamic> json)
  {
    return SesionModel(
      id:           json['id_sesion']     as int,
      grupoId:      json['id_grupo']      as int,
      estado:       json['est_sesion']    as int,
      fecha:        DateTime.parse(json['fec_sesion']    as String),
      horaApertura: DateTime.parse(json['hora_apertura'] as String),
      horaCierre:   json['hora_cierre'] != null
          ? DateTime.parse(json['hora_cierre'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      'id_sesion':     id,
      'id_grupo':      grupoId,
      'est_sesion':    estado,
      'fec_sesion':    fecha.toIso8601String(),
      'hora_apertura': horaApertura.toIso8601String(),
      'hora_cierre':   horaCierre?.toIso8601String(),
    };
  }
}