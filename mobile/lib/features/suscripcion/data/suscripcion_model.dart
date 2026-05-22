// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : suscripcion_model.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Modelo de suscripcion segun entidad del ER
//   [002] 21/05/2026 - Jorge Alejandro Martinez Toris - fromJson ajustado a respuesta real del backend
// ============================================================

class SuscripcionModel
{
  final int     id;
  final int     usuarioId;
  final int     plan;
  final int     estado;
  final String? fechaInicio;
  final String? fechaFin;
  final String? ultimoPago;

  const SuscripcionModel({
    required this.id,
    required this.usuarioId,
    required this.plan,
    required this.estado,
    this.fechaInicio,
    this.fechaFin,
    this.ultimoPago,
  });

  // plan 0 = basico, plan 1 = mensual
  // estado 0 = inactivo, estado 1 = activo, estado 2 = vencido, estado 3 = periodo de gracia
  bool get isBasico        => plan == 0;
  bool get isMensual       => plan == 1;
  bool get isActivo        => estado == 1;
  bool get isVencido       => estado == 2;
  bool get isPeriodoGracia => estado == 3;

  String get nombrePlan => isBasico ? 'Plan Basico' : 'Plan Mensual';

  factory SuscripcionModel.fromJson(Map<String, dynamic> json)
  {
    return SuscripcionModel(
      id:          json['id_suscripcion']  as int,
      usuarioId:   json['id_usuario']      as int,
      plan:        json['plan']            as int,
      estado:      json['est_suscripcion'] as int,
      fechaInicio: json['fec_inicio']      as String?,
      fechaFin:    json['fec_fin']         as String?,
      ultimoPago:  json['fec_ultimo_pago'] as String?,
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      'id_suscripcion':  id,
      'id_usuario':      usuarioId,
      'plan':            plan,
      'est_suscripcion': estado,
      'fec_inicio':      fechaInicio,
      'fec_fin':         fechaFin,
      'fec_ultimo_pago': ultimoPago,
    };
  }
}