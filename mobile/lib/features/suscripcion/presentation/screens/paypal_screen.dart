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
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/config/app_router.dart';

class PaypalScreen extends StatefulWidget
{
  final String approvalUrl;
  final String planNombre;
  final String monto;

  const PaypalScreen({
    super.key,
    required this.approvalUrl,
    required this.planNombre,
    required this.monto,
  });

  @override
  State<PaypalScreen> createState() => _PaypalScreenState();
}

class _PaypalScreenState extends State<PaypalScreen>
{
  late final WebViewController _controller;
  bool _cargando = true;

  // URL de retorno exitoso y cancelacion del sandbox de PayPal
  static const _urlExito      = 'https://example.com/paypal-success';
  static const _urlCancelacion = 'https://example.com/paypal-cancel';

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
          onPageStarted: (_) => setState(() => _cargando = true),
          onPageFinished: (_) => setState(() => _cargando = false),
          onNavigationRequest: (request)
          {
            final url = request.url;

            if (url.contains(_urlExito) || url.contains('paypal-success') || url.contains('PayerID')) {
              _onPagoExitoso();
              return NavigationDecision.prevent;
            }

            if (url.contains(_urlCancelacion) || url.contains('paypal-cancel') || url.contains('token') && url.contains('cancel')) {
              _onPagoCancelado();
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onWebResourceError: (error)
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

  void _onPagoExitoso()
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
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.successGreen,
              size:  64,
            ),
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
              Navigator.of(context).pop();
              context.go(AppRouter.homeDocente);
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  void _onPagoCancelado()
  {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:         Text('Pago cancelado'),
        backgroundColor: AppColors.darkSlate,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: ()
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
                    fontSize: AppSizes.fontTitle,
                    color:    AppColors.deepNavy,
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
                        color:      AppColors.headingDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: ()
                    {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.actionRed,
                    ),
                    child: const Text('Cancelar pago'),
                  ),
                ],
              ),
            );
          },
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
          if (_cargando)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primaryCoral),
            ),
        ],
      ),
    );
  }
}