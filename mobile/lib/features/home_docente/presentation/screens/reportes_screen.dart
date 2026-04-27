// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : reportes_screen.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Pantalla de reportes bloqueada por plan
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/config/app_router.dart';

class ReportesScreen extends StatelessWidget
{
  const ReportesScreen({super.key});

  // Mock — cuando exista backend esto vendra del estado real del usuario
  static const bool _tienePlanMensual = true;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:      const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Reportes'),
      ),
      body: SafeArea(
        child: _tienePlanMensual
            ? _buildContenido(context)
            : _buildBloqueado(context),
      ),
    );
  }

  Widget _buildBloqueado(BuildContext context)
  {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              decoration: BoxDecoration(
                color:        AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusCard),
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size:  64,
                color: AppColors.neutralGrey,
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),
            Text(
              'Funcion exclusiva del Plan Mensual',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize:  AppSizes.fontTitle,
                color:     AppColors.deepNavy,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              'Los reportes de asistencia en Excel y PDF estan disponibles unicamente en el Plan Mensual.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.neutralGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingL),
            _buildListaBeneficios(context),
            const SizedBox(height: AppSizes.paddingXL),
            SizedBox(
              width:  double.infinity,
              height: AppSizes.heightButton,
              child:  ElevatedButton.icon(
                onPressed: () => context.push(AppRouter.suscripcion),
                icon:  const Icon(Icons.workspace_premium_rounded),
                label: const Text('Mejorar a Plan Mensual'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaBeneficios(BuildContext context)
  {
    const beneficios = [
      'Reportes por alumno, grupo y periodo',
      'Descarga en formato Excel y PDF',
      'Filtros por materia, grupo y periodo',
      'Considera justificantes aceptados',
    ];

    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color:        AppColors.cloudBlue,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
      ),
      child: Column(
        children: beneficios.map((b) => Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.paddingXS),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                size:  AppSizes.iconS,
                color: AppColors.successGreen,
              ),
              const SizedBox(width: AppSizes.paddingS),
              Expanded(
                child: Text(
                  b,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.deepNavy,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildContenido(BuildContext context)
  {
    return ListView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      children: [
        _buildFiltros(context),
        const SizedBox(height: AppSizes.paddingL),
        _buildTablaReporte(context),
        const SizedBox(height: AppSizes.paddingL),
        _buildBotonesDescarga(context),
      ],
    );
  }

  Widget _buildFiltros(BuildContext context)
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
          Text(
            'Filtros',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color:      AppColors.deepNavy,
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),
          _buildDropdownFiltro(context, 'Grupo',   'Todos los grupos'),
          const SizedBox(height: AppSizes.paddingM),
          _buildDropdownFiltro(context, 'Periodo', 'Ene-Jun 2026'),
          const SizedBox(height: AppSizes.paddingM),
          SizedBox(
            width:  double.infinity,
            height: AppSizes.heightButton,
            child:  ElevatedButton.icon(
              onPressed: () {},
              icon:  const Icon(Icons.filter_list_rounded),
              label: const Text('Aplicar filtros'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFiltro(
      BuildContext context,
      String       label,
      String       valorActual,
      )
  {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical:   AppSizes.paddingS,
      ),
      decoration: BoxDecoration(
        color:        AppColors.baseSurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusInput),
        border:       Border.all(color: AppColors.borderSky),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.steelBlue,
            ),
          ),
          Expanded(
            child: Text(
              valorActual,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:      AppColors.deepNavy,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.neutralGrey,
          ),
        ],
      ),
    );
  }

  Widget _buildTablaReporte(BuildContext context)
  {
    const datos = [
      {'alumno': 'Maria Garcia Torres',     'presentes': '18', 'faltas': '2', 'porcentaje': '90%'},
      {'alumno': 'Carlos Lopez Ramos',      'presentes': '15', 'faltas': '5', 'porcentaje': '75%'},
      {'alumno': 'Ana Martinez Vega',       'presentes': '10', 'faltas': '10','porcentaje': '50%'},
      {'alumno': 'Luis Hernandez Cruz',     'presentes': '20', 'faltas': '0', 'porcentaje': '100%'},
      {'alumno': 'Sofia Perez Diaz',        'presentes': '12', 'faltas': '8', 'porcentaje': '60%'},
    ];

    return Container(
      decoration: BoxDecoration(
        color:        AppColors.baseSurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.surface),
      ),
      child: Column(
        children: [
          _buildFilaEncabezado(context),
          ...datos.asMap().entries.map((entry) =>
              _buildFilaDato(context, entry.value, entry.key.isEven),
          ),
        ],
      ),
    );
  }

  Widget _buildFilaEncabezado(BuildContext context)
  {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical:   AppSizes.paddingS,
      ),
      decoration: const BoxDecoration(
        color: AppColors.headingSky,
        borderRadius: BorderRadius.only(
          topLeft:  Radius.circular(AppSizes.radiusCard),
          topRight: Radius.circular(AppSizes.radiusCard),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Alumno',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color:      AppColors.deepNavy,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Pres.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color:      AppColors.deepNavy,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Falt.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color:      AppColors.deepNavy,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '%',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color:      AppColors.deepNavy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilaDato(
      BuildContext              context,
      Map<String, String>       dato,
      bool                      esImpar,
      )
  {
    final pct    = int.tryParse(dato['porcentaje']!.replaceAll('%', '')) ?? 0;
    final color  = pct >= 80
        ? AppColors.successGreen
        : pct >= 60
        ? AppColors.warningOrange
        : AppColors.actionRed;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical:   AppSizes.paddingS,
      ),
      color: esImpar ? AppColors.baseSurface : AppColors.subtleWarm,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              dato['alumno']!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onyxGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              dato['presentes']!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onyxGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              dato['faltas']!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onyxGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              dato['porcentaje']!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:      color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonesDescarga(BuildContext context)
  {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: AppSizes.heightButton,
            child:  OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.table_chart_outlined),
              label: const Text('Descargar Excel'),
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
        const SizedBox(width: AppSizes.paddingM),
        Expanded(
          child: SizedBox(
            height: AppSizes.heightButton,
            child:  ElevatedButton.icon(
              onPressed: () {},
              icon:  const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('Descargar PDF'),
            ),
          ),
        ),
      ],
    );
  }
}