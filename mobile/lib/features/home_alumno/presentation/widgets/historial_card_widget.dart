// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : historial_card_widget.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Jorge Alejandro Martinez Toris - Tarjeta de historial de asistencias por materia
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../data/materia_alumno_model.dart';
import '../../data/asistencia_model.dart';

class HistorialCardWidget extends StatelessWidget
{
  final MateriaAlumnoModel materia;

  const HistorialCardWidget({super.key, required this.materia});

  @override
  Widget build(BuildContext context)
  {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color:        AppColors.baseSurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.surface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: AppSizes.paddingM),
          _buildResumen(context),
          const SizedBox(height: AppSizes.paddingM),
          const Divider(color: AppColors.surface),
          const SizedBox(height: AppSizes.paddingS),
          _buildLeyenda(context),
          const SizedBox(height: AppSizes.paddingM),
          _buildListaHistorial(context),
          const SizedBox(height: AppSizes.paddingM),
          _buildRubrosInfo(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context)
  {
    return Row(
      children: [
        const Icon(Icons.history_rounded, color: AppColors.headingDark),
        const SizedBox(width: AppSizes.paddingS),
        Text(
          'Historial de asistencias',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color:      AppColors.deepNavy,
          ),
        ),
      ],
    );
  }

  Widget _buildResumen(BuildContext context)
  {
    return Row(
      children: [
        Expanded(child: _ResumenItemWidget(
          valor: materia.sesionesPresente.toString(),
          label: 'Presentes',
          color: AppColors.successGreen,
        )),
        Expanded(child: _ResumenItemWidget(
          valor: materia.sesionesFalta.toString(),
          label: 'Faltas',
          color: AppColors.actionRed,
        )),
        Expanded(child: _ResumenItemWidget(
          valor: materia.sesionesJustificada.toString(),
          label: 'Justificadas',
          color: AppColors.warningOrange,
        )),
      ],
    );
  }

  Widget _buildLeyenda(BuildContext context)
  {
    return const Row(
      children: [
        _LeyendaItemWidget(color: AppColors.successGreen,  label: 'Asistencia'),
        SizedBox(width: AppSizes.paddingM),
        _LeyendaItemWidget(color: AppColors.actionRed,     label: 'Falta'),
        SizedBox(width: AppSizes.paddingM),
        _LeyendaItemWidget(color: AppColors.warningOrange, label: 'Justificada'),
      ],
    );
  }

  Widget _buildListaHistorial(BuildContext context)
  {
    if (materia.historial.isEmpty) {
      return Center(
        child: Text(
          'Sin registros aun',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.neutralGrey,
          ),
        ),
      );
    }

    return Column(
      children: materia.historial.map((asistencia) =>
          _HistorialItemWidget(asistencia: asistencia),
      ).toList(),
    );
  }

  Widget _buildRubrosInfo(BuildContext context)
  {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color:        AppColors.cloudBlue,
        borderRadius: BorderRadius.circular(AppSizes.radiusInput),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rubros de evaluacion',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color:      AppColors.deepNavy,
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
          _RubroInfoItemWidget(
            nombre:     'Ordinario',
            porcentaje: materia.porcentajeMinOrdinario,
            cumple:     materia.cumpleOrdinario,
          ),
          const SizedBox(height: AppSizes.paddingXS),
          _RubroInfoItemWidget(
            nombre:     'Extraordinario',
            porcentaje: materia.porcentajeMinExtraordinario,
            cumple:     materia.cumpleExtraordinario,
          ),
        ],
      ),
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

class _LeyendaItemWidget extends StatelessWidget
{
  final Color  color;
  final String label;

  const _LeyendaItemWidget({required this.color, required this.label});

  @override
  Widget build(BuildContext context)
  {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10, height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSizes.paddingXS),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: AppSizes.fontCaption,
            color:    AppColors.neutralGrey,
          ),
        ),
      ],
    );
  }
}

class _HistorialItemWidget extends StatelessWidget
{
  final AsistenciaModel asistencia;

  const _HistorialItemWidget({required this.asistencia});

  @override
  Widget build(BuildContext context)
  {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingS),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical:   AppSizes.paddingS,
      ),
      decoration: BoxDecoration(
        color:        _colorFondo,
        borderRadius: BorderRadius.circular(AppSizes.radiusInput),
      ),
      child: Row(
        children: [
          Icon(_icono, size: AppSizes.iconS, color: _color),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Text(
              _etiqueta,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:      _color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            _formatearFecha(asistencia.horaRegistro),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: AppSizes.fontCaption,
              color:    AppColors.neutralGrey,
            ),
          ),
        ],
      ),
    );
  }

  Color get _color
  {
    if (asistencia.isPresente)    return AppColors.successGreen;
    if (asistencia.isJustificada) return AppColors.warningOrange;
    return AppColors.actionRed;
  }

  Color get _colorFondo
  {
    if (asistencia.isPresente)    return AppColors.successGreen.withValues(alpha: 0.08);
    if (asistencia.isJustificada) return AppColors.warningOrange.withValues(alpha: 0.1);
    return AppColors.actionRed.withValues(alpha: 0.08);
  }

  IconData get _icono
  {
    if (asistencia.isPresente)    return Icons.check_circle_outline_rounded;
    if (asistencia.isJustificada) return Icons.info_outline_rounded;
    return Icons.cancel_outlined;
  }

  String get _etiqueta
  {
    if (asistencia.isPresente)    return 'Asistencia';
    if (asistencia.isJustificada) return 'Justificada';
    return 'Falta';
  }

  String _formatearFecha(DateTime fecha)
  {
    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year}';
  }
}

class _RubroInfoItemWidget extends StatelessWidget
{
  final String nombre;
  final double porcentaje;
  final bool   cumple;

  const _RubroInfoItemWidget({
    required this.nombre,
    required this.porcentaje,
    required this.cumple,
  });

  @override
  Widget build(BuildContext context)
  {
    return Row(
      children: [
        Icon(
          cumple ? Icons.check_circle_outline_rounded : Icons.cancel_outlined,
          size:  AppSizes.iconS,
          color: cumple ? AppColors.successGreen : AppColors.actionRed,
        ),
        const SizedBox(width: AppSizes.paddingS),
        Text(
          '$nombre — ${porcentaje.toInt()}% minimo',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.deepNavy,
          ),
        ),
      ],
    );
  }
}