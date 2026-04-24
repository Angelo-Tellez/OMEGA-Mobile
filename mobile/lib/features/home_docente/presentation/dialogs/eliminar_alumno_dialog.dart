// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : eliminar_alumno_dialog.dart
// Created on : 24/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] Dialogo de confirmacion para eliminar alumno
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class EliminarAlumnoDialog extends StatelessWidget
{
  final String nombreAlumno;

  const EliminarAlumnoDialog({super.key, required this.nombreAlumno});

  static Future<bool?> show(BuildContext context, String nombreAlumno)
  {
    return showDialog<bool>(
      context:            context,
      barrierDismissible: false,
      builder: (_) => EliminarAlumnoDialog(nombreAlumno: nombreAlumno),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return AlertDialog(
      backgroundColor: AppColors.baseSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
      ),
      title: Text(
        'Eliminar alumno',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontSize: AppSizes.fontTitle,
          color:    AppColors.deepNavy,
        ),
      ),
      content: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.neutralGrey,
          ),
          children: [
            const TextSpan(text: 'Estas a punto de eliminar a '),
            TextSpan(
              text: nombreAlumno,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color:      AppColors.deepNavy,
              ),
            ),
            const TextSpan(
              text: ' de este grupo. Esta accion no se puede deshacer.',
            ),
          ],
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
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}