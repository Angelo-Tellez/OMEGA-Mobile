// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : plan_card_widget.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Tarjeta de plan de suscripcion
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class PlanCardWidget extends StatelessWidget
{
  final String       nombre;
  final String       precio;
  final String       descripcion;
  final List<String> beneficios;
  final List<String> limitaciones;
  final bool         isActual;
  final bool         isRecomendado;
  final VoidCallback? onContratar;

  const PlanCardWidget({
    super.key,
    required this.nombre,
    required this.precio,
    required this.descripcion,
    required this.beneficios,
    required this.limitaciones,
    required this.isActual,
    required this.isRecomendado,
    this.onContratar,
  });

  @override
  Widget build(BuildContext context)
  {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: isRecomendado ? AppColors.subtleWarm : AppColors.baseSurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(
          color: isRecomendado ? AppColors.primaryCoral : AppColors.surface,
          width: isRecomendado ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: AppSizes.paddingM),
          _buildPrecio(context),
          const SizedBox(height: AppSizes.paddingM),
          _buildBeneficios(context),
          if (limitaciones.isNotEmpty) ...[
            const SizedBox(height: AppSizes.paddingS),
            _buildLimitaciones(context),
          ],
          const SizedBox(height: AppSizes.paddingM),
          _buildBoton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context)
  {
    return Row(
      children: [
        Expanded(
          child: Text(
            nombre,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize:   AppSizes.fontTitle,
              color:      AppColors.deepNavy,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (isRecomendado)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingS,
              vertical:   AppSizes.paddingXS,
            ),
            decoration: BoxDecoration(
              color:        AppColors.primaryCoral,
              borderRadius: BorderRadius.circular(AppSizes.radiusInput),
            ),
            child: Text(
              'Recomendado',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:    AppColors.baseSurface,
                fontSize: AppSizes.fontCaption,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        if (isActual)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingS,
              vertical:   AppSizes.paddingXS,
            ),
            decoration: BoxDecoration(
              color:        AppColors.successGreen,
              borderRadius: BorderRadius.circular(AppSizes.radiusInput),
            ),
            child: Text(
              'Plan actual',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:    AppColors.baseSurface,
                fontSize: AppSizes.fontCaption,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPrecio(BuildContext context)
  {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          precio,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize:   AppSizes.fontH1,
            color:      AppColors.primaryCoral,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (precio != 'Gratis')
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.paddingXS),
            child: Text(
              ' MXN/mes',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.neutralGrey,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBeneficios(BuildContext context)
  {
    return Column(
      children: beneficios.map((b) => Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.paddingXS),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              size:  AppSizes.iconS,
              color: AppColors.successGreen,
            ),
            const SizedBox(width: AppSizes.paddingS),
            Expanded(
              child: Text(
                b,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onyxGrey,
                ),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildLimitaciones(BuildContext context)
  {
    return Column(
      children: limitaciones.map((l) => Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.paddingXS),
        child: Row(
          children: [
            const Icon(
              Icons.cancel_outlined,
              size:  AppSizes.iconS,
              color: AppColors.neutralGrey,
            ),
            const SizedBox(width: AppSizes.paddingS),
            Expanded(
              child: Text(
                l,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutralGrey,
                ),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildBoton(BuildContext context)
  {
    if (isActual) {
      return SizedBox(
        width:  double.infinity,
        height: AppSizes.heightButton,
        child:  OutlinedButton(
          onPressed: null,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.surface),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusButton),
            ),
          ),
          child: Text(
            'Plan activo',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.neutralGrey,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width:  double.infinity,
      height: AppSizes.heightButton,
      child:  ElevatedButton(
        onPressed: onContratar,
        child: const Text('Contratar plan'),
      ),
    );
  }
}