import '../entities/report_detail.dart';
import '../entities/report_item.dart';
import '../entities/report_period_filter.dart';
import '../entities/reports_summary.dart';

abstract class ReportsRepository {
  Future<List<ReportItem>> getReports(ReportPeriodFilter filter);
  Future<ReportsSummary> getSummary(ReportPeriodFilter filter);
  Future<ReportDetail> getReportDetail(int sessionId);
  Future<List<int>> downloadPdf(int sessionId);
}
