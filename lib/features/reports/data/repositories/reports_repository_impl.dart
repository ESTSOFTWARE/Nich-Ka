import '../../domain/entities/report_item.dart';
import '../../domain/entities/report_period_filter.dart';
import '../../domain/entities/reports_summary.dart';
import '../../domain/repositories/reports_repository.dart';
import '../datasource/remote/mapper/reports_mapper.dart';
import '../datasource/remote/reports_remote_datasource.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsRemoteDataSource _dataSource;

  const ReportsRepositoryImpl(this._dataSource);

  @override
  Future<List<ReportItem>> getReports(ReportPeriodFilter filter) async {
    final sessions = await _dataSource.getSessions();

    final reports = <ReportItem>[];
    for (final session in sessions) {
      final report = await _dataSource.getReport(session.id);
      reports.add(
        ReportsMapper.sessionToReportItem(session: session, report: report),
      );
    }

    return ReportsMapper.filterByPeriod(reports, filter);
  }

  @override
  Future<ReportsSummary> getSummary(ReportPeriodFilter filter) async {
    final reports = await getReports(filter);
    return ReportsMapper.calculateSummary(reports);
  }

  @override
  Future<List<int>> downloadPdf(int sessionId) =>
      _dataSource.downloadPdf(sessionId);
}
