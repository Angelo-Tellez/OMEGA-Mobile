// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : detalle_sesion_screen.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Pantalla de detalle de sesion
//   [002] 07/05/2026 - Jorge Alejandro Martinez Toris - Conexion backend real
// ============================================================
import 'package:flutter/material.dart';
import '../../../../core/connection/api_client.dart';
import '../../../../core/constants/api_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../data/registro_sesion_model.dart';
import '../dialogs/cambiar_estado_dialog.dart';

class DetalleSesionScreen extends StatefulWidget
{
  final int    sesionId;
  final String nombreGrupo;
  final String nombreMateria;
  final String fecha;

  const DetalleSesionScreen({
    super.key,
    required this.sesionId,
    required this.nombreGrupo,
    required this.nombreMateria,
    required this.fecha,
  });

  @override
  State<DetalleSesionScreen> createState() => _DetalleSesionScreenState();
}

class _DetalleSesionScreenState extends State<DetalleSesionScreen>
{
  final _busquedaController = TextEditingController();
  String                    _filtro   = '';
  List<RegistroSesionModel> _registros = [];
  bool                      _cargando = true;
  String?                   _error;

  @override
  void initState()
  {
    super.initState();
    _cargarDetalle();
  }

  @override
  void dispose()
  {
    _busquedaController.dispose();
    super.dispose();
  }

  Future<void> _cargarDetalle() async
  {
    setState(() { _cargando = true; _error = null; });
    try {
      final response = await ApiClient.instance.get(
        ApiRoutes.detalleSesion(widget.sesionId),
      );
      final data       = response.data['data'] as Map<String, dynamic>;
      final asistencias = data['asistencias'] as List;
      setState(() {
        _registros = asistencias
            .map((a) => RegistroSesionModel.fromJson(a as Map<String, dynamic>))
            .toList();
        _cargando = false;
      });
    } catch (_) {
      setState(() { _error = 'Error al cargar el detalle.'; _cargando = false; });
    }
  }

  List<RegistroSesionModel> get _registrosFiltrados
  {
    if (_filtro.isEmpty) return _registros;
    return _registros.where((r) =>
        r.nombreAlumno.toLowerCase().contains(_filtro.toLowerCase()),
    ).toList();
  }

  int get _presentes    => _registros.where((r) => r.isPresente).length;
  int get _faltas       => _registros.where((r) => r.isFalta).length;
  int get _justificadas => _registros.where((r) => r.isJustificada).length;

  Future<void> _onCambiarEstado(RegistroSesionModel registro) async
  {
    final nuevoEstado = await CambiarEstadoDialog.show(context, registro);
    if (nuevoEstado == null || !mounted) return;

    try {
      await ApiClient.instance.patch(
        ApiRoutes.editarAsistencia(widget.sesionId, registro.alumnoId),
        data: {'est_asistencia': nuevoEstado},
      );

      setState(() {
        final index = _registros.indexWhere((r) => r.alumnoId == registro.alumnoId);
        if (index != -1) {
          _registros[index] = registro.copyWith(
            estado:       nuevoEstado,
            horaRegistro: nuevoEstado == 1 ? 'Manual' : null,
          );
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:         Text('Asistencia de ${registro.nombreAlumno} actualizada'),
            backgroundColor: AppColors.darkSlate,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:         Text('Error al actualizar la asistencia'),
            backgroundColor: AppColors.actionRed,
          ),
        );
      }
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.nombreMateria),
            Text(
              '${widget.nombreGrupo} — ${widget.fecha}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.neutralGrey,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: _cargando
            ? const Center(child: CircularProgressIndicator(color: AppColors.primaryCoral))
            : _error != null
            ? Center(child: Text(_error!))
            : Column(
          children: [
            _buildResumen(context),
            _buildBusqueda(),
            Expanded(child: _buildLista(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildResumen(BuildContext context)
  {
    return Container(
      margin:  const EdgeInsets.all(AppSizes.paddingM),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color:        AppColors.cloudBlue,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
      ),
      child: Row(
        children: [
          Expanded(child: _ResumenItemWidget(valor: _presentes.toString(),    label: 'Presentes',   color: AppColors.successGreen)),
          Expanded(child: _ResumenItemWidget(valor: _faltas.toString(),       label: 'Faltas',      color: AppColors.actionRed)),
          Expanded(child: _ResumenItemWidget(valor: _justificadas.toString(), label: 'Justificadas', color: AppColors.warningOrange)),
          Expanded(child: _ResumenItemWidget(valor: _registros.length.toString(), label: 'Total',   color: AppColors.deepNavy)),
        ],
      ),
    );
  }

  Widget _buildBusqueda()
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
      child: TextFormField(
        controller: _busquedaController,
        onChanged:  (v) => setState(() => _filtro = v),
        decoration: const InputDecoration(
          hintText:   'Buscar alumno',
          prefixIcon: Icon(Icons.search_rounded),
        ),
      ),
    );
  }

  Widget _buildLista(BuildContext context)
  {
    final lista = _registrosFiltrados;
    if (lista.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron alumnos',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.neutralGrey),
        ),
      );
    }
    return ListView.separated(
      padding:          const EdgeInsets.all(AppSizes.paddingM),
      itemCount:        lista.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.paddingS),
      itemBuilder: (context, index)
      {
        final registro = lista[index];
        return _RegistroCardWidget(
          registro:        registro,
          onCambiarEstado: () => _onCambiarEstado(registro),
        );
      },
    );
  }
}

class _ResumenItemWidget extends StatelessWidget
{
  final String valor;
  final String label;
  final Color  color;

  const _ResumenItemWidget({required this.valor, required this.label, required this.color});

  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: [
        Text(valor, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: color, fontWeight: FontWeight.w700)),
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.neutralGrey, fontSize: AppSizes.fontCaption)),
      ],
    );
  }
}

class _RegistroCardWidget extends StatelessWidget
{
  final RegistroSesionModel registro;
  final VoidCallback        onCambiarEstado;

  const _RegistroCardWidget({required this.registro, required this.onCambiarEstado});

  Color get _colorEstado
  {
    if (registro.isPresente)    return AppColors.successGreen;
    if (registro.isJustificada) return AppColors.warningOrange;
    return AppColors.actionRed;
  }

  @override
  Widget build(BuildContext context)
  {
    final partes   = registro.nombreAlumno.split(' ');
    final iniciales = partes.length >= 2
        ? '${partes[0][0]}${partes[1][0]}'.toUpperCase()
        : registro.nombreAlumno[0].toUpperCase();

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
            width:  40,
            height: 40,
            decoration: BoxDecoration(
              color: _colorEstado.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                iniciales,
                style: TextStyle(fontWeight: FontWeight.w700, color: _colorEstado, fontSize: AppSizes.fontCaption),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  registro.nombreAlumno,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: AppColors.deepNavy),
                ),
                Row(
                  children: [
                    const Icon(Icons.schedule_outlined, size: 12, color: AppColors.neutralGrey),
                    const SizedBox(width: AppSizes.paddingXS),
                    Text(
                      registro.horaRegistro ?? '--:--',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.neutralGrey, fontSize: AppSizes.fontCaption),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onCambiarEstado,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingS, vertical: AppSizes.paddingXS),
              decoration: BoxDecoration(
                color:        _colorEstado.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusInput),
                border:       Border.all(color: _colorEstado),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    registro.etiquetaEstado,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: AppSizes.fontCaption, color: _colorEstado, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: AppSizes.paddingXS),
                  Icon(Icons.edit_outlined, size: 12, color: _colorEstado),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}