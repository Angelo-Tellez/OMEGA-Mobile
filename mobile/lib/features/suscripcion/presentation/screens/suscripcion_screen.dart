// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : suscripcion_screen.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Pantalla de planes y suscripcion
//   [002] 21/05/2026 - Jorge Alejandro Martinez Toris - Conexion real al backend y PayPal
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/connection/api_client.dart';
import '../../../../core/constants/api_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/config/app_router.dart';
import '../../data/suscripcion_model.dart';
import '../widgets/plan_card_widget.dart';

class SuscripcionScreen extends StatefulWidget
{
  const SuscripcionScreen({super.key});

  @override
  State<SuscripcionScreen> createState() => _SuscripcionScreenState();
}

class _SuscripcionScreenState extends State<SuscripcionScreen>
{
  SuscripcionModel? _suscripcion;
  bool _cargando   = true;
  bool _contratando = false;

  @override
  void initState()
  {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async
  {
    setState(() => _cargando = true);
    try {
      final res  = await ApiClient.instance.get(ApiRoutes.suscripcion);
      final data = res.data['data'] as Map<String, dynamic>;
      setState(() {
        _suscripcion = SuscripcionModel.fromJson(data);
        _cargando    = false;
      });
    } catch (_) {
      setState(() => _cargando = false);
    }
  }

  Future<void> _onContratarPressed() async
  {
    setState(() => _contratando = true);
    try {
      final res = await ApiClient.instance.post(ApiRoutes.crearOrdenPaypal);
      final data = res.data['data'] as Map<String, dynamic>;

      final approvalUrl = data['approval_url'] as String;
      final orderId     = data['order_id']     as String;

      if (!mounted) return;

      final resultado = await context.push<bool>(
        AppRouter.paypal,
        extra: {
          'approvalUrl': approvalUrl,
          'orderId':     orderId,
          'planNombre':  'Plan Mensual',
          'monto':       '\$149 MXN',
        },
      );

      // Si el pago fue exitoso, recargar suscripcion
      if (resultado == true) {
        await _cargar();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:         Text('No se pudo iniciar el pago. Intenta de nuevo.'),
          backgroundColor: AppColors.actionRed,
          behavior:        SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _contratando = false);
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
        title: const Text('Planes y suscripcion'),
      ),
      body: SafeArea(
        child: _cargando
            ? const Center(child: CircularProgressIndicator(color: AppColors.primaryCoral))
            : RefreshIndicator(
                color:     AppColors.primaryCoral,
                onRefresh: _cargar,
                child: ListView(
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  children: [
                    if (_suscripcion != null) _buildEstadoActual(context),
                    const SizedBox(height: AppSizes.paddingL),
                    _buildTitulo(context),
                    const SizedBox(height: AppSizes.paddingM),
                    PlanCardWidget(
                      nombre:      'Plan Basico',
                      precio:      'Gratis',
                      descripcion: 'Para docentes que comienzan',
                      beneficios: const [
                        '1 aula activa',
                        'Hasta 15 alumnos por grupo',
                        'Registro de asistencia por clave',
                        'Historial de 1 semana',
                      ],
                      limitaciones: const [
                        'Sin reportes en Excel/PDF',
                        'Sin historial completo',
                      ],
                      isActual:      _suscripcion?.isBasico ?? true,
                      isRecomendado: false,
                    ),
                    const SizedBox(height: AppSizes.paddingM),
                    PlanCardWidget(
                      nombre:      'Plan Mensual',
                      precio:      '\$149 MXN',
                      descripcion: 'Para docentes con multiples grupos',
                      beneficios: const [
                        'Aulas ilimitadas',
                        'Hasta 50 alumnos por grupo',
                        'Historial completo por periodo',
                        'Reportes en Excel y PDF',
                        'Notificaciones push a alumnos',
                      ],
                      limitaciones:  const [],
                      isActual:      _suscripcion?.isMensual ?? false,
                      isRecomendado: true,
                      onContratar:   _contratando ? null : _onContratarPressed,
                      cargando:      _contratando,
                    ),
                    const SizedBox(height: AppSizes.paddingL),
                    if (_suscripcion?.isMensual == true)
                      _buildNotaGracia(context),
                    const SizedBox(height: AppSizes.paddingL),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildEstadoActual(BuildContext context)
  {
    final s = _suscripcion!;

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
              const Icon(Icons.workspace_premium_rounded, color: AppColors.deepNavy),
              const SizedBox(width: AppSizes.paddingS),
              Text(
                'Suscripcion actual',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:      AppColors.deepNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingM),
          s.isBasico
              ? _buildEstadoBasico(context)
              : _buildEstadoMensual(context, s),
        ],
      ),
    );
  }

  Widget _buildEstadoBasico(BuildContext context)
  {
    return const Row(
      children: [
        _InfoSuscripcionWidget(label: 'Plan',   valor: 'Plan Basico'),
        SizedBox(width: AppSizes.paddingL),
        _InfoSuscripcionWidget(label: 'Estado', valor: 'Activo',  color: AppColors.successGreen),
        SizedBox(width: AppSizes.paddingL),
        _InfoSuscripcionWidget(label: 'Precio', valor: 'Gratis',  color: AppColors.deepNavy),
      ],
    );
  }

  Widget _buildEstadoMensual(BuildContext context, SuscripcionModel s)
  {
    final colorEstado    = s.isActivo ? AppColors.successGreen : AppColors.actionRed;
    final etiquetaEstado = s.isActivo
        ? 'Activo'
        : s.isPeriodoGracia ? 'Periodo de gracia' : 'Vencido';

    return Row(
      children: [
        const _InfoSuscripcionWidget(label: 'Plan', valor: 'Plan Mensual'),
        const SizedBox(width: AppSizes.paddingL),
        _InfoSuscripcionWidget(label: 'Estado', valor: etiquetaEstado, color: colorEstado),
        const SizedBox(width: AppSizes.paddingL),
        _InfoSuscripcionWidget(label: 'Vence',  valor: s.fechaFin ?? '—'),
      ],
    );
  }

  Widget _buildTitulo(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Elige tu plan', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: AppSizes.paddingXS),
        Text(
          'Puedes cambiar o cancelar en cualquier momento.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.neutralGrey),
        ),
      ],
    );
  }

  Widget _buildNotaGracia(BuildContext context)
  {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color:        AppColors.warningOrange.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.warningOrange),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.actionRed, size: AppSizes.iconM),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Text(
              'Al vencer tu plan mensual tienes un periodo de gracia de 72 horas antes de perder el acceso a las funciones premium.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onyxGrey),
            ),
          ),
        ],
      ),
    );
  }
}

// ── WIDGETS AUXILIARES ────────────────────────────────────

class _InfoSuscripcionWidget extends StatelessWidget
{
  final String label;
  final String valor;
  final Color? color;

  const _InfoSuscripcionWidget({
    required this.label,
    required this.valor,
    this.color,
  });

  @override
  Widget build(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.neutralGrey, fontSize: AppSizes.fontCaption,
          ),
        ),
        Text(
          valor,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color ?? AppColors.deepNavy, fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
