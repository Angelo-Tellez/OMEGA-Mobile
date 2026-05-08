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
//   [002] 08/05/2026 - Jorge Alejandro Martinez Toris - Notificaciones reales desde grupos
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/connection/api_client.dart';
import '../../../../core/constants/api_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../home_alumno/data/materia_alumno_model.dart';

class NotificacionesScreen extends StatefulWidget
{
  const NotificacionesScreen({super.key});

  @override
  State<NotificacionesScreen> createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen>
{
  List<_Notif> _notificaciones = [];
  bool         _cargando       = true;
  final Set<int> _leidas       = {};

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
      final res = await ApiClient.instance.get(ApiRoutes.alumnoGrupos);
      final materias = (res.data['data'] as List)
          .map((m) => MateriaAlumnoModel.fromJson(m as Map<String, dynamic>))
          .toList();

      final lista = <_Notif>[];

      for (final m in materias) {
        // Sesion activa
        if (m.tieneSesionActiva) {
          lista.add(_Notif(
            tipo:    1,
            titulo:  'Sesion activa — ${m.materia}',
            mensaje: 'El docente ha abierto una sesion en ${m.nombreGrupo}. Ingresa tu clave de asistencia.',
          ));
        }

        // Limite de faltas excedido
        if (m.limiteExcedido) {
          lista.add(_Notif(
            tipo:    4,
            titulo:  'Limite excedido — ${m.materia}',
            mensaje: 'Has superado el limite de faltas en ${m.nombreGrupo}. Ya no tienes derecho a ordinario.',
          ));
        }
        // En riesgo
        else if (m.enRiesgo) {
          lista.add(_Notif(
            tipo:    3,
            titulo:  'Riesgo de faltas — ${m.materia}',
            mensaje: 'Te quedan solo ${m.faltasPermitidas} falta(s) permitida(s) en ${m.nombreGrupo}.',
          ));
        }

        // Faltas acumuladas
        if (m.sesionesFalta > 0) {
          lista.add(_Notif(
            tipo:    2,
            titulo:  'Faltas acumuladas — ${m.materia}',
            mensaje: 'Tienes ${m.sesionesFalta} falta(s) registrada(s) en ${m.nombreGrupo}. Asistencia: ${m.porcentajeAsistencia.toStringAsFixed(0)}%.',
          ));
        }
      }

      setState(() { _notificaciones = lista; _cargando = false; });
    } catch (_) {
      setState(() => _cargando = false);
    }
  }

  int get _noLeidas => _notificaciones
      .asMap()
      .entries
      .where((e) => !_leidas.contains(e.key))
      .length;

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
        actions: [
          if (_noLeidas > 0)
            SizedBox(
              width: 110,
              child: TextButton(
                onPressed: () => setState(() => _leidas.addAll(
                  List.generate(_notificaciones.length, (i) => i),
                )),
                child: const Text(
                  'Marcar todas',
                  style: TextStyle(color: AppColors.primaryCoral),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: _cargando
            ? const Center(child: CircularProgressIndicator(color: AppColors.primaryCoral))
            : RefreshIndicator(
          color:     AppColors.primaryCoral,
          onRefresh: _cargar,
          child: _notificaciones.isEmpty
              ? _buildVacio()
              : _buildLista(),
        ),
      ),
    );
  }

  Widget _buildVacio()
  {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
        Column(
          children: [
            const Icon(Icons.notifications_none_rounded, size: 64, color: AppColors.surface),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              'Sin notificaciones',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: AppSizes.fontTitle, color: AppColors.neutralGrey,
              ),
            ),
            const SizedBox(height: AppSizes.paddingS),
            Text(
              'Aqui apareceran tus alertas de clase y asistencia.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.neutralGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLista()
  {
    return ListView.separated(
      padding:         const EdgeInsets.all(AppSizes.paddingM),
      itemCount:       _notificaciones.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.paddingS),
      itemBuilder: (context, index) {
        final n      = _notificaciones[index];
        final leida  = _leidas.contains(index);
        final color  = _colorTipo(n.tipo);
        final icono  = _iconoTipo(n.tipo);

        return GestureDetector(
          onTap: () => setState(() => _leidas.add(index)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:  const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: leida ? AppColors.baseSurface : color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppSizes.radiusCard),
              border: Border.all(
                color: leida ? AppColors.surface : color.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingS),
                  decoration: BoxDecoration(
                    color:        color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusInput),
                  ),
                  child: Icon(icono, size: AppSizes.iconM, color: color),
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
                              n.titulo,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600, color: AppColors.deepNavy,
                              ),
                            ),
                          ),
                          if (!leida)
                            Container(
                              width: 8, height: 8,
                              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.paddingXS),
                      Text(
                        n.mensaje,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.neutralGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _colorTipo(int tipo)
  {
    switch (tipo) {
      case 1:  return AppColors.electricBlue;
      case 2:  return AppColors.warningOrange;
      case 3:  return AppColors.actionRed;
      case 4:  return AppColors.actionRed;
      default: return AppColors.headingDark;
    }
  }

  IconData _iconoTipo(int tipo)
  {
    switch (tipo) {
      case 1:  return Icons.notifications_active_rounded;
      case 2:  return Icons.event_busy_rounded;
      case 3:  return Icons.warning_amber_rounded;
      case 4:  return Icons.error_outline_rounded;
      default: return Icons.notifications_rounded;
    }
  }
}

class _Notif
{
  final int    tipo;
  final String titulo;
  final String mensaje;

  const _Notif({required this.tipo, required this.titulo, required this.mensaje});
}