// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : grupo_card_widget.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martínez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Tarjeta de grupo para el home docente
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../data/grupo_model.dart';

class GrupoCardWidget extends StatelessWidget
{
  final GrupoModel   grupo;
  final bool         sesionActiva;
  final VoidCallback onAbrirSesion;
  final VoidCallback onCerrarSesion;

  const GrupoCardWidget({
    super.key,
    required this.grupo,
    required this.sesionActiva,
    required this.onAbrirSesion,
    required this.onCerrarSesion,
  });

  @override
  Widget build(BuildContext context)
  {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color:        AppColors.baseSurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(color: AppColors.surface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(context),
          const SizedBox(height: AppSizes.paddingS),
          _buildCardInfo(context),
          const SizedBox(height: AppSizes.paddingM),
          _buildCardActions(context),
        ],
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context)
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
            Icons.groups_rounded,
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
                grupo.materia,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:      AppColors.deepNavy,
                ),
              ),
              Text(
                grupo.nombre,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutralGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardInfo(BuildContext context)
  {
    return Row(
      children: [
        _InfoChipWidget(
          icon:  Icons.people_outline_rounded,
          label: '${grupo.noAlumnos} alumnos',
        ),
        const SizedBox(width: AppSizes.paddingS),
        _InfoChipWidget(
          icon:  Icons.calendar_today_outlined,
          label: grupo.periodo,
        ),
        const SizedBox(width: AppSizes.paddingS),
        _InfoChipWidget(
          icon:  Icons.vpn_key_outlined,
          label: grupo.codigoInv,
        ),
      ],
    );
  }

  Widget _buildCardActions(BuildContext context)
  {
    if (sesionActiva) {
      return SizedBox(
        width: double.infinity,
        height: AppSizes.heightButton,
        child: OutlinedButton.icon(
          onPressed: onCerrarSesion,
          icon: const Icon(Icons.stop_circle_outlined, color: AppColors.actionRed),
          label: const Text('Cerrar sesion activa'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.actionRed,
            side: const BorderSide(color: AppColors.actionRed),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusButton),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: AppSizes.heightButton,
      child: ElevatedButton.icon(
        onPressed: onAbrirSesion,
        icon: const Icon(Icons.play_circle_outline_rounded),
        label: const Text('Abrir sesion'),
      ),
    );
  }
}

class _InfoChipWidget extends StatelessWidget
{
  final IconData icon;
  final String   label;

  const _InfoChipWidget({required this.icon, required this.label});

  @override
  Widget build(BuildContext context)
  {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingS,
        vertical:   AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color:        AppColors.cloudBlue,
        borderRadius: BorderRadius.circular(AppSizes.radiusInput),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.deepNavy),
          const SizedBox(width: AppSizes.paddingXS),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: AppSizes.fontCaption,
              color:    AppColors.deepNavy,
            ),
          ),
        ],
      ),
    );
  }
}