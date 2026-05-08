// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : home_docente_screen.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [003] 28/04/2026 - Jorge Alejandro Martinez Toris - Pantalla principal del docente
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/config/app_router.dart';
import '../../../../features/auth/bloc/auth_bloc.dart';
import '../../../../features/auth/bloc/auth_event.dart';
import '../../../../features/auth/bloc/auth_state.dart';
import '../../bloc/home_docente_bloc.dart';
import '../../bloc/home_docente_event.dart';
import '../../bloc/home_docente_state.dart';
import '../widgets/institucion_chip_widget.dart';
import '../widgets/grupo_card_widget.dart';
import '../widgets/sesion_activa_card_widget.dart';
import '../dialogs/cerrar_sesion_dialog.dart';

class HomeDocenteScreen extends StatelessWidget
{
  const HomeDocenteScreen({super.key});

  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (_) => HomeDocenteBloc()
        ..add(const HomeDocenteStarted(docenteId: 1)),
      child: const _HomeDocenteView(),
    );
  }
}

class _HomeDocenteView extends StatelessWidget
{
  const _HomeDocenteView();

  @override
  Widget build(BuildContext context)
  {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState)
      {
        final nombreDocente = authState is AuthSuccess
            ? '${authState.usuario.nombre} ${authState.usuario.apPat}'
            : 'Docente';

        return BlocBuilder<HomeDocenteBloc, HomeDocenteState>(
          builder: (context, state)
          {
            return Scaffold(
              appBar:               _buildAppBar(context, nombreDocente),
              floatingActionButton: _buildFAB(context),
              body:                 _buildBodyContent(context, state),
            );
          },
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, String nombreDocente)
  {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hola, $nombreDocente',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color:      AppColors.deepNavy,
            ),
          ),
          Text(
            'Panel del docente',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.neutralGrey,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon:    const Icon(Icons.bar_chart_rounded),
          color:   AppColors.neutralGrey,
          tooltip: 'Reportes',
          onPressed: () => context.push(AppRouter.reportes),
        ),
        IconButton(
          icon:  const Icon(Icons.person_outline_rounded),
          color: AppColors.neutralGrey,
          onPressed: () => context.push(AppRouter.perfil),
        ),
        IconButton(
          icon:  const Icon(Icons.logout_rounded),
          color: AppColors.neutralGrey,
          onPressed: () => _onLogout(context),
        ),
      ],
    );
  }

  Widget _buildFAB(BuildContext context)
  {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag:         'fab_institucion',
          mini:            true,
          backgroundColor: AppColors.headingDark,
          foregroundColor: AppColors.baseSurface,
          tooltip:         'Agregar institucion',
          onPressed: () => context.push(
            AppRouter.agregarInstitucion,
            extra: {'esOnboarding': false},
          ),
          child: const Icon(Icons.add_business_rounded),
        ),
        const SizedBox(height: AppSizes.paddingS),
        FloatingActionButton.extended(
          heroTag:         'fab_grupo',
          backgroundColor: AppColors.primaryCoral,
          foregroundColor: AppColors.baseSurface,
          icon:            const Icon(Icons.group_add_rounded),
          label:           const Text('Nuevo grupo'),
          onPressed: ()
          {
            final state = context.read<HomeDocenteBloc>().state;
            if (state is! HomeDocenteLoaded || state.institucionActiva == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:         Text('Selecciona una institucion primero'),
                  backgroundColor: AppColors.darkSlate,
                ),
              );
              return;
            }
            context.push(
              AppRouter.agregarGrupo,
              extra: {
                'institucionId':     state.institucionActiva!.id,
                'nombreInstitucion': state.institucionActiva!.nombre,
              },
            );
          },
        ),
      ],
    );
  }

  void _onLogout(BuildContext context)
  {
    context.read<AuthBloc>().add(const AuthLogoutRequested());
    context.go(AppRouter.login);
  }

  Widget _buildBodyContent(BuildContext context, HomeDocenteState state)
  {
    if (state is HomeDocenteLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryCoral),
      );
    }

    if (state is HomeDocenteError) {
      return Center(child: Text(state.mensaje));
    }

    if (state is HomeDocenteLoaded) {
      return _buildBody(context, state);
    }

    return const SizedBox.shrink();
  }

  Widget _buildBody(BuildContext context, HomeDocenteLoaded state)
  {
    return RefreshIndicator(
      color:     AppColors.primaryCoral,
      onRefresh: () async
      {
        context.read<HomeDocenteBloc>().add(
          const HomeDocenteStarted(docenteId: 1),
        );
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.paddingM,
          AppSizes.paddingM,
          AppSizes.paddingM,
          AppSizes.paddingXL + AppSizes.heightButton + 60,
        ),
        children: [
          _buildInstitucionesSection(context, state),
          const SizedBox(height: AppSizes.paddingL),
          if (state.sesionActiva != null && state.claveActiva != null) ...[
            _buildSesionActivaSection(context, state),
            const SizedBox(height: AppSizes.paddingL),
          ],
          _buildGruposSection(context, state),
        ],
      ),
    );
  }

  Widget _buildInstitucionesSection(BuildContext context, HomeDocenteLoaded state)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mis instituciones',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: AppSizes.fontTitle,
          ),
        ),
        const SizedBox(height: AppSizes.paddingM),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: state.instituciones.map((inst) {
              return Padding(
                padding: const EdgeInsets.only(right: AppSizes.paddingS),
                child: InstitucionChipWidget(
                  institucion: inst,
                  isSelected:  state.institucionActiva?.id == inst.id,
                  onTap: () => context.read<HomeDocenteBloc>().add(
                    InstitucionSeleccionada(institucionId: inst.id),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSesionActivaSection(BuildContext context, HomeDocenteLoaded state)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sesion en curso',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: AppSizes.fontTitle,
          ),
        ),
        const SizedBox(height: AppSizes.paddingM),
        SesionActivaCardWidget(
          sesion:   state.sesionActiva!,
          clave:    state.claveActiva!,
          onCerrar: () => _onCerrarSesion(context, state.sesionActiva!.id),
        ),
      ],
    );
  }

  Widget _buildGruposSection(BuildContext context, HomeDocenteLoaded state)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mis grupos',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: AppSizes.fontTitle,
          ),
        ),
        const SizedBox(height: AppSizes.paddingM),
        if (state.grupos.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingXL),
              child: Text(
                'No tienes grupos en esta institucion',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutralGrey,
                ),
              ),
            ),
          )
        else
          ...state.grupos.map((grupo) => GrupoCardWidget(
            grupo:          grupo,
            sesionActiva:   state.sesionActiva?.grupoId == grupo.id,
            onAbrirSesion:  () => context.read<HomeDocenteBloc>().add(
              SesionAbierta(grupoId: grupo.id),
            ),
            onCerrarSesion: () => _onCerrarSesion(
              context,
              state.sesionActiva!.id,
            ),
          )),
      ],
    );
  }

  Future<void> _onCerrarSesion(BuildContext context, int sesionId) async
  {
    final confirmar = await CerrarSesionDialog.show(context);
    if (confirmar == true && context.mounted) {
      context.read<HomeDocenteBloc>().add(SesionCerrada(sesionId: sesionId));
    }
  }
}