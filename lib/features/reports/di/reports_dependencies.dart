import '../../../core/network/http_client.dart';
import '../data/datasource/remote/reports_remote_datasource.dart';
import '../data/repositories/reports_repository_impl.dart';
import '../domain/use_cases/download_report_pdf_use_case.dart';
import '../domain/use_cases/get_report_detail_use_case.dart';
import '../domain/use_cases/get_reports_summary_use_case.dart';
import '../domain/use_cases/get_reports_use_case.dart';

class ReportsDependencies {
  ReportsDependencies._();

  static final ReportsRemoteDataSource _dataSource = ReportsRemoteDataSource(
    HttpClient.instance,
  );

  static final ReportsRepositoryImpl _repository = ReportsRepositoryImpl(
    _dataSource,
  );

  static GetReportsUseCase get getReports => GetReportsUseCase(_repository);

  static GetReportDetailUseCase get getReportDetail =>
      GetReportDetailUseCase(_repository);

  static GetReportsSummaryUseCase get getSummary =>
      GetReportsSummaryUseCase(_repository);

  static DownloadReportPdfUseCase get downloadPdf =>
      DownloadReportPdfUseCase(_repository);
}
