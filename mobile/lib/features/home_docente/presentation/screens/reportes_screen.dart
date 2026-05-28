// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : reportes_screen.dart
// Created on : 27/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 27/04/2026 - Jorge Alejandro Martinez Toris - Pantalla de reportes
//   [002] 08/05/2026 - Jorge Alejandro Martinez Toris - Conexion real al backend
//   [003] 22/05/2026 - Jorge Alejandro Martinez Toris - Gate plan mensual
//   [004] 28/05/2026 - Jorge Alejandro Martinez Toris - Exportacion PDF y Excel
// ============================================================

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart' as xl;
import '../../../../core/connection/api_client.dart';
import '../../../../core/constants/api_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/services/suscripcion_service.dart';
import '../../../../core/widgets/plan_upgrade_widget.dart';
import '../../../../features/suscripcion/data/suscripcion_model.dart';
import '../../data/institucion_model.dart';
import '../../data/grupo_model.dart';
import '../../data/alumno_grupo_model.dart';

class ReportesScreen extends StatefulWidget
{
  const ReportesScreen({super.key});

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen>
{
  List<InstitucionModel> _instituciones   = [];
  List<GrupoModel>       _grupos          = [];
  List<AlumnoGrupoModel> _alumnos         = [];
  InstitucionModel?      _institucionSel;
  GrupoModel?            _grupoSel;
  bool                   _cargandoInst    = true;
  bool                   _cargandoGrupos  = false;
  bool                   _cargandoAlumnos = false;
  String?                _error;
  SuscripcionModel?      _suscripcion;

  @override
  void initState()
  {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async
  {
    _suscripcion = await SuscripcionService.obtener();
    if (mounted && (_suscripcion?.isMensual ?? false)) {
      _cargarInstituciones();
    } else if (mounted) {
      setState(() => _cargandoInst = false);
    }
  }

  Future<void> _cargarInstituciones() async
  {
    setState(() { _cargandoInst = true; _error = null; });
    try {
      final res = await ApiClient.instance.get(ApiRoutes.instituciones);
      setState(() {
        _instituciones = (res.data['data'] as List)
            .map((i) => InstitucionModel.fromJson(i as Map<String, dynamic>))
            .toList();
        _cargandoInst = false;
      });
    } catch (_) {
      setState(() { _cargandoInst = false; _error = 'Error al cargar instituciones.'; });
    }
  }

  Future<void> _cargarGrupos(InstitucionModel inst) async
  {
    setState(() { _cargandoGrupos = true; _grupos = []; _grupoSel = null; _alumnos = []; });
    try {
      final res = await ApiClient.instance.get(ApiRoutes.grupos(inst.id));
      setState(() {
        _grupos        = (res.data['data'] as List)
            .map((g) => GrupoModel.fromJson(g as Map<String, dynamic>))
            .toList();
        _cargandoGrupos = false;
      });
    } catch (_) {
      setState(() { _cargandoGrupos = false; });
    }
  }

  Future<void> _cargarAlumnos(GrupoModel grupo) async
  {
    setState(() { _cargandoAlumnos = true; _alumnos = []; });
    try {
      final res = await ApiClient.instance.get(ApiRoutes.alumnosGrupo(grupo.id));
      setState(() {
        _alumnos        = (res.data['data'] as List)
            .map((a) => AlumnoGrupoModel.fromJson(a as Map<String, dynamic>))
            .toList();
        _cargandoAlumnos = false;
      });
    } catch (_) {
      setState(() { _cargandoAlumnos = false; });
    }
  }

  Future<void> _exportarPDF() async
  {
    if (_grupoSel == null || _alumnos.isEmpty) return;

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin:     const pw.EdgeInsets.all(32),
        build: (pw.Context ctx) => [
          pw.Text(
            'Reporte de Asistencias',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Text('Institución: ${_institucionSel?.nombre ?? ''}'),
          pw.Text('Grupo: ${_grupoSel!.materia} - ${_grupoSel!.nombre}'),
          pw.SizedBox(height: 16),
          pw.Table.fromTextArray(
            headerStyle:    pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey100),
            cellAlignment:  pw.Alignment.centerLeft,
            headers: const ['Alumno', 'Asistencias', 'Total', '%'],
            data: _alumnos.map((a) => [
              '${a.nombre} ${a.apPat}',
              '${a.sesionesAsistidas}',
              '${a.totalSesiones}',
              '${a.porcentajeAsistencia.toStringAsFixed(0)}%',
            ]).toList(),
          ),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes:    await doc.save(),
      filename: 'reporte_${_grupoSel!.nombre}.pdf',
    );
  }

  Future<void> _exportarExcel() async
  {
    if (_grupoSel == null || _alumnos.isEmpty) return;

    final workbook = xl.Excel.createExcel();
    final sheet    = workbook['Asistencias'];
    workbook.delete('Sheet1');

    // Encabezados
    sheet.appendRow([
      xl.TextCellValue('Alumno'),
      xl.TextCellValue('Asistencias'),
      xl.TextCellValue('Total'),
      xl.TextCellValue('%'),
    ]);

    // Datos
    for (final a in _alumnos) {
      sheet.appendRow([
        xl.TextCellValue('${a.nombre} ${a.apPat}'),
        xl.IntCellValue(a.sesionesAsistidas),
        xl.IntCellValue(a.totalSesiones),
        xl.TextCellValue('${a.porcentajeAsistencia.toStringAsFixed(0)}%'),
      ]);
    }

    final bytes = workbook.save();
    if (bytes == null) return;

    final dir  = await getTemporaryDirectory();
    final path = '${dir.path}/reporte_${_grupoSel!.nombre}.xlsx';
    final file = File(path);
    await file.writeAsBytes(bytes);
    await OpenFile.open(path);
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
        title: const Text('Reportes'),
        actions: [
          if (_grupoSel != null && _alumnos.isNotEmpty) ...[
            IconButton(
              icon:    const Icon(Icons.picture_as_pdf_outlined),
              color:   AppColors.actionRed,
              tooltip: 'Exportar PDF',
              onPressed: _exportarPDF,
            ),
            IconButton(
              icon:    const Icon(Icons.table_chart_outlined),
              color:   AppColors.successGreen,
              tooltip: 'Exportar Excel',
              onPressed: _exportarExcel,
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: _cargandoInst
            ? const Center(child: CircularProgressIndicator(color: AppColors.primaryCoral))
            : !(_suscripcion?.isMensual ?? false)
            ? const PlanUpgradeWidget(
                icono:       '📊',
                titulo:      'Reportes — Plan Mensual',
                descripcion: 'Consulta el historial completo de asistencias de todos tus grupos y exporta reportes detallados.',
                beneficios:  [
                  'Historial completo por periodo',
                  'Estadisticas por alumno y grupo',
                  'Exportar a Excel y PDF',
                  'Aulas y grupos ilimitados',
                ],
              )
            : _error != null
            ? _buildError()
            : ListView(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          children: [
            _buildFiltros(),
            const SizedBox(height: AppSizes.paddingL),
            if (_grupoSel != null) ...[
              _buildResumen(),
              const SizedBox(height: AppSizes.paddingL),
              _buildTabla(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildError()
  {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_error!, style: const TextStyle(color: AppColors.actionRed)),
          const SizedBox(height: AppSizes.paddingM),
          ElevatedButton(onPressed: _cargarInstituciones, child: const Text('Reintentar')),
        ],
      ),
    );
  }

  Widget _buildFiltros()
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
            'Selecciona una institución y grupo',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600, color: AppColors.deepNavy,
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),

          // Dropdown instituciones
          DropdownButtonFormField<InstitucionModel>(
            value:       _institucionSel,
            hint:        const Text('Institución'),
            isExpanded:  true,
            decoration:  const InputDecoration(
              prefixIcon: Icon(Icons.business_outlined),
            ),
            items: _instituciones.map((i) => DropdownMenuItem(
              value: i,
              child: Text(i.nombre, overflow: TextOverflow.ellipsis),
            )).toList(),
            onChanged: (inst) {
              if (inst == null) return;
              setState(() { _institucionSel = inst; _grupoSel = null; _alumnos = []; });
              _cargarGrupos(inst);
            },
          ),

          if (_cargandoGrupos) ...[
            const SizedBox(height: AppSizes.paddingM),
            const LinearProgressIndicator(color: AppColors.primaryCoral),
          ],

          if (_grupos.isNotEmpty) ...[
            const SizedBox(height: AppSizes.paddingM),
            DropdownButtonFormField<GrupoModel>(
              value:      _grupoSel,
              hint:       const Text('Grupo'),
              isExpanded: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.group_outlined),
              ),
              items: _grupos.map((g) => DropdownMenuItem(
                value: g,
                child: Text('${g.materia} — ${g.nombre}', overflow: TextOverflow.ellipsis),
              )).toList(),
              onChanged: (g) {
                if (g == null) return;
                setState(() => _grupoSel = g);
                _cargarAlumnos(g);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResumen()
  {
    if (_cargandoAlumnos) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryCoral));
    }
    if (_alumnos.isEmpty) {
      return Center(
        child: Text(
          'Sin alumnos en este grupo.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.neutralGrey),
        ),
      );
    }

    final totalAlumnos = _alumnos.length;
    final aprobados    = _alumnos.where((a) => a.porcentajeAsistencia >= 80).length;
    final enRiesgo     = _alumnos.where((a) =>
    a.porcentajeAsistencia >= 60 && a.porcentajeAsistencia < 80).length;
    final reprobados   = _alumnos.where((a) => a.porcentajeAsistencia < 60).length;

    return Row(
      children: [
        _buildStatChip('Total',      '$totalAlumnos', AppColors.deepNavy,     null),
        const SizedBox(width: AppSizes.paddingS),
        _buildStatChip('Aprobados',  '$aprobados',    AppColors.successGreen,  '≥ 80%'),
        const SizedBox(width: AppSizes.paddingS),
        _buildStatChip('En riesgo',  '$enRiesgo',     AppColors.warningOrange, '60-79%'),
        const SizedBox(width: AppSizes.paddingS),
        _buildStatChip('Reprobados', '$reprobados',   AppColors.actionRed,     '< 60%'),
      ],
    );
  }

  Widget _buildStatChip(String label, String valor, Color color, String? rango)
  {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS, horizontal: 4),
        decoration: BoxDecoration(
          color:        color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusInput),
          border:       Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              valor,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color, fontWeight: FontWeight.w700, fontSize: AppSizes.fontH2,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color, fontSize: AppSizes.fontCaption, fontWeight: FontWeight.w600,
              ),
            ),
            if (rango != null)
              Text(
                rango,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color.withValues(alpha: 0.7), fontSize: 9,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabla()
  {
    if (_cargandoAlumnos || _alumnos.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color:        AppColors.baseSurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.surface),
      ),
      child: Column(
        children: [
          _buildEncabezado(),
          ..._alumnos.asMap().entries.map((e) => _buildFila(e.value, e.key.isEven)),
        ],
      ),
    );
  }

  Widget _buildEncabezado()
  {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM, vertical: AppSizes.paddingS,
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
          _th(context, 'Alumno',  flex: 3),
          _th(context, 'Asist.'),
          _th(context, 'Tot.'),
          _th(context, '%'),
        ],
      ),
    );
  }

  Widget _th(BuildContext context, String text, {int flex = 1})
  {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: flex == 3 ? TextAlign.left : TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600, color: AppColors.deepNavy,
        ),
      ),
    );
  }

  Widget _buildFila(AlumnoGrupoModel alumno, bool esImpar)
  {
    final pct   = alumno.porcentajeAsistencia;
    final color = pct >= 80
        ? AppColors.successGreen
        : pct >= 60
        ? AppColors.warningOrange
        : AppColors.actionRed;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM, vertical: AppSizes.paddingS,
      ),
      color: esImpar ? AppColors.baseSurface : AppColors.subtleWarm,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '${alumno.nombre} ${alumno.apPat}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onyxGrey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              '${alumno.sesionesAsistidas}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onyxGrey),
            ),
          ),
          Expanded(
            child: Text(
              '${alumno.totalSesiones}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onyxGrey),
            ),
          ),
          Expanded(
            child: Text(
              '${pct.toStringAsFixed(0)}%',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color, fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}