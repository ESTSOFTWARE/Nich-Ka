import '../entities/report_item.dart';
import '../entities/report_period_filter.dart';
import '../repositories/reports_repository.dart';

class GetReportsUseCase {
  final ReportsRepository _repository;

  const GetReportsUseCase(this._repository);

  Future<List<ReportItem>> call(ReportPeriodFilter filter) =>
      _repository.getReports(filter);
}
