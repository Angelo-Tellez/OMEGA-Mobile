// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : alumnos_grupo_screen.dart
// Created on : 24/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] Pantalla de gestion de alumnos por grupo
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../data/alumno_grupo_model.dart';
import '../dialogs/eliminar_alumno_dialog.dart';

class AlumnosGrupoScreen extends StatefulWidget
{
  final int    grupoId;
  final String nombreGrupo;
  final String nombreMateria;

  const AlumnosGrupoScreen({
    super.key,
    required this.grupoId,
    required this.nombreGrupo,
    required this.nombreMateria,
  });

  @override
  State<AlumnosGrupoScreen> createState() => _AlumnosGrupoScreenState();
}

class _AlumnosGrupoScreenState extends State<AlumnosGrupoScreen>
{
  final _busquedaController = TextEditingController();
  String _filtro            = '';
  bool   _soloInactivos     = false;

  final List<AlumnoGrupoModel> _alumnos = [
    const AlumnoGrupoModel(
      alumnoId: 1, nombre: 'Maria',   apPat: 'Garcia',    apMat: 'Torres',
      email: 'maria@test.com',    totalSesiones: 10, sesionesAsistidas: 9,
      fechaInscripcion: '01/02/2026',
    ),
    const AlumnoGrupoModel(
      alumnoId: 2, nombre: 'Carlos',  apPat: 'Lopez',     apMat: 'Ramos',
      email: 'carlos@test.com',   totalSesiones: 10, sesionesAsistidas: 7,
      fechaInscripcion: '01/02/2026',
    ),
    const AlumnoGrupoModel(
      alumnoId: 3, nombre: 'Ana',     apPat: 'Martinez',  apMat: 'Vega',
      email: 'ana@test.com',      totalSesiones: 10, sesionesAsistidas: 0,
      fechaInscripcion: '03/02/2026',
    ),
    const AlumnoGrupoModel(
      alumnoId: 4, nombre: 'Luis',    apPat: 'Hernandez', apMat: 'Cruz',
      email: 'luis@test.com',     totalSesiones: 10, sesionesAsistidas: 10,
      fechaInscripcion: '01/02/2026',
    ),
    const AlumnoGrupoModel(
      alumnoId: 5, nombre: 'Sofia',   apPat: 'Perez',     apMat: 'Diaz',
      email: 'sofia@test.com',    totalSesiones: 10, sesionesAsistidas: 0,
      fechaInscripcion: '05/02/2026',
    ),
    const AlumnoGrupoModel(
      alumnoId: 6, nombre: 'Miguel',  apPat: 'Ramirez',   apMat: 'Flores',
      email: 'miguel@test.com',   totalSesiones: 10, sesionesAsistidas: 5,
      fechaInscripcion: '01/02/2026',
    ),
    const AlumnoGrupoModel(
      alumnoId: 7, nombre: 'Valeria', apPat: 'Sanchez',   apMat: 'Morales',
      email: 'valeria@test.com',  totalSesiones: 10, sesionesAsistidas: 8,
      fechaInscripcion: '02/02/2026',
    ),
  ];

  @override
  void dispose()
  {
    _busquedaController.dispose();
    super.dispose();
  }

  List<AlumnoGrupoModel> get _alumnosFiltrados
  {
    return _alumnos.where((a) {
      final coincideBusqueda = _filtro.isEmpty ||
          a.nombreCompleto.toLowerCase().contains(_filtro.toLowerCase()) ||
          a.email.toLowerCase().contains(_filtro.toLowerCase());

      final coincideInactivo = !_soloInactivos || a.inactivo;

      return coincideBusqueda && coincideInactivo;
    }).toList();
  }

