// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : materia_alumno_model.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Modelo de materia con progreso de asistencia para alumno
//   [002] 07/05/2026 - Jorge Alejandro Martinez Toris - Ajuste campos backend real
// ============================================================
import 'asistencia_model.dart';

class MateriaAlumnoModel
{
  final int                   grupoId;
  final String                materia;
  final String                nombreGrupo;
  final String?               nombreDocente;
  final String?               periodo;
  final String?               salon;
  final String?               horario;
  final int                   totalSesiones;
  final int                   sesionesPresente;
  final int                   sesionesFalta;
  final int                   sesionesJustificada;
  final double                porcentajeMinOrdinario;
  final double                porcentajeMinExtraordinario;
  final List<AsistenciaModel> historial;

  const MateriaAlumnoModel({
    required this.grupoId,
    required this.materia,
    required this.nombreGrupo,
    this.nombreDocente,
    this.periodo,
    this.salon,
    this.horario,
    required this.totalSesiones,
    required this.sesionesPresente,
    required this.sesionesFalta,
    required this.sesionesJustificada,
    required this.porcentajeMinOrdinario,
    required this.porcentajeMinExtraordinario,
    required this.historial,
  });

  double get porcentajeAsistencia
  {
    if (totalSesiones == 0) return 0;
    return ((sesionesPresente + sesionesJustificada) / totalSesiones) * 100;
  }

  bool get cumpleOrdinario      => porcentajeAsistencia >= porcentajeMinOrdinario;
  bool get cumpleExtraordinario => porcentajeAsistencia >= porcentajeMinExtraordinario;

  int get faltasPermitidas
  {
    final sesionesNecesarias = (porcentajeMinOrdinario / 100 * totalSesiones).ceil();
    final faltasMax          = totalSesiones - sesionesNecesarias;
    return (faltasMax - sesionesFalta).clamp(0, faltasMax);
  }

  bool get enRiesgo       => faltasPermitidas <= 2 && faltasPermitidas > 0;
  bool get limiteExcedido => !cumpleOrdinario && totalSesiones > 0;

  factory MateriaAlumnoModel.fromJson(Map<String, dynamic> json)
  {
    return MateriaAlumnoModel(
      grupoId:                     json['id_grupo']          as int,
      materia:                     json['materia']           as String,
      nombreGrupo:                 json['nombre']            as String,
      periodo:                     json['periodo']           as String?,
      totalSesiones:               json['total_sesiones']    as int,
      sesionesPresente:            json['presentes']         as int,
      sesionesFalta:               json['faltas']            as int,
      sesionesJustificada:         json['justificadas']      as int,
      porcentajeMinOrdinario:      80,
      porcentajeMinExtraordinario: 60,
      historial:                   [],
    );
  }
}