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
//   [002] 24/04/2026 - Dev - Se elimina atributo clave del modelo,
//                            la clave se genera en memoria y no persiste en BD
// ============================================================

class SesionModel
{
  final int      id;
  final int      grupoId;
  final int      estado;
  final DateTime fecha;
  final DateTime horaApertura;
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
      id:           json['id']            as int,
      grupoId:      json['grupo_id']      as int,
      estado:       json['estado']        as int,
      fecha:        DateTime.parse(json['fecha']         as String),
      horaApertura: DateTime.parse(json['hora_apertura'] as String),
      horaCierre:   json['hora_cierre'] != null
          ? DateTime.parse(json['hora_cierre'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      'id':            id,
      'grupo_id':      grupoId,
      'estado':        estado,
      'fecha':         fecha.toIso8601String(),
      'hora_apertura': horaApertura.toIso8601String(),
      'hora_cierre':   horaCierre?.toIso8601String(),
    };
  }
}