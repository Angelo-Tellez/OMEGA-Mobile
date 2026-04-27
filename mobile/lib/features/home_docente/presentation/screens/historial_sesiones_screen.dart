// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : historial_sesiones_screen.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Pantalla de historial de sesiones del grupo
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/config/app_router.dart';
import '../../data/sesion_historial_model.dart';

class HistorialSesionesScreen extends StatelessWidget
{
  final int    grupoId;
  final String nombreGrupo;
  final String nombreMateria;

  const HistorialSesionesScreen({
    super.key,
    required this.grupoId,
    required this.nombreGrupo,
    required this.nombreMateria,
  });

  static final _mockSesiones = [
    const SesionHistorialModel(
      id: 10, fecha: '25/04/2026', horaApertura: '10:00', horaCierre: '10:45',
      totalAlumnos: 28, presentes: 25, faltas: 3, justificadas: 0,
    ),
    const SesionHistorialModel(
      id: 9, fecha: '23/04/2026', horaApertura: '10:01', horaCierre: '10:38',
      totalAlumnos: 28, presentes: 26, faltas: 2, justificadas: 0,
    ),
    const SesionHistorialModel(
      id: 8, fecha: '21/04/2026', horaApertura: '10:00', horaCierre: '10:52',
      totalAlumnos: 28, presentes: 20, faltas: 6, justificadas: 2,
    ),
    const SesionHistorialModel(
      id: 7, fecha: '18/04/2026', horaApertura: '10:02', horaCierre: '10:41',
      totalAlumnos: 28, presentes: 27, faltas: 1, justificadas: 0,
    ),
    const SesionHistorialModel(
      id: 6, fecha: '16/04/2026', horaApertura: '10:00', horaCierre: '10:35',
      totalAlumnos: 28, presentes: 24, faltas: 3, justificadas: 1,
    ),
    const SesionHistorialModel(
      id: 5, fecha: '14/04/2026', horaApertura: '10:01', horaCierre: '10:48',
      totalAlumnos: 28, presentes: 28, faltas: 0, justificadas: 0,
    ),
    const SesionHistorialModel(
      id: 4, fecha: '11/04/2026', horaApertura: '10:00', horaCierre: '10:39',
      totalAlumnos: 28, presentes: 22, faltas: 5, justificadas: 1,
    ),
    const SesionHistorialModel(
      id: 3, fecha: '09/04/2026', horaApertura: '10:03', horaCierre: '10:44',
      totalAlumnos: 28, presentes: 26, faltas: 2, justificadas: 0,
    ),
    const SesionHistorialModel(
      id: 2, fecha: '07/04/2026', horaApertura: '10:00', horaCierre: '10:37',
      totalAlumnos: 28, presentes: 25, faltas: 3, justificadas: 0,
    ),
    const SesionHistorialModel(
      id: 1, fecha: '04/04/2026', horaApertura: '10:01', horaCierre: '10:42',
      totalAlumnos: 28, presentes: 23, faltas: 5, justificadas: 0,
    ),
  ];

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:      const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nombreMateria),
            Text(
              nombreGrupo,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.neutralGrey,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildResumenGeneral(context),
            Expanded(child: _buildLista(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildResumenGeneral(BuildContext context)
  {
    final totalSesiones  = _mockSesiones.length;
    final totalPresentes = _mockSesiones.fold<int>(0, (s, e) => s + e.presentes);
    final totalFaltas    = _mockSesiones.fold<int>(0, (s, e) => s + e.faltas);
    final promedioAsis   = _mockSesiones.isEmpty
        ? 0.0
        : _mockSesiones.fold<double>(0, (s, e) => s + e.porcentajeAsistencia) / totalSesiones;

    return Container(
      margin:  const EdgeInsets.all(AppSizes.paddingM),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color:        AppColors.cloudBlue,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ResumenItemWidget(
              valor: totalSesiones.toString(),
              label: 'Sesiones',
              color: AppColors.deepNavy,
            ),
          ),
          Expanded(
            child: _ResumenItemWidget(
              valor: totalPresentes.toString(),
              label: 'Asistencias',
              color: AppColors.successGreen,
            ),
          ),
          Expanded(
            child: _ResumenItemWidget(
              valor: totalFaltas.toString(),
              label: 'Faltas',
              color: AppColors.actionRed,
            ),
          ),
          Expanded(
            child: _ResumenItemWidget(
              valor: '${promedioAsis.toStringAsFixed(0)}%',
              label: 'Promedio',
              color: AppColors.primaryCoral,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLista(BuildContext context)
  {
    return ListView.separated(
      padding:          const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
      itemCount:        _mockSesiones.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.paddingS),
      itemBuilder: (context, index)
      {
        final sesion = _mockSesiones[index];
        return _SesionCardWidget(
          sesion:        sesion,
          nombreGrupo:   nombreGrupo,
          nombreMateria: nombreMateria,
        );
      },
    );
  }
}

class _ResumenItemWidget extends StatelessWidget
{
  final String valor;
  final String label;
  final Color  color;

  const _ResumenItemWidget({
    required this.valor,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: [
        Text(
          valor,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color:      color,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color:    AppColors.neutralGrey,
            fontSize: AppSizes.fontCaption,
          ),
        ),
      ],
    );
  }
}

class _SesionCardWidget extends StatelessWidget
{
  final SesionHistorialModel sesion;
  final String               nombreGrupo;
  final String               nombreMateria;

  const _SesionCardWidget({
    required this.sesion,
    required this.nombreGrupo,
    required this.nombreMateria,
  });

  Color get _colorAsistencia
  {
    final pct = sesion.porcentajeAsistencia;
    if (pct >= 80) return AppColors.successGreen;
    if (pct >= 60) return AppColors.warningOrange;
    return AppColors.actionRed;
  }

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: () => context.push(
        AppRouter.detalleSesion,
        extra: {
          'sesionId':      sesion.id,
          'nombreGrupo':   nombreGrupo,
          'nombreMateria': nombreMateria,
          'fecha':         sesion.fecha,
        },
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color:        AppColors.baseSurface,
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          border:       Border.all(color: AppColors.surface),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: AppSizes.paddingM),
            _buildProgreso(context),
            const SizedBox(height: AppSizes.paddingS),
            _buildContadores(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context)
  {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingS),
          decoration: BoxDecoration(
            color:        AppColors.subtleWarm,
            borderRadius: BorderRadius.circular(AppSizes.radiusInput),
          ),
          child: const Icon(
            Icons.event_note_rounded,
            color: AppColors.primaryCoral,
            size:  AppSizes.iconM,
          ),
        ),
        const SizedBox(width: AppSizes.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sesion del ${sesion.fecha}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:      AppColors.deepNavy,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.schedule_outlined,
                    size:  12,
                    color: AppColors.neutralGrey,
                  ),
                  const SizedBox(width: AppSizes.paddingXS),
                  Text(
                    '${sesion.horaApertura} — ${sesion.horaCierre}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color:    AppColors.neutralGrey,
                      fontSize: AppSizes.fontCaption,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.neutralGrey,
        ),
      ],
    );
  }

  Widget _buildProgreso(BuildContext context)
  {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${sesion.presentes + sesion.justificadas}/${sesion.totalAlumnos} asistencias',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.neutralGrey,
              ),
            ),
            Text(
              '${sesion.porcentajeAsistencia.toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:      _colorAsistencia,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingXS),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value:           sesion.porcentajeAsistencia / 100,
            minHeight:       6,
            backgroundColor: AppColors.surface,
            valueColor:      AlwaysStoppedAnimation<Color>(_colorAsistencia),
          ),
        ),
      ],
    );
  }

  Widget _buildContadores(BuildContext context)
  {
    return Row(
      children: [
        _ContadorWidget(
          valor: sesion.presentes,
          label: 'Presentes',
          color: AppColors.successGreen,
        ),
        const SizedBox(width: AppSizes.paddingS),
        _ContadorWidget(
          valor: sesion.faltas,
          label: 'Faltas',
          color: AppColors.actionRed,
        ),
        const SizedBox(width: AppSizes.paddingS),
        _ContadorWidget(
          valor: sesion.justificadas,
          label: 'Justificadas',
          color: AppColors.warningOrange,
        ),
      ],
    );
  }
}

class _ContadorWidget extends StatelessWidget
{
  final int    valor;
  final String label;
  final Color  color;

  const _ContadorWidget({
    required this.valor,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context)
  {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingS,
          vertical:   AppSizes.paddingXS,
        ),
        decoration: BoxDecoration(
          color:color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusInput),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$valor',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:      color,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: AppSizes.paddingXS),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:    color,
                fontSize: AppSizes.fontCaption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
