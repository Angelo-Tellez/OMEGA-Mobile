// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : agregar_grupo_screen.dart
// Created on : 24/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 24/04/2026 - Jorge Alejandro Martinez Toris - Pantalla para agregar nuevo grupo
//   [002] 28/05/2026 - Jorge Alejandro Martinez Toris - Combo periodo con año automatico + selector horario estructurado
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
  final _salonController   = TextEditingController();

  // Periodo
  String? _periodoSeleccionado;

  // Horario
  final Set<int> _diasSeleccionados = {};
  TimeOfDay?     _horaInicio;
  double         _duracionHoras = 1.0;

  bool _cargando = false;

  // ── Constantes ─────────────────────────────────────────────

  static const List<String> _nombresDias = [
    'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb',
  ];

  static const List<double> _duraciones = [1.0, 1.5, 2.0, 2.5, 3.0];

  // ── Computed ───────────────────────────────────────────────

  List<String> get _periodosDisponibles
  {
    final anio = DateTime.now().year;
    return [
      'Ene-Jun $anio',
      'Ago-Dic $anio',
      'Ene-Jun ${anio + 1}',
      'Ago-Dic ${anio + 1}',
    ];
  }

  String _formatDuracion(double d)
  {
    final horas   = d.floor();
    final minutos = ((d - horas) * 60).round();
    if (minutos == 0) return horas == 1 ? '1 hora' : '$horas horas';
    return '$horas h ${minutos} min';
  }

  String _formatHora(TimeOfDay t)
  {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  TimeOfDay _calcularHoraFin()
  {
    final startMins = _horaInicio!.hour * 60 + _horaInicio!.minute;
    final endMins   = startMins + (_duracionHoras * 60).round();
    return TimeOfDay(hour: (endMins ~/ 60) % 24, minute: endMins % 60);
  }

  String get _horarioTexto
  {
    if (_diasSeleccionados.isEmpty || _horaInicio == null) return '';
    final dias   = (List<int>.from(_diasSeleccionados)..sort())
        .map((d) => _nombresDias[d])
        .join(', ');
    final inicio = _formatHora(_horaInicio!);
    final fin    = _formatHora(_calcularHoraFin());
    return '$dias  ·  $inicio - $fin';
  }

  // ── Lifecycle ──────────────────────────────────────────────

  @override
  void dispose()
  {
    _nombreController.dispose();
    _materiaController.dispose();
    _salonController.dispose();
    super.dispose();
  }

  // ── Actions ────────────────────────────────────────────────

  Future<void> _seleccionarHoraInicio() async
  {
    final hora = await showTimePicker(
      context:      context,
      initialTime:  _horaInicio ?? const TimeOfDay(hour: 8, minute: 0),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (hora != null) setState(() => _horaInicio = hora);
  }

  Future<void> _onGuardarPressed() async
  {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    try {
      await ApiClient.instance.post(
        ApiRoutes.grupos(widget.institucionId),
        data: {
          'nombre':  _nombreController.text.trim(),
          'materia': _materiaController.text.trim(),
          'periodo': _periodoSeleccionado ?? '',
          'salon':   _salonController.text.trim(),
          'horario': _horarioTexto,
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

  // ── Build ──────────────────────────────────────────────────

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
                _buildSeccionTitulo('Información del grupo'),
                const SizedBox(height: AppSizes.paddingM),
                _buildNombreField(),
                const SizedBox(height: AppSizes.paddingM),
                _buildMateriaField(),
                const SizedBox(height: AppSizes.paddingM),
                _buildPeriodoDropdown(context),
                const SizedBox(height: AppSizes.paddingXL),
                _buildSeccionTitulo('Ubicación y horario'),
                const SizedBox(height: AppSizes.paddingM),
                _buildSalonField(),
                const SizedBox(height: AppSizes.paddingM),
                _buildHorarioBuilder(context),
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

  // ── Secciones ──────────────────────────────────────────────

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
                'Se generará un código único para que los alumnos se unan.',
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
        hintText:   'Ej. Matemáticas Discretas',
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

  Widget _buildPeriodoDropdown(BuildContext context)
  {
    return DropdownButtonFormField<String>(
      value:      _periodoSeleccionado,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText:  'Periodo',
        prefixIcon: Icon(Icons.calendar_today_outlined),
      ),
      hint: const Text('Selecciona el periodo'),
      items: _periodosDisponibles.map((periodo) {
        return DropdownMenuItem<String>(
          value: periodo,
          child: Text(periodo),
        );
      }).toList(),
      onChanged: (value) => setState(() => _periodoSeleccionado = value),
      validator: (value)
      {
        if (value == null || value.isEmpty) {
          return 'Selecciona el periodo';
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
        labelText:  'Salón o aula',
        hintText:   'Ej. Aula 301',
        prefixIcon: Icon(Icons.meeting_room_outlined),
      ),
    );
  }

  Widget _buildHorarioBuilder(BuildContext context)
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
          Row(
            children: [
              const Icon(Icons.schedule_outlined,
                  size: AppSizes.iconS, color: AppColors.neutralGrey),
              const SizedBox(width: AppSizes.paddingS),
              Text(
                'Horario de clase',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:      AppColors.deepNavy,
                ),
              ),
              const Spacer(),
              Text(
                'Opcional',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:    AppColors.neutralGrey,
                  fontSize: AppSizes.fontCaption,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingM),

          // Días de la semana
          Text(
            'Días de clase',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.neutralGrey,
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
          _buildSelectorDias(),
          const SizedBox(height: AppSizes.paddingM),

          // Hora de inicio
          _buildFilaHoraInicio(context),
          const SizedBox(height: AppSizes.paddingM),

          // Duración
          _buildFilaDuracion(context),

          // Resultado generado
          if (_horarioTexto.isNotEmpty) ...[
            const SizedBox(height: AppSizes.paddingM),
            _buildResumenHorario(context),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectorDias()
  {
    return Wrap(
      spacing:    AppSizes.paddingS,
      runSpacing: AppSizes.paddingS,
      children: List.generate(6, (i) {
        final seleccionado = _diasSeleccionados.contains(i);
        return GestureDetector(
          onTap: () => setState(() {
            if (seleccionado) {
              _diasSeleccionados.remove(i);
            } else {
              _diasSeleccionados.add(i);
            }
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width:   44,
            height:  40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: seleccionado ? AppColors.primaryCoral : AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusInput),
              border: Border.all(
                color: seleccionado ? AppColors.primaryCoral : AppColors.borderSky,
              ),
            ),
            child: Text(
              _nombresDias[i],
              style: TextStyle(
                fontSize:   AppSizes.fontCaption,
                fontWeight: FontWeight.w600,
                color:      seleccionado ? AppColors.baseSurface : AppColors.neutralGrey,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFilaHoraInicio(BuildContext context)
  {
    return Row(
      children: [
        Text(
          'Hora de inicio',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.neutralGrey,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: _seleccionarHoraInicio,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingM,
              vertical:   AppSizes.paddingS,
            ),
            decoration: BoxDecoration(
              color:        _horaInicio != null
                  ? AppColors.primaryCoral.withValues(alpha: 0.1)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusInput),
              border:       Border.all(
                color: _horaInicio != null
                    ? AppColors.primaryCoral
                    : AppColors.borderSky,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size:  AppSizes.iconS,
                  color: _horaInicio != null
                      ? AppColors.primaryCoral
                      : AppColors.neutralGrey,
                ),
                const SizedBox(width: AppSizes.paddingXS),
                Text(
                  _horaInicio != null
                      ? _formatHora(_horaInicio!)
                      : 'Seleccionar',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:      _horaInicio != null
                        ? AppColors.primaryCoral
                        : AppColors.neutralGrey,
                    fontWeight: _horaInicio != null
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilaDuracion(BuildContext context)
  {
    return Row(
      children: [
        Text(
          'Duración',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.neutralGrey,
          ),
        ),
        const Spacer(),
        DropdownButton<double>(
          value:          _duracionHoras,
          underline:      const SizedBox.shrink(),
          style:          Theme.of(context).textTheme.bodyMedium?.copyWith(
            color:      AppColors.deepNavy,
            fontWeight: FontWeight.w600,
          ),
          items: _duraciones.map((d) {
            return DropdownMenuItem<double>(
              value: d,
              child: Text(_formatDuracion(d)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) setState(() => _duracionHoras = value);
          },
        ),
      ],
    );
  }

  Widget _buildResumenHorario(BuildContext context)
  {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color:        AppColors.cloudBlue,
        borderRadius: BorderRadius.circular(AppSizes.radiusInput),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.event_note_rounded,
            size:  AppSizes.iconS,
            color: AppColors.deepNavy,
          ),
          const SizedBox(width: AppSizes.paddingS),
          Expanded(
            child: Text(
              _horarioTexto,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:      AppColors.deepNavy,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
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
                  'Código de invitación',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color:      AppColors.deepNavy,
                  ),
                ),
                Text(
                  'Se generará automáticamente al crear el grupo. Comparte el código con tus alumnos para que se unan.',
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
