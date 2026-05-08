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
//   [003] 08/05/2026 - Jorge Alejandro Martinez Toris - Rubros dinamicos por institucion
// ============================================================
import 'asistencia_model.dart';

class RubroModel
{
  final String nombre;
  final double porcentajeMinimo;

  const RubroModel({required this.nombre, required this.porcentajeMinimo});

  factory RubroModel.fromJson(Map<String, dynamic> json)
  {
    return RubroModel(
      nombre:            json['nombre']            as String,
      porcentajeMinimo:  (json['porcentaje_minimo'] as num).toDouble(),
    );
  }
}

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
  final List<RubroModel>      rubros;
  final int?                  sesionActivaId;
  final String?               sesionActivaClave;
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
    required this.rubros,
    this.sesionActivaId,
    this.sesionActivaClave,
    required this.historial,
  });

  bool get tieneSesionActiva => sesionActivaId != null;

  // Rubro con mayor porcentaje (ordinario)
  RubroModel? get rubroOrdinario =>
      rubros.isNotEmpty ? rubros.first : null;

  // Rubro con menor porcentaje (extraordinario)
  RubroModel? get rubroExtraordinario =>
      rubros.length > 1 ? rubros.last : null;

  double get porcentajeMinOrdinario =>
      rubroOrdinario?.porcentajeMinimo ?? 80;

  double get porcentajeMinExtraordinario =>
      rubroExtraordinario?.porcentajeMinimo ?? 60;

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
    final sesionActiva = json['sesion_activa'] as Map<String, dynamic>?;
    final rubrosJson   = json['rubros'] as List? ?? [];

    return MateriaAlumnoModel(
      grupoId:             json['id_grupo']       as int,
      materia:             json['materia']        as String,
      nombreGrupo:         json['nombre']         as String,
      periodo:             json['periodo']        as String?,
      totalSesiones:       json['total_sesiones'] as int,
      sesionesPresente:    json['presentes']      as int,
      sesionesFalta:       json['faltas']         as int,
      sesionesJustificada: json['justificadas']   as int,
      rubros:              rubrosJson
          .map((r) => RubroModel.fromJson(r as Map<String, dynamic>))
          .toList(),
      sesionActivaId:      sesionActiva?['id_sesion'] as int?,
      sesionActivaClave:   sesionActiva?['clave']     as String?,
      historial:           [],
    );
  }
}