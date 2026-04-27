// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : register_screen.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martínez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Pantalla de registro de nuevo usuario
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

class RegisterScreen extends StatefulWidget
{
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
{
  final _formKey              = GlobalKey<FormState>();
  final _nombreController     = TextEditingController();
  final _apPatController      = TextEditingController();
  final _apMatController      = TextEditingController();
  final _emailController      = TextEditingController();
  final _passwordController   = TextEditingController();
  final _confirmController    = TextEditingController();
  bool  _obscurePassword      = true;
  bool  _obscureConfirm       = true;
  int   _rolSeleccionado      = 2;

  @override
  void dispose()
  {
    _nombreController.dispose();
    _apPatController.dispose();
    _apMatController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onRegisterPressed(BuildContext context)
  {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        RegisterSubmitted(
          nombre:   _nombreController.text.trim(),
          apPat:    _apPatController.text.trim(),
          apMat:    _apMatController.text.trim(),
          email:    _emailController.text.trim(),
          password: _passwordController.text.trim(),
          rol:      _rolSeleccionado,
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
            context.go(AppRouter.homeDocente);
          } else {
            context.go(AppRouter.homeAlumno);
          }
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.mensaje),
              backgroundColor: AppColors.darkSlate,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
          title: const Text('Crear cuenta'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSizes.paddingL),
                  _buildSectionTitle('Tipo de cuenta'),
                  const SizedBox(height: AppSizes.paddingM),
                  _buildRolSelector(),
                  const SizedBox(height: AppSizes.paddingL),
                  _buildSectionTitle('Datos personales'),
                  const SizedBox(height: AppSizes.paddingM),
                  _buildNombreField(),
                  const SizedBox(height: AppSizes.paddingM),
                  _buildApPatField(),
                  const SizedBox(height: AppSizes.paddingM),
                  _buildApMatField(),
                  const SizedBox(height: AppSizes.paddingL),
                  _buildSectionTitle('Acceso'),
                  const SizedBox(height: AppSizes.paddingM),
                  _buildEmailField(),
                  const SizedBox(height: AppSizes.paddingM),
                  _buildPasswordField(),
                  const SizedBox(height: AppSizes.paddingM),
                  _buildConfirmPasswordField(),
                  const SizedBox(height: AppSizes.paddingXL),
                  _buildRegisterButton(context),
                  const SizedBox(height: AppSizes.paddingM),
                  _buildLoginLink(context),
                  const SizedBox(height: AppSizes.paddingXL),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title)
  {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontSize: AppSizes.fontTitle,
        color: AppColors.deepNavy,
      ),
    );
  }

  Widget _buildRolSelector()
  {
    return Row(
      children: [
        Expanded(
          child: _RolCardWidget(
            label: 'Alumno',
            icon: Icons.school_rounded,
            isSelected: _rolSeleccionado == 2,
            onTap: () => setState(() => _rolSeleccionado = 2),
          ),
        ),
        const SizedBox(width: AppSizes.paddingM),
        Expanded(
          child: _RolCardWidget(
            label: 'Docente',
            icon: Icons.person_rounded,
            isSelected: _rolSeleccionado == 1,
            onTap: () => setState(() => _rolSeleccionado = 1),
          ),
        ),
      ],
    );
  }

  Widget _buildNombreField()
  {
    return TextFormField(
      controller: _nombreController,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Nombre(s)',
        prefixIcon: Icon(Icons.badge_outlined),
      ),
      validator: (value)
      {
        if (value == null || value.trim().isEmpty) {
          return 'Ingresa tu nombre';
        }
        return null;
      },
    );
  }

  Widget _buildApPatField()
  {
    return TextFormField(
      controller: _apPatController,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Apellido paterno',
        prefixIcon: Icon(Icons.badge_outlined),
      ),
      validator: (value)
      {
        if (value == null || value.trim().isEmpty) {
          return 'Ingresa tu apellido paterno';
        }
        return null;
      },
    );
  }

  Widget _buildApMatField()
  {
    return TextFormField(
      controller: _apMatController,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Apellido materno',
        prefixIcon: Icon(Icons.badge_outlined),
      ),
      validator: (value)
      {
        if (value == null || value.trim().isEmpty) {
          return 'Ingresa tu apellido materno';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField()
  {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Correo electronico',
        hintText: 'ejemplo@correo.com',
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
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Contrasena',
        hintText: 'Minimo 6 caracteres',
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
          return 'Ingresa una contrasena';
        }
        if (value.trim().length < 6) {
          return 'La contrasena debe tener al menos 6 caracteres';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField()
  {
    return TextFormField(
      controller: _confirmController,
      obscureText: _obscureConfirm,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _onRegisterPressed(context),
      decoration: InputDecoration(
        labelText: 'Confirmar contrasena',
        hintText: 'Repite tu contrasena',
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirm
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
        ),
      ),
      validator: (value)
      {
        if (value == null || value.trim().isEmpty) {
          return 'Confirma tu contrasena';
        }
        if (value.trim() != _passwordController.text.trim()) {
          return 'Las contrasenas no coinciden';
        }
        return null;
      },
    );
  }

  Widget _buildRegisterButton(BuildContext context)
  {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state)
      {
        final isLoading = state is AuthLoading;

        return ElevatedButton(
          onPressed: isLoading ? null : () => _onRegisterPressed(context),
          child: isLoading
              ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.baseSurface,
            ),
          )
              : const Text('Crear cuenta'),
        );
      },
    );
  }

  Widget _buildLoginLink(BuildContext context)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Ya tienes cuenta?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.neutralGrey,
          ),
        ),
        TextButton(
          onPressed: () => context.pop(),
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingS,
              vertical: AppSizes.paddingXS,
            ),
          ),
          child: Text(
            'Inicia sesion',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.primaryCoral,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _RolCardWidget extends StatelessWidget
{
  final String  label;
  final IconData icon;
  final bool    isSelected;
  final VoidCallback onTap;

  const _RolCardWidget({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.paddingM,
          horizontal: AppSizes.paddingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.subtleWarm : AppColors.baseSurface,
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          border: Border.all(
            color: isSelected ? AppColors.primaryCoral : AppColors.borderSky,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: AppSizes.iconL,
              color: isSelected ? AppColors.primaryCoral : AppColors.neutralGrey,
            ),
            const SizedBox(height: AppSizes.paddingS),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? AppColors.primaryCoral : AppColors.neutralGrey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}