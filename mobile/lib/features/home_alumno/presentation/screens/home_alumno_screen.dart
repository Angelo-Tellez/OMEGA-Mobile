// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : home_alumno_screen.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martínez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Pantalla principal del alumno
//   [002] 07/05/2026 - Jorge Alejandro Martinez Toris - Fix: clave solo visible con sesion activa
//   [003] 08/05/2026 - Jorge Alejandro Martinez Toris - Polling 30s + aviso sesion activa
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/config/app_router.dart';
import '../../../../features/auth/bloc/auth_bloc.dart';
import '../../../../features/auth/bloc/auth_event.dart';
import '../../../../features/auth/bloc/auth_state.dart';
import '../../bloc/home_alumno_bloc.dart';
import '../../bloc/home_alumno_event.dart';
import '../../bloc/home_alumno_state.dart';
import '../widgets/materia_card_widget.dart';
import '../widgets/historial_card_widget.dart';

class HomeAlumnoScreen extends StatelessWidget
{
  const HomeAlumnoScreen({super.key});

  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (_) => HomeAlumnoBloc()..add(const HomeAlumnoStarted()),
      child: const _HomeAlumnoView(),
    );
  }
}

class _HomeAlumnoView extends StatefulWidget
{
  const _HomeAlumnoView();

  @override
  State<_HomeAlumnoView> createState() => _HomeAlumnoViewState();
}

class _HomeAlumnoViewState extends State<_HomeAlumnoView>
{
  final _claveController = TextEditingController();
  Timer?   _pollingTimer;
  Set<int> _gruposConSesionActiva = {};

  @override
  void initState()
  {
    super.initState();
    _startPolling();
  }

