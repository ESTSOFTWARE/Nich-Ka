import '../entities/report_item.dart';
import '../entities/report_period_filter.dart';
import '../entities/reports_summary.dart';

abstract class ReportsRepository {
  Future<List<ReportItem>> getReports(ReportPeriodFilter filter);
  Future<ReportsSummary> getSummary(ReportPeriodFilter filter);
  Future<List<int>> downloadPdf(int sessionId);
}
