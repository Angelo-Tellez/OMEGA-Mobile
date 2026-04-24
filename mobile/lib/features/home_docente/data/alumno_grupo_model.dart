// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : alumno_grupo_model.dart
// Created on : 24/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] Modelo de alumno dentro de un grupo
// ============================================================

class AlumnoGrupoModel
{
  final int    alumnoId;
  final String nombre;
  final String apPat;
  final String apMat;
  final String email;
  final int    totalSesiones;
  final int    sesionesAsistidas;
  final String fechaInscripcion;

  const AlumnoGrupoModel({
    required this.alumnoId,
    required this.nombre,
    required this.apPat,
    required this.apMat,
    required this.email,
    required this.totalSesiones,
    required this.sesionesAsistidas,
    required this.fechaInscripcion,
  });

  String get nombreCompleto => '$nombre $apPat $apMat';

  double get porcentajeAsistencia
  {
    if (totalSesiones == 0) return 0;
    return (sesionesAsistidas / totalSesiones) * 100;
  }

  bool get inactivo => sesionesAsistidas == 0 && totalSesiones >= 3;

  factory AlumnoGrupoModel.fromJson(Map<String, dynamic> json)
  {
    return AlumnoGrupoModel(
      alumnoId:         json['alumno_id']          as int,
      nombre:           json['nombre']             as String,
      apPat:            json['ap_pat']             as String,
      apMat:            json['ap_mat']             as String,
      email:            json['email']              as String,
      totalSesiones:    json['total_sesiones']     as int,
      sesionesAsistidas: json['sesiones_asistidas'] as int,
      fechaInscripcion: json['fecha_inscripcion']  as String,
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      'alumno_id':          alumnoId,
      'nombre':             nombre,
      'ap_pat':             apPat,
      'ap_mat':             apMat,
      'email':              email,
      'total_sesiones':     totalSesiones,
      'sesiones_asistidas': sesionesAsistidas,
      'fecha_inscripcion':  fechaInscripcion,
    };
  }
}