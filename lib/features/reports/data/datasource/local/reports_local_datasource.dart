import '../../../domain/entities/report_item.dart';
import '../../../domain/entities/report_period_filter.dart';
import '../../../domain/entities/reports_summary.dart';

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
