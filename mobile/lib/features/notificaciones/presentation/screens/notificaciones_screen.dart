// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : notificaciones_screen.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Pantalla de notificaciones del alumno
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../data/notificacion_model.dart';

class NotificacionesScreen extends StatefulWidget
{
  const NotificacionesScreen({super.key});

  @override
  State<NotificacionesScreen> createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen>
{
  late List<NotificacionModel> _notificaciones;

  @override
  void initState()
  {
    super.initState();
    _notificaciones = [
      const NotificacionModel(
        id: 1, tipo: 1,
        titulo:  'Clase en 10 minutos',
        mensaje: 'Matematicas Discretas con Juan Perez Lopez comenzara a las 10:00 en Aula 301.',
        fecha: 'Hoy', hora: '09:50', leida: false,
      ),
      const NotificacionModel(
        id: 2, tipo: 3,
        titulo:  'Riesgo de faltas',
        mensaje: 'Te quedan solo 2 faltas permitidas en Bases de Datos para conservar el derecho a Ordinario.',
        fecha: 'Hoy', hora: '08:00', leida: false,
      ),
      const NotificacionModel(
        id: 3, tipo: 2,
        titulo:  'Falta registrada',
        mensaje: 'Se registro tu inasistencia en la sesion de Bases de Datos del 25/04/2026.',
        fecha: 'Ayer', hora: '11:30', leida: true,
      ),
      const NotificacionModel(
        id: 4, tipo: 4,
        titulo:  'Limite de faltas excedido',
        mensaje: 'Has excedido el limite de faltas en Bases de Datos. Ya no tienes derecho a Ordinario.',
        fecha: 'Ayer', hora: '10:00', leida: true,
      ),
      const NotificacionModel(
        id: 5, tipo: 1,
        titulo:  'Clase en 10 minutos',
        mensaje: 'Programacion Orientada a Objetos con Juan Perez Lopez comenzara a las 08:00 en Lab 102.',
        fecha: '25/04/2026', hora: '07:50', leida: true,
      ),
      const NotificacionModel(
        id: 6, tipo: 2,
        titulo:  'Falta registrada',
        mensaje: 'Se registro tu inasistencia en la sesion de Matematicas Discretas del 23/04/2026.',
        fecha: '23/04/2026', hora: '10:45', leida: true,
      ),
    ];
  }

  int get _noLeidas => _notificaciones.where((n) => !n.leida).length;

  void _marcarTodasLeidas()
  {
    setState(()
    {
      _notificaciones = _notificaciones
          .map((n) => n.copyWith(leida: true))
          .toList();
    });
  }

  void _marcarLeida(int id)
  {
    setState(()
    {
      final index = _notificaciones.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notificaciones[index] = _notificaciones[index].copyWith(leida: true);
      }
    });
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
        title: Row(
          children: [
            const Text('Notificaciones'),
            if (_noLeidas > 0) ...[
              const SizedBox(width: AppSizes.paddingS),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingS,
                  vertical:   AppSizes.paddingXS,
                ),
                decoration: BoxDecoration(
                  color:        AppColors.primaryCoral,
                  borderRadius: BorderRadius.circular(AppSizes.radiusButton),
                ),
                child: Text(
                  '$_noLeidas',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:      AppColors.baseSurface,
                    fontSize:   AppSizes.fontCaption,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      body: SafeArea(
        child: _notificaciones.isEmpty
            ? _buildVacio(context)
            : _buildContenido(context),
      ),
    );
  }

  Widget _buildContenido(BuildContext context)
  {
    return Column(
      children: [
        if (_noLeidas > 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.paddingM,
              AppSizes.paddingS,
              AppSizes.paddingM,
              0,
            ),
            child: SizedBox(
              width:  double.infinity,
              height: AppSizes.heightButton,
              child:  OutlinedButton.icon(
                onPressed: _marcarTodasLeidas,
                icon:  const Icon(Icons.done_all_rounded),
                label: const Text('Marcar todas como leidas'),
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
        Expanded(child: _buildLista(context)),
      ],
    );
  }

  Widget _buildVacio(BuildContext context)
  {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            size:  64,
            color: AppColors.surface,
          ),
          const SizedBox(height: AppSizes.paddingM),
          Text(
            'Sin notificaciones',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: AppSizes.fontTitle,
              color:    AppColors.neutralGrey,
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            'Aqui apareceran tus alertas de clase y asistencia.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.neutralGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLista(BuildContext context)
  {
    final Map<String, List<NotificacionModel>> agrupadas = {};

    for (final n in _notificaciones) {
      agrupadas.putIfAbsent(n.fecha, () => []).add(n);
    }

    return ListView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      children: agrupadas.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS),
              child: Text(
                entry.key,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:      AppColors.neutralGrey,
                  fontSize:   AppSizes.fontCaption,
                ),
              ),
            ),
            ...entry.value.map((n) => _NotificacionCardWidget(
              notificacion: n,
              onTap:        () => _marcarLeida(n.id),
            )),
          ],
        );
      }).toList(),
    );
  }
}

class _NotificacionCardWidget extends StatelessWidget
{
  final NotificacionModel notificacion;
  final VoidCallback      onTap;

  const _NotificacionCardWidget({
    required this.notificacion,
    required this.onTap,
  });

  Color get _colorTipo
  {
    if (notificacion.isInicioClase)    return AppColors.electricBlue;
    if (notificacion.isInasistencia)   return AppColors.warningOrange;
    if (notificacion.isRiesgoFaltas)   return AppColors.actionRed;
    if (notificacion.isLimiteExcedido) return AppColors.actionRed;
    return AppColors.headingDark;
  }

  IconData get _iconoTipo
  {
    if (notificacion.isInicioClase)    return Icons.notifications_active_rounded;
    if (notificacion.isInasistencia)   return Icons.event_busy_rounded;
    if (notificacion.isRiesgoFaltas)   return Icons.warning_amber_rounded;
    if (notificacion.isLimiteExcedido) return Icons.error_outline_rounded;
    return Icons.notifications_rounded;
  }

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin:   const EdgeInsets.only(bottom: AppSizes.paddingS),
        padding:  const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color: notificacion.leida
              ? AppColors.baseSurface
              : _colorTipo.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          border: Border.all(
            color: notificacion.leida
                ? AppColors.surface
                : _colorTipo.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingS),
              decoration: BoxDecoration(
                color:        _colorTipo.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusInput),
              ),
              child: Icon(
                _iconoTipo,
                size:  AppSizes.iconM,
                color: _colorTipo,
              ),
            ),
            const SizedBox(width: AppSizes.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notificacion.titulo,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color:      AppColors.deepNavy,
                          ),
                        ),
                      ),
                      if (!notificacion.leida)
                        Container(
                          width:  8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _colorTipo,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.paddingXS),
                  Text(
                    notificacion.mensaje,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.neutralGrey,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingXS),
                  Text(
                    notificacion.hora,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: AppSizes.fontCaption,
                      color:    AppColors.neutralGrey,
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
}