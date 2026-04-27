// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : rubro_model.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Modelo de rubro de evaluacion segun entidad del ER
// ============================================================

class RubroModel
{
  final int    id;
  final int    institucionId;
  final String nombre;
  final double porcentajeMinimo;

  const RubroModel({
    required this.id,
    required this.institucionId,
    required this.nombre,
    required this.porcentajeMinimo,
  });

  RubroModel copyWith({
    String? nombre,
    double? porcentajeMinimo,
  })
  {
    return RubroModel(
      id:               id,
      institucionId:    institucionId,
      nombre:           nombre           ?? this.nombre,
      porcentajeMinimo: porcentajeMinimo ?? this.porcentajeMinimo,
    );
  }

  factory RubroModel.fromJson(Map<String, dynamic> json)
  {
    return RubroModel(
      id:               json['id']                as int,
      institucionId:    json['institucion_id']    as int,
      nombre:           json['nombre']            as String,
      porcentajeMinimo: (json['porcentaje_minimo'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      'id':                id,
      'institucion_id':    institucionId,
      'nombre':            nombre,
      'porcentaje_minimo': porcentajeMinimo,
    };
  }
}