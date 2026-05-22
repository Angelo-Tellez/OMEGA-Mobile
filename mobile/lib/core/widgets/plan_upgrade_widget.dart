// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : plan_upgrade_widget.dart
// Created on : 22/05/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 22/05/2026 - Jorge Alejandro Martinez Toris - Widget paywall plan mensual
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/app_router.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Muestra una pantalla/sección de bloqueo cuando el usuario
/// intenta acceder a una funcionalidad exclusiva del Plan Mensual.
class PlanUpgradeWidget extends StatelessWidget
{
  final String icono;
  final String titulo;
  final String descripcion;
  final List<String> beneficios;

  const PlanUpgradeWidget({
    super.key,
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.beneficios,
  });

  @override
  Widget build(BuildContext context)
  {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Candado
            Container(
              width:  80,
              height: 80,
              decoration: BoxDecoration(
                color:        AppColors.subtleWarm,
                borderRadius: BorderRadius.circular(AppSizes.radiusCard),
              ),
              child: Center(
                child: Text(icono, style: const TextStyle(fontSize: 36)),
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),

            // Titulo
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color:      AppColors.deepNavy,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.paddingS),

            // Descripcion
            Text(
              descripcion,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.neutralGrey,
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),

            // Beneficios
            Container(
              width:   double.infinity,
              padding: const EdgeInsets.all(AppSizes.paddingM),
              decoration: BoxDecoration(
                color:        AppColors.cloudBlue,
                borderRadius: BorderRadius.circular(AppSizes.radiusCard),
                border:       Border.all(color: AppColors.headingDark.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plan Mensual incluye:',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color:      AppColors.deepNavy,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  ...beneficios.map((b) => Padding(
                    padding: const EdgeInsets.only(top: AppSizes.paddingXS),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.successGreen,
                          size:  AppSizes.iconS,
                        ),
                        const SizedBox(width: AppSizes.paddingS),
                        Expanded(
                          child: Text(
                            b,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.deepNavy,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),

            // Boton
            SizedBox(
              width:  double.infinity,
              height: AppSizes.heightButton,
              child:  ElevatedButton.icon(
                onPressed: () => context.push(AppRouter.suscripcion),
                icon:  const Icon(Icons.workspace_premium_rounded),
                label: const Text('Ver Plan Mensual — \$149 MXN/mes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCoral,
                  foregroundColor: AppColors.baseSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusButton),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
