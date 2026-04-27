// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : recuperar_password_screen.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Pantalla de recuperacion de contrasena
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class RecuperarPasswordScreen extends StatefulWidget
{
  const RecuperarPasswordScreen({super.key});

  @override
  State<RecuperarPasswordScreen> createState() => _RecuperarPasswordScreenState();
}

class _RecuperarPasswordScreenState extends State<RecuperarPasswordScreen>
{
  final _formKey        = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool  _cargando       = false;
  bool  _enviado        = false;

  @override
  void dispose()
  {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onEnviarPressed() async
  {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    setState(()
    {
      _cargando = false;
      _enviado  = true;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:      const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Recuperar contrasena'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            child: _enviado
                ? _buildConfirmacion(context)
                : _buildFormulario(context),
          ),
        ),
      ),
    );
  }

  Widget _buildFormulario(BuildContext context)
  {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeader(context),
          const SizedBox(height: AppSizes.paddingXL),
          _buildEmailField(),
          const SizedBox(height: AppSizes.paddingL),
          _buildBotonEnviar(context),
          const SizedBox(height: AppSizes.paddingM),
          _buildRegresarLogin(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context)
  {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          decoration: BoxDecoration(
            color:        AppColors.cloudBlue,
            borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          ),
          child: const Icon(
            Icons.lock_reset_rounded,
            size:  AppSizes.iconL,
            color: AppColors.deepNavy,
          ),
        ),
        const SizedBox(height: AppSizes.paddingM),
        Text(
          'Olvidaste tu contrasena?',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.paddingS),
        Text(
          'Ingresa tu correo electronico y te enviaremos un enlace para restablecer tu contrasena.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.neutralGrey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField()
  {
    return TextFormField(
      controller:      _emailController,
      keyboardType:    TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _onEnviarPressed(),
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

  Widget _buildBotonEnviar(BuildContext context)
  {
    return SizedBox(
      width:  double.infinity,
      height: AppSizes.heightButton,
      child:  ElevatedButton(
        onPressed: _cargando ? null : _onEnviarPressed,
        child: _cargando
            ? const SizedBox(
          height: 22,
          width:  22,
          child:  CircularProgressIndicator(
            strokeWidth: 2.5,
            color:       AppColors.baseSurface,
          ),
        )
            : const Text('Enviar enlace'),
      ),
    );
  }

  Widget _buildRegresarLogin(BuildContext context)
  {
    return TextButton.icon(
      onPressed: () => context.pop(),
      icon:  const Icon(
        Icons.arrow_back_rounded,
        size:  AppSizes.iconS,
        color: AppColors.headingDark,
      ),
      label: Text(
        'Regresar al inicio de sesion',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color:      AppColors.headingDark,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildConfirmacion(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          decoration: BoxDecoration(
            color:        AppColors.successGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusCard),
            border:       Border.all(color: AppColors.successGreen),
          ),
          child: const Icon(
            Icons.mark_email_read_rounded,
            size:  64,
            color: AppColors.successGreen,
          ),
        ),
        const SizedBox(height: AppSizes.paddingL),
        Text(
          'Correo enviado',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.paddingM),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.neutralGrey,
            ),
            children: [
              const TextSpan(text: 'Enviamos un enlace de recuperacion a '),
              TextSpan(
                text: _emailController.text.trim(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color:      AppColors.deepNavy,
                ),
              ),
              const TextSpan(
                text: '. Revisa tu bandeja de entrada y sigue las instrucciones.',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.paddingL),
        Container(
          width:   double.infinity,
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color:        AppColors.cloudBlue,
            borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          ),
          child: Column(
            children: [
              _buildPasoInfo(
                context,
                icon:   Icons.email_outlined,
                titulo: 'Revisa tu correo',
                texto:  'Abre el correo que te enviamos desde ATN Asistencias.',
              ),
              const SizedBox(height: AppSizes.paddingM),
              _buildPasoInfo(
                context,
                icon:   Icons.link_rounded,
                titulo: 'Abre el enlace',
                texto:  'Haz clic en el enlace de recuperacion antes de que expire.',
              ),
              const SizedBox(height: AppSizes.paddingM),
              _buildPasoInfo(
                context,
                icon:   Icons.lock_open_rounded,
                titulo: 'Crea tu nueva contrasena',
                texto:  'Elige una contrasena segura de al menos 6 caracteres.',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.paddingL),
        SizedBox(
          width:  double.infinity,
          height: AppSizes.heightButton,
          child:  ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Regresar al inicio de sesion'),
          ),
        ),
        const SizedBox(height: AppSizes.paddingM),
        TextButton(
          onPressed: ()
          {
            setState(()
            {
              _enviado = false;
              _emailController.clear();
            });
          },
          child: Text(
            'Usar otro correo',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color:      AppColors.headingDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasoInfo(
      BuildContext context, {
        required IconData icon,
        required String   titulo,
        required String   texto,
      })
  {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingXS),
          decoration: BoxDecoration(
            color:        AppColors.baseSurface,
            borderRadius: BorderRadius.circular(AppSizes.radiusInput),
          ),
          child: Icon(icon, size: AppSizes.iconS, color: AppColors.deepNavy),
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
                  color: AppColors.deepNavy,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}