  Future<void> _onEliminarPressed(AlumnoGrupoModel alumno) async
  {
    final confirmar = await EliminarAlumnoDialog.show(
      context,
      alumno.nombreCompleto,
    );

    if (confirmar == true && mounted) {
      setState(() => _alumnos.removeWhere((a) => a.alumnoId == alumno.alumnoId));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:         Text('${alumno.nombre} fue eliminado del grupo'),
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
            Text(widget.nombreMateria),
            Text(
              widget.nombreGrupo,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.neutralGrey,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildFiltros(context),
            _buildResumen(context),
            Expanded(child: _buildLista(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltros(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        children: [
          TextFormField(
            controller:   _busquedaController,
            onChanged:    (v) => setState(() => _filtro = v),
            decoration: const InputDecoration(
              hintText:    'Buscar alumno por nombre o correo',
              prefixIcon:  Icon(Icons.search_rounded),
              filled:      true,
              fillColor:   AppColors.baseSurface,
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Row(
            children: [
              Switch(
                value:          _soloInactivos,
                onChanged:      (v) => setState(() => _soloInactivos = v),
                activeColor:    AppColors.primaryCoral,
              ),
              Text(
                'Mostrar solo inactivos',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutralGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResumen(BuildContext context)
  {
    final inactivos = _alumnos.where((a) => a.inactivo).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color:        AppColors.cloudBlue,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ResumenItemWidget(
              valor: _alumnos.length.toString(),
              label: 'Total alumnos',
              color: AppColors.deepNavy,
            ),
          ),
          Expanded(
            child: _ResumenItemWidget(
              valor: (_alumnos.length - inactivos).toString(),
              label: 'Activos',
              color: AppColors.successGreen,
            ),
          ),
          Expanded(
            child: _ResumenItemWidget(
              valor: inactivos.toString(),
              label: 'Inactivos',
              color: AppColors.actionRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLista(BuildContext context)
  {
    final lista = _alumnosFiltrados;

    if (lista.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron alumnos',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.neutralGrey,
          ),
        ),
      );
    }

    return ListView.separated(
      padding:     const EdgeInsets.all(AppSizes.paddingM),
      itemCount:   lista.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.paddingS),
      itemBuilder: (context, index)
      {
        final alumno = lista[index];
        return _AlumnoCardWidget(
          alumno:    alumno,
          onEliminar: () => _onEliminarPressed(alumno),
        );
      },
    );
  }
}

class _ResumenItemWidget extends StatelessWidget
{
  final String valor;
  final String label;
  final Color  color;

  const _ResumenItemWidget({
    required this.valor,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: [
        Text(
          valor,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color:      color,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color:    AppColors.neutralGrey,
            fontSize: AppSizes.fontCaption,
          ),
        ),
      ],
    );
  }
}

class _AlumnoCardWidget extends StatelessWidget
{
  final AlumnoGrupoModel alumno;
  final VoidCallback     onEliminar;

  const _AlumnoCardWidget({
    required this.alumno,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context)
  {
    final iniciales =
    '${alumno.nombre[0]}${alumno.apPat[0]}'.toUpperCase();

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: alumno.inactivo
            ? AppColors.actionRed.withOpacity(0.05)
            : AppColors.baseSurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(
          color: alumno.inactivo ? AppColors.actionRed : AppColors.surface,
        ),
      ),
      child: Row(
        children: [
          _buildAvatar(iniciales),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(child: _buildInfo(context)),
          _buildAcciones(context),
        ],
      ),
    );
  }

  Widget _buildAvatar(String iniciales)
  {
    return Container(
      width:  44,
      height: 44,
      decoration: BoxDecoration(
        color: alumno.inactivo
            ? AppColors.actionRed.withOpacity(0.15)
            : AppColors.cloudBlue,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          iniciales,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color:      alumno.inactivo
                ? AppColors.actionRed
                : AppColors.deepNavy,
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                alumno.nombreCompleto,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:      AppColors.deepNavy,
                ),
              ),
            ),
            if (alumno.inactivo)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingS,
                  vertical:   AppSizes.paddingXS,
                ),
                decoration: BoxDecoration(
                  color:        AppColors.actionRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusInput),
                ),
                child: Text(
                  'Inactivo',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize:   AppSizes.fontCaption,
                    color:      AppColors.actionRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingXS),
        Text(
          alumno.email,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color:    AppColors.neutralGrey,
            fontSize: AppSizes.fontCaption,
          ),
        ),
        const SizedBox(height: AppSizes.paddingXS),
        Row(
          children: [
            _buildProgresoBarra(context),
            const SizedBox(width: AppSizes.paddingS),
            Text(
              '${alumno.sesionesAsistidas}/${alumno.totalSesiones}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize:   AppSizes.fontCaption,
                color:      AppColors.neutralGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgresoBarra(BuildContext context)
  {
    Color colorBarra;
    final pct = alumno.porcentajeAsistencia;

    if (pct >= 80)       colorBarra = AppColors.successGreen;
    else if (pct >= 60)  colorBarra = AppColors.warningOrange;
    else                 colorBarra = AppColors.actionRed;

    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value:           pct / 100,
          minHeight:       6,
          backgroundColor: AppColors.surface,
          valueColor:      AlwaysStoppedAnimation<Color>(colorBarra),
        ),
      ),
    );
  }

  Widget _buildAcciones(BuildContext context)
  {
    return IconButton(
      icon:  const Icon(Icons.person_remove_outlined),
      color: AppColors.actionRed,
      onPressed: onEliminar,
      tooltip: 'Eliminar del grupo',
    );
  }
}