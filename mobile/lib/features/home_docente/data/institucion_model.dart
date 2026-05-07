// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : institucion_model.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Modelo de institucion segun entidad del ER
//   [002] 07/05/2026 - Jorge Alejandro Martinez Toris - Ajuste campos backend real
// ============================================================
class InstitucionModel
{
  final int     id;
  final String  nombre;
  final String? logo;

  const InstitucionModel({
    required this.id,
    required this.nombre,
    this.logo,
  });

  factory InstitucionModel.fromJson(Map<String, dynamic> json)
  {
    return InstitucionModel(
      id:     json['id_institucion'] as int,
      nombre: json['nombre']         as String,
      logo:   json['logo']           as String?,
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      'id_institucion': id,
      'nombre':         nombre,
      'logo':           logo,
    };
  }
}