// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : agregar_institucion_screen.dart
// Created on : 28/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 28/04/2026 - Jorge Alejandro Martinez Toris - Pantalla para agregar institucion con rubros iniciales
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/connection/api_client.dart';
import '../../../../core/constants/api_routes.dart';

class AgregarInstitucionScreen extends StatefulWidget
{
  final bool esOnboarding;

  const AgregarInstitucionScreen({
    super.key,
    required this.esOnboarding,
  });

  @override
  State<AgregarInstitucionScreen> createState() => _AgregarInstitucionScreenState();
}

class _AgregarInstitucionScreenState extends State<AgregarInstitucionScreen>
{
  final _formKey        = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  bool  _cargando       = false;
  int   _pasoActual     = 0;

  final List<_RubroEditable> _rubros = [
    _RubroEditable(nombre: 'Ordinario',      porcentaje: 80),
    _RubroEditable(nombre: 'Extraordinario', porcentaje: 60),
  ];

  @override
  void dispose()
  {
    _nombreController.dispose();
    for (final r in _rubros) {
      r.dispose();
    }
    super.dispose();
  }

  void _agregarRubro()
  {
    setState(() => _rubros.add(_RubroEditable(nombre: '', porcentaje: 70)));
  }

  void _eliminarRubro(int index)
  {
    if (_rubros.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:         Text('Debes tener al menos un rubro de evaluacion'),
          backgroundColor: AppColors.darkSlate,
        ),
      );
      return;
    }
    setState(()
    {
      _rubros[index].dispose();
      _rubros.removeAt(index);
    });
  }

  void _avanzarPaso()
  {
    if (_pasoActual == 0) {
      if (_formKey.currentState!.validate()) {
        setState(() => _pasoActual = 1);
      }
      return;
    }

    _guardar();
  }

  Future<void> _guardar() async
  {
    for (int i = 0; i < _rubros.length; i++) {
      final rubro = _rubros[i];
      if (rubro.nombreController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:         Text('El rubro ${i + 1} no tiene nombre'),
            backgroundColor: AppColors.darkSlate,
          ),
        );
        return;
      }
      if (rubro.porcentaje < 1 || rubro.porcentaje > 100) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:         Text('El porcentaje del rubro ${i + 1} debe estar entre 1 y 100'),
            backgroundColor: AppColors.darkSlate,
          ),
        );
        return;
      }
    }

    setState(() => _cargando = true);

    try {
      // 1. Crear institución
      final respInst = await ApiClient.instance.post(
        ApiRoutes.instituciones,
        data: {'nombre': _nombreController.text.trim()},
      );

      final institucionId = respInst.data['data']['id_institucion'] as int;

      // 2. Crear rubros
      for (final rubro in _rubros) {
        await ApiClient.instance.post(
          ApiRoutes.rubros(institucionId),
          data: {
            'nombre':            rubro.nombreController.text.trim(),
            'porcentaje_minimo': rubro.porcentaje.toInt(),
          },
        );
      }

      if (!mounted) return;
      setState(() => _cargando = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:         Text('Institucion creada correctamente'),
          backgroundColor: AppColors.successGreen,
        ),
      );

      if (widget.esOnboarding) {
        context.go(AppRouter.homeDocente);
      } else {
        Navigator.of(context).pop(true);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:         Text('Error al crear la institucion'),
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: ()
          {
            if (_pasoActual == 1) {
              setState(() => _pasoActual = 0);
            } else if (!widget.esOnboarding) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(widget.esOnboarding ? 'Configuracion inicial' : 'Nueva institucion'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value:           (_pasoActual + 1) / 2,
            backgroundColor: AppColors.surface,
            valueColor:      const AlwaysStoppedAnimation<Color>(AppColors.primaryCoral),
          ),
        ),
      ),
      body: SafeArea(
        child: _pasoActual == 0
            ? _buildPaso1(context)
            : _buildPaso2(context),
      ),
      bottomNavigationBar: _buildBotonNavegacion(context),
    );
  }

  Widget _buildPaso1(BuildContext context)
  {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEncabezadoPaso(
              context,
              paso:    'Paso 1 de 2',
              titulo:  'Datos de la institucion',
              subtitulo: 'Ingresa el nombre de tu escuela o universidad.',
            ),
            const SizedBox(height: AppSizes.paddingXL),
            TextFormField(
              controller:         _nombreController,
              textCapitalization: TextCapitalization.words,
              textInputAction:    TextInputAction.done,
              decoration: const InputDecoration(
                labelText:  'Nombre de la institucion',
                hintText:   'Ej. Tecnologico de Toluca',
                prefixIcon: Icon(Icons.account_balance_rounded),
              ),
              validator: (value)
              {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa el nombre de la institucion';
                }
                if (value.trim().length < 3) {
                  return 'El nombre debe tener al menos 3 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSizes.paddingL),
            Container(
              width:   double.infinity,
              padding: const EdgeInsets.all(AppSizes.paddingM),
              decoration: BoxDecoration(
                color:        AppColors.cloudBlue,
                borderRadius: BorderRadius.circular(AppSizes.radiusCard),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.deepNavy,
                    size:  AppSizes.iconM,
                  ),
                  const SizedBox(width: AppSizes.paddingM),
                  Expanded(
                    child: Text(
                      'Puedes agregar el logo de la institucion despues desde la configuracion.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:    AppColors.deepNavy,
                        fontSize: AppSizes.fontCaption,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaso2(BuildContext context)
  {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: _buildEncabezadoPaso(
            context,
            paso:      'Paso 2 de 2',
            titulo:    'Rubros de evaluacion',
            subtitulo: 'Define los porcentajes minimos de asistencia para cada rubro. Podras modificarlos despues.',
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding:          const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
            itemCount:        _rubros.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.paddingM),
            itemBuilder: (context, index)
            {
              return _buildRubroEditable(context, index);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: SizedBox(
            width:  double.infinity,
            height: AppSizes.heightButton,
            child:  OutlinedButton.icon(
              onPressed: _agregarRubro,
              icon:  const Icon(Icons.add_rounded),
              label: const Text('Agregar rubro'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.headingDark,
                side: const BorderSide(color: AppColors.headingDark),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusButton),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEncabezadoPaso(
      BuildContext context, {
        required String paso,
        required String titulo,
        required String subtitulo,
      })
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingS,
            vertical:   AppSizes.paddingXS,
          ),
          decoration: BoxDecoration(
            color:        AppColors.subtleWarm,
            borderRadius: BorderRadius.circular(AppSizes.radiusInput),
          ),
          child: Text(
            paso,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color:      AppColors.primaryCoral,
              fontWeight: FontWeight.w600,
              fontSize:   AppSizes.fontCaption,
            ),
          ),
        ),
        const SizedBox(height: AppSizes.paddingS),
        Text(
          titulo,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSizes.paddingXS),
        Text(
          subtitulo,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.neutralGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildRubroEditable(BuildContext context, int index)
  {
    final rubro = _rubros[index];

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
          Row(
            children: [
              Container(
                width:  28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.primaryCoral,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color:      AppColors.baseSurface,
                      fontWeight: FontWeight.w700,
                      fontSize:   AppSizes.fontCaption,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.paddingS),
              Text(
                'Rubro ${index + 1}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:      AppColors.deepNavy,
                ),
              ),
              const Spacer(),
              IconButton(
                icon:    const Icon(Icons.delete_outline_rounded),
                color:   AppColors.actionRed,
                onPressed: () => _eliminarRubro(index),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingM),
          TextFormField(
            controller:         rubro.nombreController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText:  'Nombre del rubro',
              hintText:   'Ej. Ordinario',
              prefixIcon: Icon(Icons.label_outline_rounded),
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Porcentaje minimo: ${rubro.porcentaje.toInt()}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:      AppColors.deepNavy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingS,
                  vertical:   AppSizes.paddingXS,
                ),
                decoration: BoxDecoration(
                  color:        _colorPorcentaje(rubro.porcentaje).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusInput),
                  border: Border.all(
                    color: _colorPorcentaje(rubro.porcentaje),
                  ),
                ),
                child: Text(
                  '${rubro.porcentaje.toInt()}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:      _colorPorcentaje(rubro.porcentaje),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value:       rubro.porcentaje,
            min:         1,
            max:         100,
            divisions:   99,
            activeColor: _colorPorcentaje(rubro.porcentaje),
            onChanged: (valor) => setState(() => rubro.porcentaje = valor),
          ),
        ],
      ),
    );
  }

  Color _colorPorcentaje(double porcentaje)
  {
    if (porcentaje >= 80) return AppColors.successGreen;
    if (porcentaje >= 60) return AppColors.warningOrange;
    return AppColors.actionRed;
  }

  Widget _buildBotonNavegacion(BuildContext context)
  {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.paddingL,
        AppSizes.paddingS,
        AppSizes.paddingL,
        AppSizes.paddingL + MediaQuery.of(context).padding.bottom,
      ),
      child: SizedBox(
        width:  double.infinity,
        height: AppSizes.heightButton,
        child:  ElevatedButton(
          onPressed: _cargando ? null : _avanzarPaso,
          child: _cargando
              ? const SizedBox(
            height: 22,
            width:  22,
            child:  CircularProgressIndicator(
              strokeWidth: 2.5,
              color:       AppColors.baseSurface,
            ),
          )
              : Text(_pasoActual == 0 ? 'Continuar' : 'Crear institucion'),
        ),
      ),
    );
  }
}

class _RubroEditable
{
  final TextEditingController nombreController;
  double porcentaje;

  _RubroEditable({required String nombre, required double porcentaje})
      : nombreController = TextEditingController(text: nombre),
        porcentaje       = porcentaje;

  void dispose()
  {
    nombreController.dispose();
  }
}