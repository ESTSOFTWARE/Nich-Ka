import '../../domain/entities/report_detail.dart';
import '../../domain/entities/report_item.dart';
import '../../domain/entities/report_period_filter.dart';
import '../../domain/entities/reports_summary.dart';
import '../../domain/repositories/reports_repository.dart';
import '../datasource/remote/mapper/reports_detail_mapper.dart';
import '../datasource/remote/mapper/reports_mapper.dart';
import '../datasource/remote/model/dto/response/fermentation_report_response_dto.dart';
import '../datasource/remote/model/dto/response/fermentation_session_response_dto.dart';
import '../datasource/remote/model/dto/response/report_history_response_dto.dart';
import '../datasource/remote/reports_remote_datasource.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsRemoteDataSource _dataSource;

  const ReportsRepositoryImpl(this._dataSource);

  @override
  Future<List<ReportItem>> getReports(ReportPeriodFilter filter) async {
    final pairs = await _dataSource.getSessionsWithReports();

    final reports = pairs
        .map(
          (pair) => ReportsMapper.sessionToReportItem(
            session: pair.$1,
            report: pair.$2,
          ),
        )
        .toList();

    return ReportsMapper.filterByPeriod(reports, filter);
  }

  @override
  Future<ReportsSummary> getSummary(ReportPeriodFilter filter) async {
    final reports = await getReports(filter);
    return ReportsMapper.calculateSummary(reports);
  }

  @override
  Future<ReportDetail> getReportDetail(int sessionId) async {
    final results = await Future.wait([
      _dataSource.getSession(sessionId),
      _dataSource.getReport(sessionId),
      _dataSource.getHistory(),
    ]);

    return ReportsDetailMapper.toReportDetail(
      report: results[1] as FermentationReportResponseDto?,
      session: results[0] as FermentationSessionResponseDto,
      history: results[2] as List<ReportHistoryResponseDto>,
    );
  }

  @override
  Future<List<int>> downloadPdf(int sessionId) =>
      _dataSource.downloadPdf(sessionId);
}
