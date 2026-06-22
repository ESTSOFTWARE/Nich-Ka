import '../entities/report_detail.dart';
import '../repositories/reports_repository.dart';

class GetReportDetailUseCase {
  final ReportsRepository _repository;

  const GetReportDetailUseCase(this._repository);

  Future<ReportDetail> call(int sessionId) =>
      _repository.getReportDetail(sessionId);
}
