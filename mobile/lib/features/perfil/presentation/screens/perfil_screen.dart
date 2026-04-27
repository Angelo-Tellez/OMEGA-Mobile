// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : perfil_screen.dart
// Created on : 24/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [002] 24/04/2026 - Jorge Alejandro Martinez Toris - Integración con paypal
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
import '../../../../features/auth/data/usuario_model.dart';

class PerfilScreen extends StatelessWidget
{
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context)
  {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state)
      {
        if (state is! AuthSuccess) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon:      const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => context.pop(),
            ),
            title: const Text('Mi perfil'),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              children: [
                _buildAvatarSection(context, state.usuario),
                const SizedBox(height: AppSizes.paddingL),
                _buildInfoSection(context, state.usuario),
                const SizedBox(height: AppSizes.paddingL),
                _buildRolSection(context, state.usuario),
                if (state.usuario.isDocente) ...[
                  const SizedBox(height: AppSizes.paddingL),
                  _buildSuscripcionSection(context),
                ],
                const SizedBox(height: AppSizes.paddingXL),
                _buildLogoutButton(context),
                const SizedBox(height: AppSizes.paddingL),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatarSection(BuildContext context, UsuarioModel usuario)
  {
    final iniciales =
    '${usuario.nombre[0]}${usuario.apPat[0]}'.toUpperCase();

    return Center(
      child: Column(
        children: [
          Container(
            width:  88,
            height: 88,
            decoration: const BoxDecoration(
              color: AppColors.primaryCoral,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                iniciales,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize:   AppSizes.fontH1,
                  color:      AppColors.baseSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),
          Text(
            '${usuario.nombre} ${usuario.apPat} ${usuario.apMat}',
            style:     Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.paddingXS),
          Text(
            usuario.email,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.neutralGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, UsuarioModel usuario)
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
          Text(
            'Datos personales',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color:      AppColors.deepNavy,
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),
          _InfoRowWidget(icon: Icons.badge_outlined,  label: 'Nombre',           valor: usuario.nombre),
          const Divider(color: AppColors.surface, height: AppSizes.paddingL),
          _InfoRowWidget(icon: Icons.badge_outlined,  label: 'Apellido paterno',  valor: usuario.apPat),
          const Divider(color: AppColors.surface, height: AppSizes.paddingL),
          _InfoRowWidget(icon: Icons.badge_outlined,  label: 'Apellido materno',  valor: usuario.apMat),
          const Divider(color: AppColors.surface, height: AppSizes.paddingL),
          _InfoRowWidget(icon: Icons.email_outlined,  label: 'Correo electronico', valor: usuario.email),
        ],
      ),
    );
  }

  Widget _buildRolSection(BuildContext context, UsuarioModel usuario)
  {
    final esDocente = usuario.isDocente;

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
            padding: const EdgeInsets.all(AppSizes.paddingS),
            decoration: BoxDecoration(
              color:        AppColors.cloudBlue,
              borderRadius: BorderRadius.circular(AppSizes.radiusInput),
            ),
            child: Icon(
              esDocente ? Icons.person_rounded : Icons.school_rounded,
              color: AppColors.deepNavy,
              size:  AppSizes.iconM,
            ),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tipo de cuenta',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutralGrey,
                ),
              ),
              Text(
                esDocente ? 'Docente' : 'Alumno',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:      AppColors.deepNavy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuscripcionSection(BuildContext context)
  {
    // Mock — cuando exista backend esto vendra del estado real del usuario
    const planNombre  = 'Plan Basico';
    const _    = true;

    return GestureDetector(
      onTap: () => context.push(AppRouter.suscripcion),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color:AppColors.cloudBlue,
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          border: Border.all(
            color: AppColors.headingDark,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingS),
              decoration: BoxDecoration(
                color: AppColors.headingDark,
                borderRadius: BorderRadius.circular(AppSizes.radiusInput),
              ),
              child: const Icon(
                Icons.workspace_premium_rounded,
                color: AppColors.baseSurface,
                size:  AppSizes.iconM,
              ),
            ),
            const SizedBox(width: AppSizes.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planNombre,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color:      AppColors.deepNavy,
                    ),
                  ),
                  Text(
                    'Toca para mejorar tu plan',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.neutralGrey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.headingDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context)
  {
    return SizedBox(
      width:  double.infinity,
      height: AppSizes.heightButton,
      child:  OutlinedButton.icon(
        onPressed: ()
        {
          context.read<AuthBloc>().add(const AuthLogoutRequested());
          context.go(AppRouter.login);
        },
        icon:  const Icon(Icons.logout_rounded, color: AppColors.actionRed),
        label: const Text('Cerrar sesion'),
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
}

class _InfoRowWidget extends StatelessWidget
{
  final IconData icon;
  final String   label;
  final String   valor;

  const _InfoRowWidget({
    required this.icon,
    required this.label,
    required this.valor,
  });

  @override
  Widget build(BuildContext context)
  {
    return Row(
      children: [
        Icon(icon, size: AppSizes.iconS, color: AppColors.headingDark),
        const SizedBox(width: AppSizes.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:    AppColors.neutralGrey,
                  fontSize: AppSizes.fontCaption,
                ),
              ),
              Text(
                valor,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:      AppColors.deepNavy,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}