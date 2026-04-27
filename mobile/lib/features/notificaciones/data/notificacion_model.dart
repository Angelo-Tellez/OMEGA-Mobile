// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : notificacion_model.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Modelo de notificacion
// ============================================================

class NotificacionModel
{
  final int    id;
  final int    tipo;
  final String titulo;
  final String mensaje;
  final String fecha;
  final String hora;
  final bool   leida;

  const NotificacionModel({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.mensaje,
    required this.fecha,
    required this.hora,
    required this.leida,
  });

  // tipo 1 = inicio clase, tipo 2 = inasistencia,
  // tipo 3 = riesgo faltas, tipo 4 = limite excedido
  bool get isInicioClase    => tipo == 1;
  bool get isInasistencia   => tipo == 2;
  bool get isRiesgoFaltas   => tipo == 3;
  bool get isLimiteExcedido => tipo == 4;

  NotificacionModel copyWith({bool? leida})
  {
    return NotificacionModel(
      id:      id,
      tipo:    tipo,
      titulo:  titulo,
      mensaje: mensaje,
      fecha:   fecha,
      hora:    hora,
      leida:   leida ?? this.leida,
    );
  }

  factory NotificacionModel.fromJson(Map<String, dynamic> json)
  {
    return NotificacionModel(
      id:      json['id']      as int,
      tipo:    json['tipo']    as int,
      titulo:  json['titulo']  as String,
      mensaje: json['mensaje'] as String,
      fecha:   json['fecha']   as String,
      hora:    json['hora']    as String,
      leida:   json['leida']   as bool,
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      'id':      id,
      'tipo':    tipo,
      'titulo':  titulo,
      'mensaje': mensaje,
      'fecha':   fecha,
      'hora':    hora,
      'leida':   leida,
    };
  }
}