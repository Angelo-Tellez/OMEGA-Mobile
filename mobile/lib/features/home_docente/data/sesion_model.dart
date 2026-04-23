// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : sesion_model.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Modelo de sesion segun entidad del ER
// ============================================================

class SesionModel
{
  final int      id;
  final int      grupoId;
  final String   clave;
  final int      estado;
  final DateTime fecha;
  final DateTime horaApertura;
  final DateTime? horaCierre;

  const SesionModel({
    required this.id,
    required this.grupoId,
    required this.clave,
    required this.estado,
    required this.fecha,
    required this.horaApertura,
    this.horaCierre,
  });

  // estado 1 = activa, estado 0 = cerrada
  bool get isActiva => estado == 1;

  factory SesionModel.fromJson(Map<String, dynamic> json)
  {
    return SesionModel(
      id:           json['id']            as int,
      grupoId:      json['grupo_id']      as int,
      clave:        json['clave']         as String,
      estado:       json['estado']        as int,
      fecha:        DateTime.parse(json['fecha'] as String),
      horaApertura: DateTime.parse(json['hora_apertura'] as String),
      horaCierre:   json['hora_cierre'] != null
          ? DateTime.parse(json['hora_cierre'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      'id':           id,
      'grupo_id':     grupoId,
      'clave':        clave,
      'estado':       estado,
      'fecha':        fecha.toIso8601String(),
      'hora_apertura': horaApertura.toIso8601String(),
      'hora_cierre':  horaCierre?.toIso8601String(),
    };
  }
}