// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : cambiar_estado_dialog.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Dialogo para cambiar estado de asistencia
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../data/registro_sesion_model.dart';

class CambiarEstadoDialog extends StatefulWidget
{
  final RegistroSesionModel registro;

  const CambiarEstadoDialog({super.key, required this.registro});

  static Future<int?> show(BuildContext context, RegistroSesionModel registro)
  {
    return showDialog<int>(
      context:            context,
      barrierDismissible: false,
      builder: (_) => CambiarEstadoDialog(registro: registro),
    );
  }

  @override
  State<CambiarEstadoDialog> createState() => _CambiarEstadoDialogState();
}

class _CambiarEstadoDialogState extends State<CambiarEstadoDialog>
{
  late int _estadoSeleccionado;

  @override
  void initState()
  {
    super.initState();
    _estadoSeleccionado = widget.registro.estado;
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
        'Cambiar asistencia',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontSize: AppSizes.fontTitle,
          color:    AppColors.deepNavy,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.registro.nombreAlumno,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color:      AppColors.deepNavy,
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),
          _buildOpcion(context, 1, 'Presente',    AppColors.successGreen, Icons.check_circle_outline_rounded),
          const SizedBox(height: AppSizes.paddingS),
          _buildOpcion(context, 2, 'Falta',       AppColors.actionRed,    Icons.cancel_outlined),
          const SizedBox(height: AppSizes.paddingS),
          _buildOpcion(context, 3, 'Justificada', AppColors.warningOrange, Icons.info_outline_rounded),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(
            'Cancelar',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color:      AppColors.headingDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_estadoSeleccionado),
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  Widget _buildOpcion(
      BuildContext context,
      int          valor,
      String       label,
      Color        color,
      IconData     icon,
      )
  {
    final isSelected = _estadoSeleccionado == valor;

    return GestureDetector(
      onTap: () => setState(() => _estadoSeleccionado = valor),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:  const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusInput),
          border: Border.all(
            color: isSelected ? color : AppColors.borderSky,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? color : AppColors.neutralGrey, size: AppSizes.iconS),
            const SizedBox(width: AppSizes.paddingM),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:      isSelected ? color : AppColors.neutralGrey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.radio_button_checked, color: color, size: AppSizes.iconS)
            else
              const Icon(Icons.radio_button_unchecked, color: AppColors.neutralGrey, size: AppSizes.iconS),
          ],
        ),
      ),
    );
  }
}
