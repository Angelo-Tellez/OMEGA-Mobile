// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : suscripcion_screen.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Pantalla de planes y suscripcion
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/config/app_router.dart';
import '../../data/suscripcion_model.dart';
import '../widgets/plan_card_widget.dart';

class SuscripcionScreen extends StatelessWidget
{
  const SuscripcionScreen({super.key});

  static const _suscripcionActual = SuscripcionModel(
    id:          1,
    usuarioId:   1,
    plan:        0,
    estado:      1,
    fechaInicio: '01/04/2026',
    fechaFin:    '',
    ultimoPago:  '',
  );

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
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          children: [
            _buildEstadoActual(context),
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
              isActual:      _suscripcionActual.isBasico,
              isRecomendado: false,
            ),
            const SizedBox(height: AppSizes.paddingM),
            PlanCardWidget(
              nombre:      'Plan Mensual',
              precio:      '\$149',
              descripcion: 'Para docentes con multiples grupos',
              beneficios: const [
                'Aulas ilimitadas',
                'Hasta 50 alumnos por grupo',
                'Historial completo por periodo',
                'Reportes en Excel y PDF',
                'Notificaciones push a alumnos',
              ],
              limitaciones:  const [],
              isActual:      _suscripcionActual.isMensual,
              isRecomendado: true,
              onContratar:   () => _onContratarPressed(context),
            ),
            const SizedBox(height: AppSizes.paddingL),
            if (_suscripcionActual.isMensual)
              _buildNotaGracia(context),
            const SizedBox(height: AppSizes.paddingL),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadoActual(BuildContext context)
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
                Icons.workspace_premium_rounded,
                color: AppColors.deepNavy,
              ),
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
          if (_suscripcionActual.isBasico)
            _buildEstadoBasico(context)
          else
            _buildEstadoMensual(context),
        ],
      ),
    );
  }

  Widget _buildEstadoBasico(BuildContext context)
  {
    return const Row(
      children: [
        _InfoSuscripcionWidget(
          label: 'Plan',
          valor: 'Plan Basico',
        ),
        SizedBox(width: AppSizes.paddingL),
        _InfoSuscripcionWidget(
          label: 'Estado',
          valor: 'Activo',
          color: AppColors.successGreen,
        ),
        SizedBox(width: AppSizes.paddingL),
        _InfoSuscripcionWidget(
          label: 'Precio',
          valor: 'Gratis',
          color: AppColors.deepNavy,
        ),
      ],
    );
  }

  Widget _buildEstadoMensual(BuildContext context)
  {
    final colorEstado = _suscripcionActual.isActivo
        ? AppColors.successGreen
        : AppColors.actionRed;

    final etiquetaEstado = _suscripcionActual.isActivo
        ? 'Activo'
        : _suscripcionActual.isPeriodoGracia
        ? 'Periodo de gracia'
        : 'Vencido';

    return Row(
      children: [
        const _InfoSuscripcionWidget(
          label: 'Plan',
          valor: 'Plan Mensual',
        ),
        const SizedBox(width: AppSizes.paddingL),
        _InfoSuscripcionWidget(
          label: 'Estado',
          valor: etiquetaEstado,
          color: colorEstado,
        ),
        const SizedBox(width: AppSizes.paddingL),
        _InfoSuscripcionWidget(
          label: 'Vence',
          valor: _suscripcionActual.fechaFin,
        ),
      ],
    );
  }

  Widget _buildTitulo(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Elige tu plan',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSizes.paddingXS),
        Text(
          'Puedes cambiar o cancelar en cualquier momento.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.neutralGrey,
          ),
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
        color:AppColors.warningOrange.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.warningOrange),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.actionRed,
            size:  AppSizes.iconM,
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Text(
              'Al vencer tu plan mensual tienes un periodo de gracia de 72 horas antes de perder el acceso a las funciones premium.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onyxGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onContratarPressed(BuildContext context)
  {
    const approvalUrl =
        'https://www.sandbox.paypal.com/checkoutnow?token=MOCK_TOKEN_PRUEBA';

    context.push(
      AppRouter.paypal,
      extra: {
        'approvalUrl': approvalUrl,
        'planNombre':  'Plan Mensual',
        'monto':       '\$149 MXN',
      },
    );
  }
}

class _InfoSuscripcionWidget extends StatelessWidget
{
  final String  label;
  final String  valor;
  final Color?  color;

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
            color:    AppColors.neutralGrey,
            fontSize: AppSizes.fontCaption,
          ),
        ),
        Text(
          valor,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color:      color ?? AppColors.deepNavy,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
