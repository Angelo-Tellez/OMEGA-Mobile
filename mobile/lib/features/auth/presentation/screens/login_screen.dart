// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : login_screen.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [002] 28/04/2026 - Jorge Alejandro Martinez Toris - Pantalla de inicio de sesion
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/config/app_router.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/bloc/auth_event.dart';
import '../../../auth/bloc/auth_state.dart';

class LoginScreen extends StatefulWidget
{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{
  final _formKey            = GlobalKey<FormState>();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool  _obscurePassword    = true;

  @override
  void dispose()
  {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context)
  {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginSubmitted(
          email:    _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state)
      {
        if (state is AuthSuccess) {
          if (state.usuario.isDocente) {
            final tieneInstituciones =
                state.usuario.email != 'docente.nuevo@test.com';

            if (tieneInstituciones) {
              context.go(AppRouter.homeDocente);
            } else {
              context.go(AppRouter.bienvenidaDocente);
            }
          } else {
            context.go(AppRouter.homeAlumno);
          }
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:         Text(state.mensaje),
              backgroundColor: AppColors.darkSlate,
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppSizes.paddingXL),
                    _buildHeader(),
                    const SizedBox(height: AppSizes.paddingXL),
                    _buildEmailField(),
                    const SizedBox(height: AppSizes.paddingM),
                    _buildPasswordField(),
                    const SizedBox(height: AppSizes.paddingS),
                    _buildForgotPassword(context),
                    const SizedBox(height: AppSizes.paddingL),
                    _buildLoginButton(context),
                    const SizedBox(height: AppSizes.paddingM),
                    _buildRegisterLink(context),
                    const SizedBox(height: AppSizes.paddingL),
                    _buildCuentasPrueba(context),
                    const SizedBox(height: AppSizes.paddingXL),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader()
  {
    return Column(
      children: [
        Container(
          width:  72,
          height: 72,
          decoration: BoxDecoration(
            color:        AppColors.primaryCoral,
            borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          ),
          child: const Icon(
            Icons.fact_check_rounded,
            size:  AppSizes.iconL,
            color: AppColors.baseSurface,
          ),
        ),
        const SizedBox(height: AppSizes.paddingM),
        Builder(
          builder: (context) => Text(
            'ATN Asistencias',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        const SizedBox(height: AppSizes.paddingS),
        Builder(
          builder: (context) => Text(
            'Inicia sesion para continuar',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.neutralGrey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField()
  {
    return TextFormField(
      controller:      _emailController,
      keyboardType:    TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText:  'Correo electronico',
        hintText:   'ejemplo@correo.com',
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: (value)
      {
        if (value == null || value.trim().isEmpty) {
          return 'Ingresa tu correo electronico';
        }
        if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
          return 'Ingresa un correo valido';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField()
  {
    return TextFormField(
      controller:      _passwordController,
      obscureText:     _obscurePassword,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _onLoginPressed(context),
      decoration: InputDecoration(
        labelText:  'Contrasena',
        hintText:   '••••••••',
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (value)
      {
        if (value == null || value.trim().isEmpty) {
          return 'Ingresa tu contrasena';
        }
        if (value.trim().length < 6) {
          return 'La contrasena debe tener al menos 6 caracteres';
        }
        return null;
      },
    );
  }

  Widget _buildForgotPassword(BuildContext context)
  {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => context.push(AppRouter.recuperarPassword),
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingS,
            vertical:   AppSizes.paddingXS,
          ),
        ),
        child: Text(
          'Olvide mi contrasena',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color:      AppColors.headingDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context)
  {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state)
      {
        final isLoading = state is AuthLoading;

        return ElevatedButton(
          onPressed: isLoading ? null : () => _onLoginPressed(context),
          child: isLoading
              ? const SizedBox(
            height: 22,
            width:  22,
            child:  CircularProgressIndicator(
              strokeWidth: 2.5,
              color:       AppColors.baseSurface,
            ),
          )
              : const Text('Iniciar sesion'),
        );
      },
    );
  }

  Widget _buildRegisterLink(BuildContext context)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'No tienes cuenta?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.neutralGrey,
          ),
        ),
        TextButton(
          onPressed: () => context.push(AppRouter.register),
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingS,
              vertical:   AppSizes.paddingXS,
            ),
          ),
          child: Text(
            'Registrate',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color:      AppColors.primaryCoral,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCuentasPrueba(BuildContext context)
  {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color:        AppColors.cloudBlue,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bug_report_outlined,
                size:  AppSizes.iconS,
                color: AppColors.deepNavy,
              ),
              const SizedBox(width: AppSizes.paddingXS),
              Text(
                'Cuentas de prueba',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:      AppColors.deepNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingS),
          _buildCuentaItem(context, 'Docente con instituciones', 'docente@test.com'),
          _buildCuentaItem(context, 'Docente nuevo sin instituciones', 'docente.nuevo@test.com'),
          _buildCuentaItem(context, 'Alumno', 'alumno@test.com'),
          const SizedBox(height: AppSizes.paddingXS),
          Text(
            'Contrasena para todas: 123456',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color:    AppColors.deepNavy,
              fontSize: AppSizes.fontCaption,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCuentaItem(BuildContext context, String label, String email)
  {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingXS),
      child: GestureDetector(
        onTap: ()
        {
          _emailController.text    = email;
          _passwordController.text = '123456';
        },
        child: Row(
          children: [
            const Icon(
              Icons.touch_app_outlined,
              size:  12,
              color: AppColors.headingDark,
            ),
            const SizedBox(width: AppSizes.paddingXS),
            Expanded(
              child: Text(
                '$label — $email',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:    AppColors.headingDark,
                  fontSize: AppSizes.fontCaption,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}