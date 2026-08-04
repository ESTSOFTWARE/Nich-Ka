import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import '../../../../core/network/http_client.dart';
import '../../data/datasource/remote/reports_remote_datasource.dart';
import '../../data/repositories/reports_repository_impl.dart';
import '../../domain/entities/report_item.dart';
import '../../domain/entities/report_period_filter.dart';
import '../../domain/entities/reports_summary.dart';
import '../../domain/use_cases/download_report_pdf_use_case.dart';
import '../../domain/use_cases/get_reports_summary_use_case.dart';
import '../../domain/use_cases/get_reports_use_case.dart';
import '../states/ui_state.dart';
import 'reports_state.dart';

class ReportsNotifier extends Notifier<ReportsState> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();

  late final GetReportsUseCase _getReports;
  late final GetReportsSummaryUseCase _getSummary;
  late final DownloadReportPdfUseCase _downloadPdf;

  @override
  ReportsState build() {
    final repo = ReportsRepositoryImpl(
      ReportsRemoteDataSource(HttpClient.instance),
    );
    _getReports = GetReportsUseCase(repo);
    _getSummary = GetReportsSummaryUseCase(repo);
    _downloadPdf = DownloadReportPdfUseCase(repo);

    scrollController.addListener(_onScroll);
    ref.onDispose(() {
      scrollController.removeListener(_onScroll);
      scrollController.dispose();
    });

    _loadData();
    return const ReportsState();
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != state.isScrolled) {
      state = state.copyWith(isScrolled: scrolled);
    }
  }

  void selectFilter(ReportPeriodFilter filter) {
    if (state.selectedFilter == filter) return;
    state = state.copyWith(selectedFilter: filter);
    _loadData(silent: true);
  }

  Future<void> _loadData({bool silent = false}) async {
    if (!silent) {
      state = state.copyWith(
        reportsState: const UiLoading(),
        summaryState: const UiLoading(),
      );
    }
    try {
      final results = await Future.wait([
        _getReports(state.selectedFilter),
        _getSummary(state.selectedFilter),
      ]);
      state = state.copyWith(
        reportsState: UiSuccess(results[0] as List<ReportItem>),
        summaryState: UiSuccess(results[1] as ReportsSummary),
      );
    } catch (e) {
      state = state.copyWith(
        reportsState: const UiError('No se pudieron cargar los reportes.'),
        summaryState: const UiError('No se pudo cargar el resumen.'),
      );
    }
  }

  Future<void> refresh() => _loadData();

  void clearDownloadFlags() {
    state = state.copyWith(downloadError: null, downloadCompleted: false);
  }

  Future<void> downloadReportPdf(int sessionId) async {
    state = state.copyWith(
      isDownloading: true,
      downloadError: null,
      downloadCompleted: false,
    );
    try {
      final bytes = await _downloadPdf(sessionId);
      final dir = Directory.systemTemp;
      final file = File('${dir.path}/reporte_fermentacion_$sessionId.pdf');
      await file.writeAsBytes(bytes);
      state = state.copyWith(isDownloading: false, downloadCompleted: true);
      await OpenFilex.open(file.path);
    } catch (e) {
      state = state.copyWith(
        isDownloading: false,
        downloadError: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}

final reportsProvider = NotifierProvider<ReportsNotifier, ReportsState>(
  ReportsNotifier.new,
);
