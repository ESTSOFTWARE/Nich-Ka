import 'package:flutter/material.dart';
import '../../../domain/entities/nlp_analysis.dart';
import '../../../domain/entities/report_detail.dart';
import '../../../domain/entities/report_item.dart';
import '../../../domain/entities/report_period_filter.dart';
import '../../../domain/entities/reports_summary.dart';
import '../../../domain/entities/sensor_metric.dart';

const List<ReportItem> _allReports = [
  ReportItem(
    id: 'F-023',
    variety: 'Geisha',
    process: 'Honey',
    date: '12 may 2026',
    duration: '22h 14m',
    efficiency: 87.4,
    status: ReportStatus.nuevo,
  ),
  ReportItem(
    id: 'F-022',
    variety: 'Bourbon',
    process: 'Natural',
    date: '08 may 2026',
    duration: '26h 02m',
    efficiency: 84.1,
    status: ReportStatus.completado,
  ),
  ReportItem(
    id: 'F-021',
    variety: 'Typica',
    process: 'Lavado',
    date: '02 may 2026',
    duration: '20h 48m',
    efficiency: 79.6,
    status: ReportStatus.completado,
  ),
  ReportItem(
    id: 'F-020',
    variety: 'SL-28',
    process: 'Honey',
    date: '28 abr 2026',
    duration: '—',
    efficiency: null,
    status: ReportStatus.interrumpida,
  ),
  ReportItem(
    id: 'F-019',
    variety: 'Caturra',
    process: 'Lavado',
    date: '22 abr 2026',
    duration: '23h 41m',
    efficiency: 82.7,
    status: ReportStatus.completado,
  ),
];

const List<ReportItem> _semanaReports = [
  ReportItem(
    id: 'F-023',
    variety: 'Geisha',
    process: 'Honey',
    date: '12 may 2026',
    duration: '22h 14m',
    efficiency: 87.4,
    status: ReportStatus.nuevo,
  ),
  ReportItem(
    id: 'F-022',
    variety: 'Bourbon',
    process: 'Natural',
    date: '08 may 2026',
    duration: '26h 02m',
    efficiency: 84.1,
    status: ReportStatus.completado,
  ),
];

const List<ReportItem> _mesReports = [
  ReportItem(
    id: 'F-023',
    variety: 'Geisha',
    process: 'Honey',
    date: '12 may 2026',
    duration: '22h 14m',
    efficiency: 87.4,
    status: ReportStatus.nuevo,
  ),
  ReportItem(
    id: 'F-022',
    variety: 'Bourbon',
    process: 'Natural',
    date: '08 may 2026',
    duration: '26h 02m',
    efficiency: 84.1,
    status: ReportStatus.completado,
  ),
  ReportItem(
    id: 'F-021',
    variety: 'Typica',
    process: 'Lavado',
    date: '02 may 2026',
    duration: '20h 48m',
    efficiency: 79.6,
    status: ReportStatus.completado,
  ),
];

List<ReportItem> getMockReports(ReportPeriodFilter filter) {
  switch (filter) {
    case ReportPeriodFilter.todos:
      return _allReports;
    case ReportPeriodFilter.estaSemana:
      return _semanaReports;
    case ReportPeriodFilter.esteMes:
      return _mesReports;
    case ReportPeriodFilter.anio:
      return _allReports;
  }
}

ReportsSummary getMockSummary(ReportPeriodFilter filter) {
  final reports = getMockReports(filter);
  final withEfficiency = reports.where((r) => r.efficiency != null).toList();
  final avg = withEfficiency.isEmpty
      ? 0.0
      : withEfficiency.fold(0.0, (sum, r) => sum + r.efficiency!) /
            withEfficiency.length;
  final completed = reports
      .where((r) => r.status == ReportStatus.completado)
      .length;
  return ReportsSummary(
    avgEfficiency: avg,
    total: reports.length,
    completed: completed,
  );
}

ReportDetail getMockReportDetail() {
  return const ReportDetail(
    reportNumber: '142',
    fermentationCode: 'F-023',
    batchName: 'Geisha Honey',
    date: '12 may 2026',
    efficiency: 87.4,
    ethanolDetected: 8.2,
    ethanolTheoretical: 9.4,
    duration: '22h 14m',
    nlpAnalysis: NlpAnalysis(
      title: 'Análisis NLP',
      summary:
          'La fermentación mostró una **caída controlada de pH** (5.2 → 3.8) y una '
          'producción de alcohol consistente. La densidad cayó de 1.064 a 0.998, '
          'consistente con conversión casi completa de azúcares. Eficiencia final '
          'del **87.4%**, por encima del promedio histórico.',
      interpretation:
          'Los resultados indican una fermentación controlada y eficiente. El perfil '
          'sensorial esperado es de alta calidad con notas frutales pronunciadas, '
          'acidez media y cuerpo sedoso. Se recomienda continuar con el proceso '
          'de secado siguiendo los protocolos estándar.',
      observations:
          'Se detectó una leve variación de temperatura (+1.2°C) en la hora 14, '
          'la cual se corrigió automáticamente mediante el sistema de control. '
          'No se requiere intervención adicional. El lote presenta potencial '
          'para clasificación de especialidad.',
    ),
    sensorMetrics: [
      SensorMetric(
        label: 'Temperatura',
        initialValue: '23.0 °C',
        finalValue: '24.8 °C',
        lastValue: '22.4 °C',
        unit: '°C',
        valueColor: Color(0xFFF0A646),
        icon: Icons.thermostat_outlined,
      ),
      SensorMetric(
        label: 'pH',
        initialValue: '5.20',
        finalValue: '3.80',
        lastValue: '4.20',
        unit: '',
        valueColor: Color(0xFF86CDFF),
        icon: Icons.science_outlined,
      ),
      SensorMetric(
        label: 'Alcohol',
        initialValue: '0.0 %',
        finalValue: '8.2 %',
        lastValue: '6.4 %',
        unit: '%',
        valueColor: Color(0xFFFF9C8B),
        icon: Icons.liquor_outlined,
      ),
      SensorMetric(
        label: 'Densidad',
        initialValue: '1.064',
        finalValue: '0.998',
        lastValue: '1.024',
        unit: 'g/mL',
        valueColor: Color(0xFFA78BFA),
        icon: Icons.speed_outlined,
      ),
      SensorMetric(
        label: 'Turbidez',
        initialValue: '320 NTU',
        finalValue: '60 NTU',
        lastValue: '180 NTU',
        unit: 'NTU',
        valueColor: Color(0xFF75D079),
        icon: Icons.water_drop_outlined,
      ),
      SensorMetric(
        label: 'Conductividad',
        initialValue: '4.2 mS',
        finalValue: '2.1 mS',
        lastValue: '3.0 mS',
        unit: 'mS',
        valueColor: Color(0xFF60A5FA),
        icon: Icons.bolt_outlined,
      ),
      SensorMetric(
        label: 'RPM',
        initialValue: '120',
        finalValue: '120',
        lastValue: '120',
        unit: '',
        valueColor: Color(0xFF9CA3AF),
        icon: Icons.sync_outlined,
      ),
    ],
    generatedAt: '13 may, 09:18',
    downloads: 2,
    views: 4,
  );
}
