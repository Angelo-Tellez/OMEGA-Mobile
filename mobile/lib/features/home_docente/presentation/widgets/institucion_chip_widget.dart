// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : institucion_chip_widget.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martínez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Chip selector de institucion
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM,
          vertical: AppSizes.paddingS,
        ),
        decoration: BoxDecoration(
          color:        isSelected ? AppColors.primaryCoral : AppColors.baseSurface,
          borderRadius: BorderRadius.circular(AppSizes.radiusButton),
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
    );
  }
}