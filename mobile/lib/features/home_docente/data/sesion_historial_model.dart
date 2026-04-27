// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : sesion_historial_model.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Modelo de sesion para historial del grupo
// ============================================================

class SesionHistorialModel
{
  final int    id;
  final String fecha;
  final String horaApertura;
  final String horaCierre;
  final int    totalAlumnos;
  final int    presentes;
  final int    faltas;
  final int    justificadas;

  const SesionHistorialModel({
    required this.id,
    required this.fecha,
    required this.horaApertura,
    required this.horaCierre,
    required this.totalAlumnos,
    required this.presentes,
    required this.faltas,
    required this.justificadas,
  });

  double get porcentajeAsistencia
  {
    if (totalAlumnos == 0) return 0;
    return ((presentes + justificadas) / totalAlumnos) * 100;
  }

  factory SesionHistorialModel.fromJson(Map<String, dynamic> json)
  {
    return SesionHistorialModel(
      id:           json['id']            as int,
      fecha:        json['fecha']         as String,
      horaApertura: json['hora_apertura'] as String,
      horaCierre:   json['hora_cierre']   as String,
      totalAlumnos: json['total_alumnos'] as int,
      presentes:    json['presentes']     as int,
      faltas:       json['faltas']        as int,
      justificadas: json['justificadas']  as int,
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      'id':            id,
      'fecha':         fecha,
      'hora_apertura': horaApertura,
      'hora_cierre':   horaCierre,
      'total_alumnos': totalAlumnos,
      'presentes':     presentes,
      'faltas':        faltas,
      'justificadas':  justificadas,
    };
  }
}