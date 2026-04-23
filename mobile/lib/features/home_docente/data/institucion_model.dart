// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : institucion_model.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martínez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Modelo de institucion segun entidad del ER
// ============================================================

class InstitucionModel
{
  final int    id;
  final int    docenteId;
  final String nombre;
  final String logo;

  const InstitucionModel({
    required this.id,
    required this.docenteId,
    required this.nombre,
    required this.logo,
  });

  factory InstitucionModel.fromJson(Map<String, dynamic> json)
  {
    return InstitucionModel(
      id:        json['id']         as int,
      docenteId: json['docente_id'] as int,
      nombre:    json['nombre']     as String,
      logo:      json['logo']       as String,
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      'id':         id,
      'docente_id': docenteId,
      'nombre':     nombre,
      'logo':       logo,
    };
  }
}