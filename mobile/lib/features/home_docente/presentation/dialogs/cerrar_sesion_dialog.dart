// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : cerrar_sesion_dialog.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martínez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Dialogo de confirmacion para cerrar sesion activa
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class CerrarSesionDialog extends StatelessWidget
{
  const CerrarSesionDialog({super.key});

  static Future<bool?> show(BuildContext context)
  {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CerrarSesionDialog(),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return AlertDialog(
      backgroundColor:  AppColors.baseSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
      ),
      title: Text(
        'Cerrar registro',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontSize: AppSizes.fontTitle,
          color:    AppColors.deepNavy,
        ),
      ),
      content: Text(
        'Los alumnos ya no podran registrarse una vez que cierres la sesion.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.neutralGrey,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Cancelar',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color:      AppColors.headingDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.actionRed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusButton),
            ),
          ),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}