// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : unirse_materia_screen.dart
// Created on : 24/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] Pantalla para unirse a materia por codigo
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class UnirseMateriaScreem extends StatefulWidget
{
  const UnirseMateriaScreem({super.key});

  @override
  State<UnirseMateriaScreem> createState() => _UnirseMateriaScreemState();
}

class _UnirseMateriaScreemState extends State<UnirseMateriaScreem>
{
  final _formKey          = GlobalKey<FormState>();
  final _codigoController = TextEditingController();
  bool  _cargando         = false;

  @override
  void dispose()
  {
    _codigoController.dispose();
    super.dispose();
  }

  Future<void> _onUnirsePressed() async
  {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    setState(() => _cargando = false);

    final codigo = _codigoController.text.trim().toUpperCase();

    if (codigo == 'MAT-001' || codigo == 'POO-002' || codigo == 'BD-003') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:         Text('Te uniste a la materia correctamente'),
          backgroundColor: AppColors.successGreen,
        ),
      );
      _codigoController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:         Text('Codigo invalido o grupo no encontrado'),
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
        title: const Text('Unirse a materia'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.paddingM),
                _buildHeader(context),
                const SizedBox(height: AppSizes.paddingXL),
                _buildCodigoSection(context),
                const SizedBox(height: AppSizes.paddingXL),
                _buildBotonUnirse(context),
                const SizedBox(height: AppSizes.paddingL),
                _buildInfoCodigos(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color:        AppColors.cloudBlue,
            borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          ),
          child: const Icon(
            Icons.group_add_rounded,
            size:  AppSizes.iconL,
            color: AppColors.deepNavy,
          ),
        ),
        const SizedBox(height: AppSizes.paddingM),
        Text(
          'Ingresa el codigo de tu grupo',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSizes.paddingS),
        Text(
          'Tu docente te proporcionara el codigo unico para unirte a la materia.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.neutralGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildCodigoSection(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Codigo de grupo',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color:      AppColors.deepNavy,
          ),
        ),
        const SizedBox(height: AppSizes.paddingM),
        TextFormField(
          controller:         _codigoController,
          textAlign:          TextAlign.center,
          textCapitalization: TextCapitalization.characters,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            letterSpacing: 6,
            color:         AppColors.deepNavy,
          ),
          decoration: const InputDecoration(
            hintText:   'Ej. MAT-001',
            prefixIcon: Icon(Icons.vpn_key_outlined),
          ),
          validator: (value)
          {
            if (value == null || value.trim().isEmpty) {
              return 'Ingresa el codigo de tu grupo';
            }
            if (value.trim().length < 3) {
              return 'El codigo debe tener al menos 3 caracteres';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBotonUnirse(BuildContext context)
  {
    return SizedBox(
      width:  double.infinity,
      height: AppSizes.heightButton,
      child: ElevatedButton.icon(
        onPressed: _cargando ? null : _onUnirsePressed,
        icon: _cargando
            ? const SizedBox(
          width:  18,
          height: 18,
          child:  CircularProgressIndicator(
            strokeWidth: 2,
            color:       AppColors.baseSurface,
          ),
        )
            : const Icon(Icons.check_rounded),
        label: Text(_cargando ? 'Verificando...' : 'Unirme al grupo'),
      ),
    );
  }

  Widget _buildInfoCodigos(BuildContext context)
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
                Icons.info_outline_rounded,
                size:  AppSizes.iconS,
                color: AppColors.deepNavy,
              ),
              const SizedBox(width: AppSizes.paddingS),
              Text(
                'Codigos de prueba disponibles',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:      AppColors.deepNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingS),
          _CodigoInfoWidget(codigo: 'MAT-001', materia: 'Matematicas Discretas'),
          _CodigoInfoWidget(codigo: 'POO-002', materia: 'Programacion Orientada a Objetos'),
          _CodigoInfoWidget(codigo: 'BD-003',  materia: 'Bases de Datos'),
        ],
      ),
    );
  }
}

class _CodigoInfoWidget extends StatelessWidget
{
  final String codigo;
  final String materia;

  const _CodigoInfoWidget({required this.codigo, required this.materia});

  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.paddingXS),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingS,
              vertical:   AppSizes.paddingXS,
            ),
            decoration: BoxDecoration(
              color:        AppColors.baseSurface,
              borderRadius: BorderRadius.circular(AppSizes.radiusInput),
            ),
            child: Text(
              codigo,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color:      AppColors.deepNavy,
                fontSize:   AppSizes.fontCaption,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.paddingS),
          Expanded(
            child: Text(
              materia,
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
}