// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : paypal_screen.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Pantalla de pago con PayPal sandbox via WebView
//   [002] 21/05/2026 - Jorge Alejandro Martinez Toris - Confirmacion y cancelacion reales contra el backend
// ============================================================

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/connection/api_client.dart';
import '../../../../core/constants/api_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/services/suscripcion_service.dart';

class PaypalScreen extends StatefulWidget
{
  final String approvalUrl;
  final String orderId;
  final String planNombre;
  final String monto;

  const PaypalScreen({
    super.key,
    required this.approvalUrl,
    required this.orderId,
    required this.planNombre,
    required this.monto,
  });

  @override
  State<PaypalScreen> createState() => _PaypalScreenState();
}

class _PaypalScreenState extends State<PaypalScreen>
{
  late final WebViewController _controller;
  bool _cargando    = true;
  bool _procesando  = false;

  @override
  void initState()
  {
    super.initState();
    _initWebView();
  }

  void _initWebView()
  {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted:  (_) => setState(() => _cargando = true),
          onPageFinished: (_) => setState(() => _cargando = false),
          onNavigationRequest: (request)
          {
            final url = request.url;

            // PayPal redirige a return_url con PayerID cuando el usuario aprueba
            if (url.contains('PayerID') || url.startsWith('https://example.com/paypal-success')) {
              _onPagoAprobado();
              return NavigationDecision.prevent;
            }

            // PayPal redirige a cancel_url solo cuando el usuario cancela explicitamente
            if (url.startsWith('https://example.com/paypal-cancel')) {
              _onPagoCancelado();
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onWebResourceError: (_)
          {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:         Text('Error al cargar la pagina de pago'),
                  backgroundColor: AppColors.darkSlate,
                ),
              );
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.approvalUrl));
  }

  // ── APROBADO: capturar en backend ──────────────────────────

  Future<void> _onPagoAprobado() async
  {
    if (_procesando) return;
    setState(() => _procesando = true);

    try {
      await ApiClient.instance.post(
        ApiRoutes.confirmarPagoPaypal,
        data: {'order_id': widget.orderId},
      );

      // Invalida cache para que los gates recarguen el nuevo plan
      SuscripcionService.invalidar();

      if (!mounted) return;
      _mostrarDialogoExito();
    } catch (_) {
      if (!mounted) return;
      setState(() => _procesando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:         Text('El pago fue aprobado pero ocurrio un error al confirmarlo. Contacta a soporte.'),
          backgroundColor: AppColors.warningOrange,
          behavior:        SnackBarBehavior.floating,
          duration:        Duration(seconds: 6),
        ),
      );
    }
  }

  // ── CANCELADO: notificar backend ──────────────────────────

  Future<void> _onPagoCancelado() async
  {
    try {
      await ApiClient.instance.post(
        ApiRoutes.cancelarPagoPaypal,
        data: {'order_id': widget.orderId},
      );
    } catch (_) {}

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:         Text('Pago cancelado'),
        backgroundColor: AppColors.darkSlate,
        behavior:        SnackBarBehavior.floating,
      ),
    );
    Navigator.of(context).pop(false);
  }

  // ── DIALOGO DE EXITO ──────────────────────────────────────

  void _mostrarDialogoExito()
  {
    showDialog(
      context:            context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.baseSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        ),
        title: Text(
          'Pago exitoso',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: AppSizes.fontTitle,
            color:    AppColors.deepNavy,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.successGreen, size: 64),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              'Tu suscripcion al ${widget.planNombre} por ${widget.monto} fue procesada correctamente.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.neutralGrey,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: ()
            {
              Navigator.of(context).pop(); // cierra el dialogo
              Navigator.of(context).pop(true); // regresa true a SuscripcionScreen
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryCoral),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  // ── BUILD ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:      const Icon(Icons.close_rounded),
          onPressed: _procesando ? null : _mostrarDialogoCancelar,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pago seguro'),
            Text(
              '${widget.planNombre} — ${widget.monto}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.neutralGrey,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_cargando || _procesando)
            Container(
              color: _procesando ? Colors.black38 : Colors.transparent,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primaryCoral),
              ),
            ),
        ],
      ),
    );
  }

  void _mostrarDialogoCancelar()
  {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.baseSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        ),
        title: Text(
          'Cancelar pago',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: AppSizes.fontTitle, color: AppColors.deepNavy,
          ),
        ),
        content: Text(
          'Si cierras esta pantalla el pago no sera procesado.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.neutralGrey,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Continuar pago',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.headingDark, fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: ()
            {
              Navigator.of(context).pop();
              _onPagoCancelado();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.actionRed),
            child: const Text('Cancelar pago'),
          ),
        ],
      ),
    );
  }
}
