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
//   [003] 28/05/2026 - Jorge Alejandro Martinez Toris - StatefulWidget: conteo local de alumnos
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/config/app_router.dart';
import '../../bloc/home_docente_bloc.dart';
import '../../bloc/home_docente_event.dart';
import '../../data/grupo_model.dart';

class GrupoCardWidget extends StatefulWidget
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
  State<GrupoCardWidget> createState() => _GrupoCardWidgetState();
}

class _GrupoCardWidgetState extends State<GrupoCardWidget>
{
  late int _noAlumnos;

  @override
  void initState()
  {
    super.initState();
    _noAlumnos = widget.grupo.noAlumnos;
  }

  /// Cuando el BLoC emite un nuevo estado con datos actualizados,
  /// sincronizamos el conteo local si el backend entregó un valor mayor.
  @override
  void didUpdateWidget(GrupoCardWidget oldWidget)
  {
    super.didUpdateWidget(oldWidget);
    final nuevoConteo = widget.grupo.noAlumnos;
    // Solo actualizamos si el valor del backend cambió respecto al widget anterior.
    // Si el conteo local es mayor (proviene del endpoint de alumnos), lo conservamos.
    if (nuevoConteo != oldWidget.grupo.noAlumnos && nuevoConteo > _noAlumnos) {
      setState(() => _noAlumnos = nuevoConteo);
    }
  }

  Future<void> _irAAlumnos() async
  {
    // go_router devuelve el valor que pasó la pantalla al hacer pop.
    // alumnos_grupo_screen hace pop(_alumnos.length) al presionar atrás.
    final resultado = await context.push<int>(
      AppRouter.alumnosGrupo,
      extra: {
        'grupoId':       widget.grupo.id,
        'nombreGrupo':   widget.grupo.nombre,
        'nombreMateria': widget.grupo.materia,
      },
    );

    if (!mounted) return;

    // Actualizamos el chip de inmediato con el conteo real devuelto por la pantalla.
    if (resultado != null) {
      setState(() => _noAlumnos = resultado);
    }

    // También disparamos un refresh del BLoC para sincronizar todo.
    context.read<HomeDocenteBloc>().add(const HomeDocenteStarted(docenteId: 1));
  }

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
                widget.grupo.materia,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:      AppColors.deepNavy,
                ),
              ),
              Text(
                widget.grupo.nombre,
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
          label: '$_noAlumnos alumnos',       // <-- conteo local, se actualiza al instante
        ),
        _InfoChipWidget(
          icon:  Icons.calendar_today_outlined,
          label: widget.grupo.periodo ?? 'Sin periodo',
        ),
        _InfoChipWidget(
          icon:  Icons.vpn_key_outlined,
          label: widget.grupo.codigoInv ?? 'Sin codigo',
        ),
      ],
    );
  }

  Widget _buildAccesosRapidos(BuildContext context)
  {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _irAAlumnos,
            icon:  const Icon(Icons.people_outline_rounded, size: AppSizes.iconS),
            label: const Text('Alumnos'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.headingDark,
              side:            const BorderSide(color: AppColors.headingDark),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusButton),
              ),
              padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS),
            ),
          ),
        ),
        const SizedBox(width: AppSizes.paddingS),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.push(
              AppRouter.historialSesiones,
              extra: {
                'grupoId':       widget.grupo.id,
                'nombreGrupo':   widget.grupo.nombre,
                'nombreMateria': widget.grupo.materia,
              },
            ),
            icon:  const Icon(Icons.history_edu_rounded, size: AppSizes.iconS),
            label: const Text('Sesiones'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.headingDark,
              side:            const BorderSide(color: AppColors.headingDark),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusButton),
              ),
              padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardActions(BuildContext context)
  {
    if (widget.sesionActiva) {
      return SizedBox(
        width:  double.infinity,
        height: AppSizes.heightButton,
        child:  OutlinedButton.icon(
          onPressed: widget.onCerrarSesion,
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
        onPressed: widget.onAbrirSesion,
        icon:  const Icon(Icons.play_circle_outline_rounded),
        label: const Text('Abrir sesion'),
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
