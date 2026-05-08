// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : agregar_grupo_screen.dart
// Created on : 24/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] Pantalla para agregar nuevo grupo
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/connection/api_client.dart';
import '../../../../core/constants/api_routes.dart';

class AgregarGrupoScreen extends StatefulWidget
{
  final int    institucionId;
  final String nombreInstitucion;

  const AgregarGrupoScreen({
    super.key,
    required this.institucionId,
    required this.nombreInstitucion,
  });

  @override
  State<AgregarGrupoScreen> createState() => _AgregarGrupoScreenState();
}

class _AgregarGrupoScreenState extends State<AgregarGrupoScreen>
{
  final _formKey           = GlobalKey<FormState>();
  final _nombreController  = TextEditingController();
  final _materiaController = TextEditingController();
  final _periodoController = TextEditingController();
  final _salonController   = TextEditingController();
  final _horarioController = TextEditingController();
  bool  _cargando          = false;

  @override
  void dispose()
  {
    _nombreController.dispose();
    _materiaController.dispose();
    _periodoController.dispose();
    _salonController.dispose();
    _horarioController.dispose();
    super.dispose();
  }

  Future<void> _onGuardarPressed() async
  {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    try {
      await ApiClient.instance.post(
        ApiRoutes.grupos(widget.institucionId),
        data: {
          'nombre':   _nombreController.text.trim(),
          'materia':  _materiaController.text.trim(),
          'periodo':  _periodoController.text.trim(),
        },
      );

      if (!mounted) return;
      setState(() => _cargando = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:         Text('Grupo creado correctamente'),
          backgroundColor: AppColors.successGreen,
        ),
      );

      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:         Text('Error al crear el grupo'),
          backgroundColor: AppColors.actionRed,
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
        title: const Text('Nuevo grupo'),
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
                _buildSeccionTitulo('Informacion del grupo'),
                const SizedBox(height: AppSizes.paddingM),
                _buildNombreField(),
                const SizedBox(height: AppSizes.paddingM),
                _buildMateriaField(),
                const SizedBox(height: AppSizes.paddingM),
                _buildPeriodoField(),
                const SizedBox(height: AppSizes.paddingXL),
                _buildSeccionTitulo('Ubicacion y horario'),
                const SizedBox(height: AppSizes.paddingM),
                _buildSalonField(),
                const SizedBox(height: AppSizes.paddingM),
                _buildHorarioField(),
                const SizedBox(height: AppSizes.paddingXL),
                _buildCodigoInfo(context),
                const SizedBox(height: AppSizes.paddingXL),
                _buildBotonGuardar(),
                const SizedBox(height: AppSizes.paddingL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context)
  {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color:        AppColors.subtleWarm,
            borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          ),
          child: const Icon(
            Icons.groups_rounded,
            size:  AppSizes.iconL,
            color: AppColors.primaryCoral,
          ),
        ),
        const SizedBox(width: AppSizes.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Crear nuevo grupo',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'Se generara un codigo unico para que los alumnos se unan.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutralGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionTitulo(String titulo)
  {
    return Text(
      titulo,
      style: const TextStyle(
        fontSize:   AppSizes.fontTitle,
        fontWeight: FontWeight.w600,
        color:      AppColors.deepNavy,
      ),
    );
  }

  Widget _buildNombreField()
  {
    return TextFormField(
      controller:         _nombreController,
      textCapitalization: TextCapitalization.words,
      textInputAction:    TextInputAction.next,
      decoration: const InputDecoration(
        labelText:  'Nombre del grupo',
        hintText:   'Ej. Grupo A',
        prefixIcon: Icon(Icons.groups_rounded),
      ),
      validator: (value)
      {
        if (value == null || value.trim().isEmpty) {
          return 'Ingresa el nombre del grupo';
        }
        return null;
      },
    );
  }

  Widget _buildMateriaField()
  {
    return TextFormField(
      controller:         _materiaController,
      textCapitalization: TextCapitalization.words,
      textInputAction:    TextInputAction.next,
      decoration: const InputDecoration(
        labelText:  'Materia',
        hintText:   'Ej. Matematicas Discretas',
        prefixIcon: Icon(Icons.menu_book_rounded),
      ),
      validator: (value)
      {
        if (value == null || value.trim().isEmpty) {
          return 'Ingresa el nombre de la materia';
        }
        return null;
      },
    );
  }

  Widget _buildPeriodoField()
  {
    return TextFormField(
      controller:         _periodoController,
      textCapitalization: TextCapitalization.words,
      textInputAction:    TextInputAction.next,
      decoration: const InputDecoration(
        labelText:  'Periodo',
        hintText:   'Ej. Ene-Jun 2026',
        prefixIcon: Icon(Icons.calendar_today_outlined),
      ),
      validator: (value)
      {
        if (value == null || value.trim().isEmpty) {
          return 'Ingresa el periodo';
        }
        return null;
      },
    );
  }

  Widget _buildSalonField()
  {
    return TextFormField(
      controller:         _salonController,
      textCapitalization: TextCapitalization.words,
      textInputAction:    TextInputAction.next,
      decoration: const InputDecoration(
        labelText:  'Salon o aula',
        hintText:   'Ej. Aula 301',
        prefixIcon: Icon(Icons.meeting_room_outlined),
      ),
      validator: (value)
      {
        if (value == null || value.trim().isEmpty) {
          return 'Ingresa el salon o aula';
        }
        return null;
      },
    );
  }

  Widget _buildHorarioField()
  {
    return TextFormField(
      controller:         _horarioController,
      textCapitalization: TextCapitalization.words,
      textInputAction:    TextInputAction.done,
      onFieldSubmitted:   (_) => _onGuardarPressed(),
      decoration: const InputDecoration(
        labelText:  'Horario',
        hintText:   'Ej. Lun-Mie 10:00 - 11:30',
        prefixIcon: Icon(Icons.schedule_outlined),
      ),
      validator: (value)
      {
        if (value == null || value.trim().isEmpty) {
          return 'Ingresa el horario';
        }
        return null;
      },
    );
  }

  Widget _buildCodigoInfo(BuildContext context)
  {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color:        AppColors.cloudBlue,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.vpn_key_outlined,
            color: AppColors.deepNavy,
            size:  AppSizes.iconM,
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Codigo de invitacion',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color:      AppColors.deepNavy,
                  ),
                ),
                Text(
                  'Se generara automaticamente al crear el grupo. Comparte el codigo con tus alumnos para que se unan.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:    AppColors.deepNavy,
                    fontSize: AppSizes.fontCaption,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonGuardar()
  {
    return SizedBox(
      width:  double.infinity,
      height: AppSizes.heightButton,
      child: ElevatedButton.icon(
        onPressed: _cargando ? null : _onGuardarPressed,
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
        label: Text(_cargando ? 'Guardando...' : 'Crear grupo'),
      ),
    );
  }
}