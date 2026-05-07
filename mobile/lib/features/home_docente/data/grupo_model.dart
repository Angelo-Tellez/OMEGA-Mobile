// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : grupo_model.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Modelo de grupo segun entidad del ER
//   [002] 07/05/2026 - Jorge Alejandro Martinez Toris - Ajuste campos backend real
// ============================================================
class GrupoModel
{
  final int     id;
  final int     institucionId;
  final String  nombre;
  final String  materia;
  final String? periodo;
  final int     noAlumnos;
  final String? codigoInv;

  const GrupoModel({
    required this.id,
    required this.institucionId,
    required this.nombre,
    required this.materia,
    this.periodo,
    required this.noAlumnos,
    this.codigoInv,
  });

  factory GrupoModel.fromJson(Map<String, dynamic> json)
  {
    return GrupoModel(
      id:            json['id_grupo']       as int,
      institucionId: json['id_institucion'] as int,
      nombre:        json['nombre']         as String,
      materia:       json['materia']        as String,
      periodo:       json['periodo']        as String?,
      noAlumnos:     json['no_alumnos']     as int,
      codigoInv:     json['codigo_inv']     as String?,
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      'id_grupo':       id,
      'id_institucion': institucionId,
      'nombre':         nombre,
      'materia':        materia,
      'periodo':        periodo,
      'no_alumnos':     noAlumnos,
      'codigo_inv':     codigoInv,
    };
  }
}