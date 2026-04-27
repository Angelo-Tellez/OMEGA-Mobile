// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : grupo_card_widget.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [002] 27/04/2026 - Jorge Alejandro Martinez Toris - Tarjeta de grupo para el home docente
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/config/app_router.dart';
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
      margin:  const EdgeInsets.only(bottom: AppSizes.paddingM),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color:        AppColors.baseSurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.surface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(context),
          const SizedBox(height: AppSizes.paddingS),
          _buildCardInfo(context),
          const SizedBox(height: AppSizes.paddingM),
          _buildAccesosRapidos(context),
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
    return Wrap(
      spacing:    AppSizes.paddingS,
      runSpacing: AppSizes.paddingXS,
      children: [
        _InfoChipWidget(
          icon:  Icons.people_outline_rounded,
          label: '${grupo.noAlumnos} alumnos',
        ),
        _InfoChipWidget(
          icon:  Icons.calendar_today_outlined,
          label: grupo.periodo,
        ),
        _InfoChipWidget(
          icon:  Icons.vpn_key_outlined,
          label: grupo.codigoInv,
        ),
      ],
    );
  }

  Widget _buildAccesosRapidos(BuildContext context)
  {
    return Row(
      children: [
        Expanded(
          child: _AccesoRapidoWidget(
            icon:  Icons.people_outline_rounded,
            label: 'Alumnos',
            color: AppColors.headingDark,
            onTap: () => context.push(
              AppRouter.alumnosGrupo,
              extra: {
                'grupoId':       grupo.id,
                'nombreGrupo':   grupo.nombre,
                'nombreMateria': grupo.materia,
              },
            ),
          ),
        ),
        const SizedBox(width: AppSizes.paddingS),
        Expanded(
          child: _AccesoRapidoWidget(
            icon:  Icons.history_edu_rounded,
            label: 'Sesiones',
            color: AppColors.headingDark,
            onTap: () => context.push(
              AppRouter.historialSesiones,
              extra: {
                'grupoId':       grupo.id,
                'nombreGrupo':   grupo.nombre,
                'nombreMateria': grupo.materia,
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardActions(BuildContext context)
  {
    if (sesionActiva) {
      return SizedBox(
        width:  double.infinity,
        height: AppSizes.heightButton,
        child:  OutlinedButton.icon(
          onPressed: onCerrarSesion,
          icon:  const Icon(Icons.stop_circle_outlined, color: AppColors.actionRed),
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
      width:  double.infinity,
      height: AppSizes.heightButton,
      child:  ElevatedButton.icon(
        onPressed: onAbrirSesion,
        icon:  const Icon(Icons.play_circle_outline_rounded),
        label: const Text('Abrir sesion'),
      ),
    );
  }
}

class _AccesoRapidoWidget extends StatelessWidget
{
  final IconData     icon;
  final String       label;
  final Color        color;
  final VoidCallback onTap;

  const _AccesoRapidoWidget({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM,
          vertical:   AppSizes.paddingS,
        ),
        decoration: BoxDecoration(
          color:        AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusInput),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: AppSizes.iconS, color: color),
            const SizedBox(width: AppSizes.paddingXS),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:      color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
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