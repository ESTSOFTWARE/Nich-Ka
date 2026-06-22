import '../entities/report_period_filter.dart';
import '../entities/reports_summary.dart';
import '../repositories/reports_repository.dart';

class GetReportsSummaryUseCase {
  final ReportsRepository _repository;

  const GetReportsSummaryUseCase(this._repository);

  Future<ReportsSummary> call(ReportPeriodFilter filter) =>
      _repository.getSummary(filter);
}
