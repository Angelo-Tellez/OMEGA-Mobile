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
// ============================================================

class SuscripcionModel
{
  final int    id;
  final int    usuarioId;
  final int    plan;
  final int    estado;
  final String fechaInicio;
  final String fechaFin;
  final String ultimoPago;

  const SuscripcionModel({
    required this.id,
    required this.usuarioId,
    required this.plan,
    required this.estado,
    required this.fechaInicio,
    required this.fechaFin,
    required this.ultimoPago,
  });

  // plan 0 = basico, plan 1 = mensual
  // estado 0 = inactivo, estado 1 = activo, estado 2 = vencido, estado 3 = periodo de gracia
  bool get isBasico         => plan == 0;
  bool get isMensual        => plan == 1;
  bool get isActivo         => estado == 1;
  bool get isVencido        => estado == 2;
  bool get isPeriodoGracia  => estado == 3;

  String get nombrePlan     => isBasico ? 'Plan Basico' : 'Plan Mensual';

  factory SuscripcionModel.fromJson(Map<String, dynamic> json)
  {
    return SuscripcionModel(
      id:          json['id']          as int,
      usuarioId:   json['usuario_id']  as int,
      plan:        json['plan']        as int,
      estado:      json['estado']      as int,
      fechaInicio: json['fecha_inicio'] as String,
      fechaFin:    json['fecha_fin']   as String,
      ultimoPago:  json['ultimo_pago'] as String,
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      'id':           id,
      'usuario_id':   usuarioId,
      'plan':         plan,
      'estado':       estado,
      'fecha_inicio': fechaInicio,
      'fecha_fin':    fechaFin,
      'ultimo_pago':  ultimoPago,
    };
  }
}