// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : bienvenida_docente_screen.dart
// Created on : 28/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 28/04/2026 - Jorge Alejandro Martinez Toris - Pantalla de bienvenida para docente sin instituciones
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/config/app_router.dart';
import '../../../../features/auth/bloc/auth_state.dart';
import '../../../../features/auth/bloc/auth_bloc.dart';
import '../../../../features/auth/bloc/auth_event.dart';

class BienvenidaDocenteScreen extends StatelessWidget
{
  const BienvenidaDocenteScreen({super.key});

  @override
  Widget build(BuildContext context)
  {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState)
      {
        final nombre = authState is AuthSuccess
            ? authState.usuario.nombre
            : 'Docente';

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  _buildIlustracion(context),
                  const SizedBox(height: AppSizes.paddingXL),
                  _buildTextos(context, nombre),
                  const SizedBox(height: AppSizes.paddingXL),
                  _buildPasos(context),
                  const Spacer(),
                  _buildBoton(context),
                  const SizedBox(height: AppSizes.paddingM),
                  _buildLogout(context),
                  const SizedBox(height: AppSizes.paddingM),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIlustracion(BuildContext context)
  {
    return Container(
      width:  120,
      height: 120,
      decoration: BoxDecoration(
        color:        AppColors.subtleWarm,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard * 2),
        border:       Border.all(color: AppColors.primaryCoral, width: 2),
      ),
      child: const Icon(
        Icons.account_balance_rounded,
        size:  64,
        color: AppColors.primaryCoral,
      ),
    );
  }

  Widget _buildTextos(BuildContext context, String nombre)
  {
    return Column(
      children: [
        Text(
          'Bienvenido, $nombre',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize:  AppSizes.fontH1,
            color:     AppColors.deepNavy,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.paddingM),
        Text(
          'Para comenzar necesitas configurar al menos una institucion. Esto te permitira gestionar tus grupos y sesiones de asistencia.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.neutralGrey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPasos(BuildContext context)
  {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color:        AppColors.cloudBlue,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
      ),
      child: Column(
        children: [
          _buildPasoItem(
            context,
            numero: '1',
            titulo: 'Agrega tu institucion',
            texto:  'Registra el nombre y logo de tu escuela o universidad.',
            color:  AppColors.primaryCoral,
          ),
          const SizedBox(height: AppSizes.paddingM),
          _buildPasoItem(
            context,
            numero: '2',
            titulo: 'Configura los rubros',
            texto:  'Define los porcentajes de asistencia para Ordinario, Extraordinario, etc.',
            color:  AppColors.headingDark,
          ),
          const SizedBox(height: AppSizes.paddingM),
          _buildPasoItem(
            context,
            numero: '3',
            titulo: 'Crea tus grupos',
            texto:  'Agrega las materias y comparte el codigo con tus alumnos.',
            color:  AppColors.successGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildPasoItem(
      BuildContext context, {
        required String numero,
        required String titulo,
        required String texto,
        required Color  color,
      })
  {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width:  32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              numero,
              style: const TextStyle(
                color:      AppColors.baseSurface,
                fontWeight: FontWeight.w700,
                fontSize:   AppSizes.fontBody,
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
                titulo,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:      AppColors.deepNavy,
                ),
              ),
              Text(
                texto,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:    AppColors.deepNavy,
                  fontSize: AppSizes.fontCaption,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBoton(BuildContext context)
  {
    return SizedBox(
      width:  double.infinity,
      height: AppSizes.heightButton,
      child:  ElevatedButton.icon(
        onPressed: () => context.push(
          AppRouter.agregarInstitucion,
          extra: {'esOnboarding': true},
        ),
        icon:  const Icon(Icons.add_rounded),
        label: const Text('Agregar mi primera institucion'),
      ),
    );
  }

  Widget _buildLogout(BuildContext context)
  {
    return TextButton(
      onPressed: ()
      {
        context.read<AuthBloc>().add(const AuthLogoutRequested());
        context.go(AppRouter.login);
      },
      child: Text(
        'Cerrar sesion',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.neutralGrey,
        ),
      ),
    );
  }
}