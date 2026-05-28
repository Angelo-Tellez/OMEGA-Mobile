// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : unirse_materia_screen.dart
// Created on : 24/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 24/04/2026 - Dev - Pantalla para unirse a materia por codigo
//   [002] 08/05/2026 - Jorge Alejandro Martinez Toris - Conexion backend real
//   [003] 28/05/2026 - Jorge Alejandro Martinez Toris - Volver al home automaticamente al unirse
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/connection/api_client.dart';
import '../../../../core/constants/api_routes.dart';
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

    try {
      final codigo   = _codigoController.text.trim().toUpperCase();
      final response = await ApiClient.instance.post(
        ApiRoutes.alumnoUnirse,
        data: {'codigo': codigo},
      );

      if (!mounted) return;
      setState(() => _cargando = false);

      final grupo = response.data['data'];
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:         Text('¡Te uniste a ${grupo['materia']} correctamente!'),
          backgroundColor: AppColors.successGreen,
        ),
      );
      // Regresar al home para que se vea la nueva materia
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _cargando = false);
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
            hintText:   'Ej. MOV-001-A',
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
}