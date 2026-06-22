import '../repositories/reports_repository.dart';

class DownloadReportPdfUseCase {
  final ReportsRepository _repository;

  const DownloadReportPdfUseCase(this._repository);

  Future<List<int>> call(int sessionId) => _repository.downloadPdf(sessionId);
}
