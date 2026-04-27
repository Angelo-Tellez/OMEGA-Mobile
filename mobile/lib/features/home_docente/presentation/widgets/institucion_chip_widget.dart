// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : institucion_chip_widget.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [002] 27/04/2026 - Jorge Alejandro Martinez Toris - Chip selector de institucion
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/config/app_router.dart';
import '../../data/institucion_model.dart';

class InstitucionChipWidget extends StatelessWidget
{
  final InstitucionModel institucion;
  final bool             isSelected;
  final VoidCallback     onTap;

  const InstitucionChipWidget({
    super.key,
    required this.institucion,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context)
  {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:  const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingM,
              vertical:   AppSizes.paddingS,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryCoral : AppColors.baseSurface,
              borderRadius: BorderRadius.only(
                topLeft:     const Radius.circular(AppSizes.radiusButton),
                bottomLeft:  const Radius.circular(AppSizes.radiusButton),
                topRight:    isSelected ? Radius.zero : const Radius.circular(AppSizes.radiusButton),
                bottomRight: isSelected ? Radius.zero : const Radius.circular(AppSizes.radiusButton),
              ),
              border: Border.all(
                color: isSelected ? AppColors.primaryCoral : AppColors.borderSky,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_balance_rounded,
                  size:  AppSizes.iconS,
                  color: isSelected ? AppColors.baseSurface : AppColors.neutralGrey,
                ),
                const SizedBox(width: AppSizes.paddingXS),
                Text(
                  institucion.nombre,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:      isSelected ? AppColors.baseSurface : AppColors.neutralGrey,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isSelected)
          GestureDetector(
            onTap: () => context.push(
              AppRouter.rubros,
              extra: {
                'institucionId':     institucion.id,
                'nombreInstitucion': institucion.nombre,
              },
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:  const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingS,
                vertical:   AppSizes.paddingS,
              ),
              decoration: BoxDecoration(
                color: AppColors.subtleWarm,
                borderRadius: const BorderRadius.only(
                  topRight:    Radius.circular(AppSizes.radiusButton),
                  bottomRight: Radius.circular(AppSizes.radiusButton),
                ),
                border: Border.all(color: AppColors.primaryCoral),
              ),
              child: const Icon(
                Icons.settings_rounded,
                size:  AppSizes.iconS,
                color: AppColors.primaryCoral,
              ),
            ),
          ),
      ],
    );
  }
}