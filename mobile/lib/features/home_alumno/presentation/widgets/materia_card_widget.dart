// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : materia_card_widget.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martínez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Tarjeta de materia con progreso para el alumno
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../data/materia_alumno_model.dart';

class MateriaCardWidget extends StatelessWidget
{
  final MateriaAlumnoModel materia;
  final bool               isSelected;
  final VoidCallback       onTap;

  const MateriaCardWidget({
    super.key,
    required this.materia,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.subtleWarm : AppColors.baseSurface,
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          border: Border.all(
            color: isSelected ? AppColors.primaryCoral : AppColors.surface,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: AppSizes.paddingM),
            _buildProgressBar(context),
            const SizedBox(height: AppSizes.paddingM),
            _buildRubrosChips(context),
            if (materia.enRiesgo || materia.limiteExcedido) ...[
              const SizedBox(height: AppSizes.paddingM),
              _buildAlerta(context),
            ],
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
            color: isSelected ? AppColors.primaryCoral : AppColors.cloudBlue,
            borderRadius: BorderRadius.circular(AppSizes.radiusInput),
          ),
          child: Icon(
            Icons.menu_book_rounded,
            size:  AppSizes.iconM,
            color: isSelected ? AppColors.baseSurface : AppColors.deepNavy,
          ),
        ),
        const SizedBox(width: AppSizes.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                materia.materia,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:      AppColors.deepNavy,
                ),
              ),
              Text(
                '${materia.nombreGrupo} • ${materia.horario}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutralGrey,
                ),
              ),
            ],
          ),
        ),
        Text(
          '${materia.porcentajeAsistencia.toStringAsFixed(0)}%',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: AppSizes.fontH2,
            color:    _colorPorcentaje,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${materia.sesionesPresente + materia.sesionesJustificada}/${materia.totalSesiones} asistencias',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.neutralGrey,
              ),
            ),
            Text(
              '${materia.faltasPermitidas} faltas restantes',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:      materia.enRiesgo ? AppColors.actionRed : AppColors.neutralGrey,
                fontWeight: materia.enRiesgo ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingXS),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value:            materia.porcentajeAsistencia / 100,
            minHeight:        8,
            backgroundColor:  AppColors.surface,
            valueColor: AlwaysStoppedAnimation<Color>(_colorPorcentaje),
          ),
        ),
      ],
    );
  }

  Widget _buildRubrosChips(BuildContext context)
  {
    return Row(
      children: [
        _RubroChipWidget(
          label:    'Ordinario ${materia.porcentajeMinOrdinario.toInt()}%',
          cumple:   materia.cumpleOrdinario,
        ),
        const SizedBox(width: AppSizes.paddingS),
        _RubroChipWidget(
          label:    'Extraordinario ${materia.porcentajeMinExtraordinario.toInt()}%',
          cumple:   materia.cumpleExtraordinario,
        ),
      ],
    );
  }

  Widget _buildAlerta(BuildContext context)
  {
    final esLimiteExcedido = materia.limiteExcedido;

    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical:   AppSizes.paddingS,
      ),
      decoration: BoxDecoration(
        color: esLimiteExcedido
            ? AppColors.actionRed.withOpacity(0.1)
            : AppColors.warningOrange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusInput),
        border: Border.all(
          color: esLimiteExcedido ? AppColors.actionRed : AppColors.warningOrange,
        ),
      ),
      child: Row(
        children: [
          Icon(
            esLimiteExcedido
                ? Icons.error_outline_rounded
                : Icons.warning_amber_rounded,
            size:  AppSizes.iconS,
            color: esLimiteExcedido ? AppColors.actionRed : AppColors.actionRed,
          ),
          const SizedBox(width: AppSizes.paddingS),
          Expanded(
            child: Text(
              esLimiteExcedido
                  ? 'Limite de faltas excedido. Perdiste el derecho a ordinario.'
                  : 'Riesgo proximo. Solo te quedan ${materia.faltasPermitidas} falta(s).',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:    esLimiteExcedido ? AppColors.actionRed : AppColors.onyxGrey,
                fontSize: AppSizes.fontCaption,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color get _colorPorcentaje
  {
    if (materia.porcentajeAsistencia >= materia.porcentajeMinOrdinario) {
      return AppColors.successGreen;
    }
    if (materia.porcentajeAsistencia >= materia.porcentajeMinExtraordinario) {
      return AppColors.warningOrange;
    }
    return AppColors.actionRed;
  }
}

class _RubroChipWidget extends StatelessWidget
{
  final String label;
  final bool   cumple;

  const _RubroChipWidget({required this.label, required this.cumple});

  @override
  Widget build(BuildContext context)
  {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingS,
        vertical:   AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color: cumple
            ? AppColors.successGreen.withOpacity(0.1)
            : AppColors.actionRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusInput),
        border: Border.all(
          color: cumple ? AppColors.successGreen : AppColors.actionRed,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            cumple ? Icons.check_circle_outline_rounded : Icons.cancel_outlined,
            size:  12,
            color: cumple ? AppColors.successGreen : AppColors.actionRed,
          ),
          const SizedBox(width: AppSizes.paddingXS),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize:   AppSizes.fontCaption,
              color:      cumple ? AppColors.successGreen : AppColors.actionRed,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}