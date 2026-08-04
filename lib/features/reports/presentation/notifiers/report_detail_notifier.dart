import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/network/http_client.dart';
import '../../../../core/push/push_service.dart';
import '../../data/datasource/remote/reports_remote_datasource.dart';
import '../../data/repositories/reports_repository_impl.dart';
import '../../domain/use_cases/download_report_pdf_use_case.dart';
import '../../domain/use_cases/get_report_detail_use_case.dart';
import '../states/ui_state.dart';
import 'report_detail_state.dart';

/// Family sobre el sessionId: cada reporte tiene su propia instancia.
class ReportDetailNotifier extends FamilyNotifier<ReportDetailState, int?> {
  final ScrollController scrollController = ScrollController();

  late final GetReportDetailUseCase _getDetail;
  late final DownloadReportPdfUseCase _downloadPdf;
  int? _sessionId;

  @override
  ReportDetailState build(int? sessionId) {
    _sessionId = sessionId;
    final repo = ReportsRepositoryImpl(
      ReportsRemoteDataSource(HttpClient.instance),
    );
    _getDetail = GetReportDetailUseCase(repo);
    _downloadPdf = DownloadReportPdfUseCase(repo);

    scrollController.addListener(_onScroll);
    ref.onDispose(() {
      scrollController.removeListener(_onScroll);
      scrollController.dispose();
    });

    _loadDetail();
    return const ReportDetailState();
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != state.isScrolled) {
      state = state.copyWith(isScrolled: scrolled);
    }
  }

  Future<void> _loadDetail() async {
    if (_sessionId == null) {
      state = state.copyWith(
        detail: const UiError('No se identificó la sesión de fermentación.'),
      );
      return;
    }
    state = state.copyWith(detail: const UiLoading());
    try {
      final detail = await _getDetail(_sessionId!);
      state = state.copyWith(detail: UiSuccess(detail));
    } catch (e) {
      state = state.copyWith(
        detail: UiError(e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  Future<void> retry() => _loadDetail();

  void clearDownloadFlags() {
    state = state.copyWith(downloadError: null, downloadCompleted: false);
  }

  Future<void> downloadReportPdf() async {
    if (_sessionId == null) return;
    state = state.copyWith(
      isDownloading: true,
      downloadError: null,
      downloadCompleted: false,
    );
    try {
      final bytes = await _downloadPdf(_sessionId!);
      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'reporte_fermentacion_$_sessionId.pdf';
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);
      state = state.copyWith(isDownloading: false, downloadCompleted: true);
      await PushService.instance.showFileSaved(fileName, file.path);
    } catch (e) {
      state = state.copyWith(
        isDownloading: false,
        downloadError: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}

final reportDetailProvider =
    NotifierProvider.family<ReportDetailNotifier, ReportDetailState, int?>(
      ReportDetailNotifier.new,
    );
