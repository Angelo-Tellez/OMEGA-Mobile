// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : agregar_rubro_dialog.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Dialogo para agregar o editar rubro
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../data/rubro_model.dart';

class AgregarRubroDialog extends StatefulWidget
{
  final RubroModel? rubroExistente;

  const AgregarRubroDialog({super.key, this.rubroExistente});

  static Future<Map<String, dynamic>?> show(
      BuildContext context, {
        RubroModel? rubroExistente,
      })
  {
    return showDialog<Map<String, dynamic>>(
      context:            context,
      barrierDismissible: false,
      builder: (_) => AgregarRubroDialog(rubroExistente: rubroExistente),
    );
  }

  @override
  State<AgregarRubroDialog> createState() => _AgregarRubroDialogState();
}

class _AgregarRubroDialogState extends State<AgregarRubroDialog>
{
  final _formKey              = GlobalKey<FormState>();
  final _nombreController     = TextEditingController();
  final _porcentajeController = TextEditingController();

  @override
  void initState()
  {
    super.initState();
    if (widget.rubroExistente != null) {
      _nombreController.text     = widget.rubroExistente!.nombre;
      _porcentajeController.text = widget.rubroExistente!.porcentajeMinimo.toInt().toString();
    }
  }

  @override
  void dispose()
  {
    _nombreController.dispose();
    _porcentajeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    final esEdicion = widget.rubroExistente != null;

    return AlertDialog(
      backgroundColor: AppColors.baseSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
      ),
      title: Text(
        esEdicion ? 'Editar rubro' : 'Nuevo rubro',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontSize: AppSizes.fontTitle,
          color:    AppColors.deepNavy,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller:         _nombreController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText:  'Nombre del rubro',
                hintText:   'Ej. Ordinario',
                prefixIcon: Icon(Icons.label_outline_rounded),
              ),
              validator: (value)
              {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa el nombre del rubro';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSizes.paddingM),
            TextFormField(
              controller:  _porcentajeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText:   'Porcentaje minimo de asistencia',
                hintText:    'Ej. 80',
                prefixIcon:  Icon(Icons.percent_rounded),
                suffixText:  '%',
              ),
              validator: (value)
              {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa el porcentaje minimo';
                }
                final numero = double.tryParse(value.trim());
                if (numero == null) {
                  return 'Ingresa un numero valido';
                }
                if (numero < 1 || numero > 100) {
                  return 'El porcentaje debe estar entre 1 y 100';
                }
                return null;
              },
            ),
          ],
        ),
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
          onPressed: ()
          {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop({
                'nombre':           _nombreController.text.trim(),
                'porcentajeMinimo': double.parse(_porcentajeController.text.trim()),
              });
            }
          },
          child: Text(esEdicion ? 'Guardar cambios' : 'Agregar'),
        ),
      ],
    );
  }
}