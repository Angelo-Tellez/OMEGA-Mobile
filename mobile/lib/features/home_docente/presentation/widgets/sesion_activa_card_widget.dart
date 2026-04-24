// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : sesion_activa_card_widget.dart
// Created on : 24/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 24/04/2026 - Dev - Tarjeta de sesion activa con clave y temporizador
//   [002] 24/04/2026 - Dev - La clave ahora llega como parametro independiente
//                            del modelo de sesion
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../data/sesion_model.dart';

class SesionActivaCardWidget extends StatefulWidget
{
  final SesionModel  sesion;
  final String       clave;
  final VoidCallback onCerrar;

  const SesionActivaCardWidget({
    super.key,
    required this.sesion,
    required this.clave,
    required this.onCerrar,
  });

  @override
  State<SesionActivaCardWidget> createState() => _SesionActivaCardWidgetState();
}

class _SesionActivaCardWidgetState extends State<SesionActivaCardWidget>
{
  late Timer _timer;
  late int   _segundos;
  bool       _pulsante = false;

  @override
  void initState()
  {
    super.initState();
    _segundos = DateTime.now().difference(widget.sesion.horaApertura).inSeconds;
    _startTimer();
    _startPulse();
  }

  void _startTimer()
  {
    _timer = Timer.periodic(const Duration(seconds: 1), (_)
    {
      if (mounted) setState(() => _segundos++);
    });
  }

  void _startPulse()
  {
    Timer.periodic(const Duration(milliseconds: 900), (_)
    {
      if (mounted) setState(() => _pulsante = !_pulsante);
    });
  }

  @override
  void dispose()
  {
    _timer.cancel();
    super.dispose();
  }

  String get _tiempoFormateado
  {
    final minutos  = (_segundos ~/ 60).toString().padLeft(2, '0');
    final segundos = (_segundos % 60).toString().padLeft(2, '0');
    return '$minutos:$segundos';
  }

  void _copiarClave()
  {
    Clipboard.setData(ClipboardData(text: widget.clave));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:         Text('Clave copiada al portapapeles'),
        backgroundColor: AppColors.darkSlate,
        duration:        Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color:        AppColors.baseSurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.successGreen, width: 2),
      ),
      child: Column(
        children: [
          _buildStatusRow(context),
          const SizedBox(height: AppSizes.paddingL),
          _buildClave(context),
          const SizedBox(height: AppSizes.paddingM),
          _buildTimer(context),
          const SizedBox(height: AppSizes.paddingL),
          _buildCerrarButton(),
        ],
      ),
    );
  }

  Widget _buildStatusRow(BuildContext context)
  {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width:  10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _pulsante ? AppColors.successGreen : AppColors.subtleWarm,
          ),
        ),
        const SizedBox(width: AppSizes.paddingS),
        Text(
          'Sesion activa',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color:      AppColors.successGreen,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildClave(BuildContext context)
  {
    return GestureDetector(
      onTap: _copiarClave,
      child: Column(
        children: [
          Text(
            'Clave de asistencia',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.neutralGrey,
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            widget.clave,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize:      AppSizes.fontKeyDisplay,
              fontWeight:    FontWeight.w700,
              color:         AppColors.deepNavy,
              letterSpacing: 12,
            ),
          ),
          const SizedBox(height: AppSizes.paddingXS),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.copy_rounded, size: 14, color: AppColors.neutralGrey),
              const SizedBox(width: AppSizes.paddingXS),
              Text(
                'Toca para copiar',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: AppSizes.fontCaption,
                  color:    AppColors.neutralGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimer(BuildContext context)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.schedule_rounded, size: AppSizes.iconS, color: AppColors.neutralGrey),
        const SizedBox(width: AppSizes.paddingXS),
        Text(
          _tiempoFormateado,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color:      AppColors.neutralGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCerrarButton()
  {
    return SizedBox(
      width:  double.infinity,
      height: AppSizes.heightButton,
      child:  ElevatedButton(
        onPressed: widget.onCerrar,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.actionRed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusButton),
          ),
        ),
        child: const Text('Cerrar registro'),
      ),
    );
  }
}