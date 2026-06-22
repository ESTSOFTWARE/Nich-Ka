import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/network/http_client.dart';
import '../../data/datasource/remote/reports_remote_datasource.dart';
import '../../data/repositories/reports_repository_impl.dart';
import '../../domain/entities/report_detail.dart';
import '../../domain/use_cases/download_report_pdf_use_case.dart';
import '../../domain/use_cases/get_report_detail_use_case.dart';
import '../states/ui_state.dart';

class ReportDetailProvider extends ChangeNotifier {
  final GetReportDetailUseCase _getDetail;
  final DownloadReportPdfUseCase _downloadPdf;

  final int? sessionId;

  UiState<ReportDetail> _state = const UiLoading();
  UiState<ReportDetail> get state => _state;

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  String? _downloadError;
  String? get downloadError => _downloadError;

  bool _downloadCompleted = false;
  bool get downloadCompleted => _downloadCompleted;

  ReportDetailProvider({
    this.sessionId,
    GetReportDetailUseCase? getDetail,
    DownloadReportPdfUseCase? downloadPdf,
  }) : _getDetail =
           getDetail ??
           GetReportDetailUseCase(
             ReportsRepositoryImpl(
               ReportsRemoteDataSource(HttpClient.instance),
             ),
           ),
       _downloadPdf =
           downloadPdf ??
           DownloadReportPdfUseCase(
             ReportsRepositoryImpl(
               ReportsRemoteDataSource(HttpClient.instance),
             ),
           ) {
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    if (sessionId == null) {
      _state = const UiError('No se identificó la sesión de fermentación.');
      notifyListeners();
      return;
    }

    _state = const UiLoading();
    notifyListeners();

    try {
      final detail = await _getDetail(sessionId!);
      _state = UiSuccess(detail);
    } catch (e) {
      _state = UiError(e.toString().replaceFirst('Exception: ', ''));
    }
    notifyListeners();
  }

  Future<void> retry() => _loadDetail();

  void clearDownloadFlags() {
    _downloadError = null;
    _downloadCompleted = false;
    notifyListeners();
  }

  Future<void> downloadReportPdf() async {
    if (sessionId == null) return;

    _isDownloading = true;
    _downloadError = null;
    _downloadCompleted = false;
    notifyListeners();

    try {
      final bytes = await _downloadPdf(sessionId!);
      final dir = Directory.systemTemp;
      final file = File('${dir.path}/reporte_fermentacion_$sessionId.pdf');
      await file.writeAsBytes(bytes);
      _isDownloading = false;
      _downloadCompleted = true;
    } catch (e) {
      _isDownloading = false;
      _downloadError = e.toString().replaceFirst('Exception: ', '');
    }
    notifyListeners();
  }


}
