// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : rubros_screen.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Pantalla de configuracion de rubros por institucion
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../data/rubro_model.dart';
import '../dialogs/agregar_rubro_dialog.dart';

class RubrosScreen extends StatefulWidget
{
  final int    institucionId;
  final String nombreInstitucion;

  const RubrosScreen({
    super.key,
    required this.institucionId,
    required this.nombreInstitucion,
  });

  @override
  State<RubrosScreen> createState() => _RubrosScreenState();
}

class _RubrosScreenState extends State<RubrosScreen>
{
  final List<RubroModel> _rubros = [
    const RubroModel(id: 1, institucionId: 1, nombre: 'Ordinario',      porcentajeMinimo: 80),
    const RubroModel(id: 2, institucionId: 1, nombre: 'Extraordinario', porcentajeMinimo: 60),
  ];

  int _nextId = 3;

  Future<void> _onAgregarPressed() async
  {
    final resultado = await AgregarRubroDialog.show(context);

    if (resultado != null && mounted) {
      setState(()
      {
        _rubros.add(RubroModel(
          id:               _nextId++,
          institucionId:    widget.institucionId,
          nombre:           resultado['nombre']           as String,
          porcentajeMinimo: resultado['porcentajeMinimo'] as double,
        ));
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:         Text('Rubro agregado correctamente'),
          backgroundColor: AppColors.successGreen,
        ),
      );
    }
  }

  Future<void> _onEditarPressed(RubroModel rubro) async
  {
    final resultado = await AgregarRubroDialog.show(
      context,
      rubroExistente: rubro,
    );

    if (resultado != null && mounted) {
      setState(()
      {
        final index = _rubros.indexWhere((r) => r.id == rubro.id);
        if (index != -1) {
          _rubros[index] = rubro.copyWith(
            nombre:           resultado['nombre']           as String,
            porcentajeMinimo: resultado['porcentajeMinimo'] as double,
          );
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:         Text('Rubro actualizado correctamente'),
          backgroundColor: AppColors.successGreen,
        ),
      );
    }
  }

  Future<void> _onEliminarPressed(RubroModel rubro) async
  {
    final confirmar = await showDialog<bool>(
      context:            context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.baseSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        ),
        title: Text(
          'Eliminar rubro',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: AppSizes.fontTitle,
            color:    AppColors.deepNavy,
          ),
        ),
        content: Text(
          'Estas a punto de eliminar el rubro "${rubro.nombre}". Esta accion no se puede deshacer.',
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
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      setState(() => _rubros.removeWhere((r) => r.id == rubro.id));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:         Text('Rubro "${rubro.nombre}" eliminado'),
          backgroundColor: AppColors.darkSlate,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:      const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rubros de evaluacion'),
            Text(
              widget.nombreInstitucion,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.neutralGrey,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon:    const Icon(Icons.add_rounded),
            color:   AppColors.primaryCoral,
            tooltip: 'Agregar rubro',
            onPressed: _onAgregarPressed,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildInfo(context),
            Expanded(child: _buildLista(context)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:       _onAgregarPressed,
        backgroundColor: AppColors.primaryCoral,
        foregroundColor: AppColors.baseSurface,
        icon:            const Icon(Icons.add_rounded),
        label:           const Text('Agregar rubro'),
      ),
    );
  }

  Widget _buildInfo(BuildContext context)
  {
    return Container(
      margin:  const EdgeInsets.all(AppSizes.paddingM),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color:        AppColors.cloudBlue,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.deepNavy,
            size:  AppSizes.iconM,
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Text(
              'Los rubros definen el porcentaje minimo de asistencia que un alumno necesita para tener derecho a cada tipo de evaluacion. Cada institucion puede tener sus propios rubros.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:    AppColors.deepNavy,
                fontSize: AppSizes.fontCaption,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLista(BuildContext context)
  {
    if (_rubros.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.assignment_outlined,
              size:  64,
              color: AppColors.surface,
            ),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              'Sin rubros configurados',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: AppSizes.fontTitle,
                color:    AppColors.neutralGrey,
              ),
            ),
            const SizedBox(height: AppSizes.paddingS),
            Text(
              'Agrega los rubros de evaluacion para esta institucion.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.neutralGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding:          const EdgeInsets.fromLTRB(
        AppSizes.paddingM,
        0,
        AppSizes.paddingM,
        AppSizes.paddingXL + AppSizes.heightButton,
      ),
      itemCount:        _rubros.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.paddingS),
      itemBuilder: (context, index)
      {
        final rubro = _rubros[index];
        return _RubroCardWidget(
          rubro:      rubro,
          onEditar:   () => _onEditarPressed(rubro),
          onEliminar: () => _onEliminarPressed(rubro),
        );
      },
    );
  }
}

class _RubroCardWidget extends StatelessWidget
{
  final RubroModel   rubro;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const _RubroCardWidget({
    required this.rubro,
    required this.onEditar,
    required this.onEliminar,
  });

  Color get _colorPorcentaje
  {
    if (rubro.porcentajeMinimo >= 80) return AppColors.successGreen;
    if (rubro.porcentajeMinimo >= 60) return AppColors.warningOrange;
    return AppColors.actionRed;
  }

  @override
  Widget build(BuildContext context)
  {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color:        AppColors.baseSurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.surface),
      ),
      child: Row(
        children: [
          Container(
            width:  56,
            height: 56,
            decoration: BoxDecoration(
              color:        _colorPorcentaje.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusInput),
              border:       Border.all(color: _colorPorcentaje),
            ),
            child: Center(
              child: Text(
                '${rubro.porcentajeMinimo.toInt()}%',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color:      _colorPorcentaje,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rubro.nombre,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color:      AppColors.deepNavy,
                  ),
                ),
                Text(
                  'Minimo ${rubro.porcentajeMinimo.toInt()}% de asistencia requerido',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.neutralGrey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon:    const Icon(Icons.edit_outlined),
            color:   AppColors.headingDark,
            tooltip: 'Editar',
            onPressed: onEditar,
          ),
          IconButton(
            icon:    const Icon(Icons.delete_outline_rounded),
            color:   AppColors.actionRed,
            tooltip: 'Eliminar',
            onPressed: onEliminar,
          ),
        ],
      ),
    );
  }
}