  void _startPolling()
  {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_)
    {
      if (mounted) {
        context.read<HomeAlumnoBloc>().add(const HomeAlumnoStarted());
      }
    });
  }

  @override
  void dispose()
  {
    _pollingTimer?.cancel();
    _claveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<HomeAlumnoBloc, HomeAlumnoState>(
      listener: (context, state)
      {
        if (state is HomeAlumnoLoaded) {
          final nuevasActivas = state.materias
              .where((m) => m.tieneSesionActiva)
              .map((m) => m.grupoId)
              .toSet();

          final hayNuevas = nuevasActivas.difference(_gruposConSesionActiva).isNotEmpty;

          if (hayNuevas && _gruposConSesionActiva.isNotEmpty) {
            final materia = state.materias.firstWhere((m) => m.tieneSesionActiva);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:         Text('¡Sesion activa en ${materia.materia}! Ingresa tu clave.'),
                backgroundColor: AppColors.electricBlue,
                duration:        const Duration(seconds: 4),
              ),
            );
          }
          _gruposConSesionActiva = nuevasActivas;
        }

        if (state is HomeAlumnoRegistroExitoso) {
          _claveController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:         Text(state.mensaje),
              backgroundColor: AppColors.successGreen,
            ),
          );
        }

        if (state is HomeAlumnoError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:         Text(state.mensaje),
              backgroundColor: AppColors.darkSlate,
            ),
          );
        }
      },
      builder: (context, state)
      {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState)
          {
            final nombreAlumno = authState is AuthSuccess
                ? '${authState.usuario.nombre} ${authState.usuario.apPat}'
                : 'Alumno';

            return Scaffold(
              appBar: _buildAppBar(context, nombreAlumno, state),
              floatingActionButton: state is HomeAlumnoLoaded
                  ? FloatingActionButton.extended(
                onPressed:       () => context.push(AppRouter.unirseMateria),
                backgroundColor: AppColors.primaryCoral,
                foregroundColor: AppColors.baseSurface,
                icon:            const Icon(Icons.group_add_rounded),
                label:           const Text('Unirse a materia'),
              )
                  : null,
              body: _buildBody(context, state),
            );
          },
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, String nombreAlumno, HomeAlumnoState state)
  {
    // Mostrar punto rojo en notificaciones solo si hay sesion activa o riesgo
    final hayAlertas = state is HomeAlumnoLoaded &&
        state.materias.any((m) => m.tieneSesionActiva || m.enRiesgo || m.limiteExcedido);

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hola, $nombreAlumno',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color:      AppColors.deepNavy,
            ),
          ),
          Text(
            'Mis asistencias',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.neutralGrey,
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon:  const Icon(Icons.notifications_outlined),
              color: AppColors.neutralGrey,
              onPressed: () => context.push(AppRouter.notificaciones),
            ),
            if (hayAlertas)
              Positioned(
                right: 8,
                top:   8,
                child: Container(
                  width:  10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryCoral,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        IconButton(
          icon:  const Icon(Icons.person_outline_rounded),
          color: AppColors.neutralGrey,
          onPressed: () => context.push(AppRouter.perfil),
        ),
        IconButton(
          icon:  const Icon(Icons.logout_rounded),
          color: AppColors.neutralGrey,
          onPressed: ()
          {
            context.read<AuthBloc>().add(const AuthLogoutRequested());
            context.go(AppRouter.login);
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, HomeAlumnoState state)
  {
    if (state is HomeAlumnoLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryCoral),
      );
    }

    if (state is HomeAlumnoLoaded) {
      return RefreshIndicator(
        color:     AppColors.primaryCoral,
        onRefresh: () async
        {
          context.read<HomeAlumnoBloc>().add(const HomeAlumnoStarted());
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          children: [
            if (state.materiaActiva != null && state.materiaActiva!.tieneSesionActiva) ...[
              _buildRegistroSection(context, state),
              const SizedBox(height: AppSizes.paddingL),
            ],
            _buildMateriasSection(context, state),
            const SizedBox(height: AppSizes.paddingL),
            if (state.materiaActiva != null)
              HistorialCardWidget(materia: state.materiaActiva!),
            const SizedBox(height: AppSizes.paddingL),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildRegistroSection(BuildContext context, HomeAlumnoLoaded state)
  {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color:        AppColors.baseSurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.surface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoClaseActiva(context, state),
          const SizedBox(height: AppSizes.paddingM),
          _buildCampoClaveSection(context, state),
        ],
      ),
    );
  }

  Widget _buildInfoClaseActiva(BuildContext context, HomeAlumnoLoaded state)
  {
    final materia = state.materiaActiva!;

    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color:        AppColors.cloudBlue,
        borderRadius: BorderRadius.circular(AppSizes.radiusInput),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book_rounded,
                  size: AppSizes.iconS, color: AppColors.deepNavy),
              const SizedBox(width: AppSizes.paddingXS),
              Expanded(
                child: Text(
                  materia.materia,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.deepNavy, fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingXS),
          Row(
            children: [
              const Icon(Icons.person_outline_rounded,
                  size: AppSizes.iconS, color: AppColors.deepNavy),
              const SizedBox(width: AppSizes.paddingXS),
              Text(
                materia.nombreDocente ?? 'Sin docente',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.deepNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingXS),
          Row(
            children: [
              const Icon(Icons.schedule_outlined,
                  size: AppSizes.iconS, color: AppColors.deepNavy),
              const SizedBox(width: AppSizes.paddingXS),
              Text(
                materia.horario ?? 'Sesion en curso',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.deepNavy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCampoClaveSection(BuildContext context, HomeAlumnoLoaded state)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingresa la clave de asistencia',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color:      AppColors.deepNavy,
          ),
        ),
        const SizedBox(height: AppSizes.paddingM),
        TextFormField(
          controller:         _claveController,
          textAlign:          TextAlign.center,
          keyboardType:       TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize:      AppSizes.fontDisplay,
            letterSpacing: 10,
            color:         AppColors.deepNavy,
          ),
          decoration: const InputDecoration(
            hintText:   '• • • • • •',
            prefixIcon: Icon(Icons.vpn_key_outlined),
          ),
        ),
        const SizedBox(height: AppSizes.paddingM),
        _buildProgressoMateriaActiva(context, state),
        const SizedBox(height: AppSizes.paddingM),
        SizedBox(
          width:  double.infinity,
          height: AppSizes.heightButton,
          child:  ElevatedButton(
            onPressed: state.registrando
                ? null
                : () => _onRegistrarPressed(context, state),
            child: state.registrando
                ? const SizedBox(
              height: 22, width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color:       AppColors.baseSurface,
              ),
            )
                : const Text('Registrar asistencia'),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressoMateriaActiva(BuildContext context, HomeAlumnoLoaded state)
  {
    final materia   = state.materiaActiva!;
    final asistidas = materia.sesionesPresente + materia.sesionesJustificada;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              materia.materia,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.neutralGrey,
              ),
            ),
            Text(
              '$asistidas/${materia.totalSesiones}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:      AppColors.headingDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingXS),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value:           materia.porcentajeAsistencia / 100,
            minHeight:       6,
            backgroundColor: AppColors.surface,
            valueColor:      const AlwaysStoppedAnimation<Color>(AppColors.primaryCoral),
          ),
        ),
      ],
    );
  }

  Widget _buildMateriasSection(BuildContext context, HomeAlumnoLoaded state)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mis materias',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: AppSizes.fontTitle,
          ),
        ),
        const SizedBox(height: AppSizes.paddingM),
        ...state.materias.map((materia) => MateriaCardWidget(
          materia:    materia,
          isSelected: state.materiaActiva?.grupoId == materia.grupoId,
          onTap: () => context.read<HomeAlumnoBloc>().add(
            MateriaSeleccionada(grupoId: materia.grupoId),
          ),
        )),
      ],
    );
  }

  void _onRegistrarPressed(BuildContext context, HomeAlumnoLoaded state)
  {
    final clave = _claveController.text.trim();

    if (clave.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:         Text('Ingresa la clave de asistencia'),
          backgroundColor: AppColors.darkSlate,
        ),
      );
      return;
    }

    context.read<HomeAlumnoBloc>().add(
      RegistroAsistenciaSolicitado(
        clave:   clave,
        grupoId: state.materiaActiva!.grupoId,
      ),
    );
  }
}