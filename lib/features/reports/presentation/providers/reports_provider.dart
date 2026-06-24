import 'dart:io';
import 'package:flutter/material.dart';
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

class ReportsProvider extends ChangeNotifier {
  final GetReportsUseCase _getReports;
  final GetReportsSummaryUseCase _getSummary;
  final DownloadReportPdfUseCase _downloadPdf;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();

  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  ReportPeriodFilter _selectedFilter = ReportPeriodFilter.todos;
  ReportPeriodFilter get selectedFilter => _selectedFilter;

  UiState<List<ReportItem>> _reportsState = const UiLoading();
  UiState<List<ReportItem>> get reportsState => _reportsState;

  UiState<ReportsSummary> _summaryState = const UiLoading();
  UiState<ReportsSummary> get summaryState => _summaryState;

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  String? _downloadError;
  String? get downloadError => _downloadError;

  bool _downloadCompleted = false;
  bool get downloadCompleted => _downloadCompleted;

  ReportsProvider({
    GetReportsUseCase? getReports,
    GetReportsSummaryUseCase? getSummary,
    DownloadReportPdfUseCase? downloadPdf,
  }) : _getReports =
           getReports ??
           GetReportsUseCase(
             ReportsRepositoryImpl(
               ReportsRemoteDataSource(HttpClient.instance),
             ),
           ),
       _getSummary =
           getSummary ??
           GetReportsSummaryUseCase(
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
    scrollController.addListener(_onScroll);
    _loadData();
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      _isScrolled = scrolled;
      notifyListeners();
    }
  }

  void selectFilter(ReportPeriodFilter filter) {
    if (_selectedFilter == filter) return;
    _selectedFilter = filter;
    notifyListeners();
    _loadData(silent: true);
  }

  Future<void> _loadData({bool silent = false}) async {
    if (!silent) {
      _reportsState = const UiLoading();
      _summaryState = const UiLoading();
      notifyListeners();
    }

    try {
      final results = await Future.wait([
        _getReports(_selectedFilter),
        _getSummary(_selectedFilter),
      ]);
      _reportsState = UiSuccess(results[0] as List<ReportItem>);
      _summaryState = UiSuccess(results[1] as ReportsSummary);
    } catch (e) {
      _reportsState = const UiError('No se pudieron cargar los reportes.');
      _summaryState = const UiError('No se pudo cargar el resumen.');
    }
    notifyListeners();
  }

  Future<void> refresh() => _loadData();

  void clearDownloadFlags() {
    _downloadError = null;
    _downloadCompleted = false;
    notifyListeners();
  }

  Future<void> downloadReportPdf(int sessionId) async {
    _isDownloading = true;
    _downloadError = null;
    _downloadCompleted = false;
    notifyListeners();

    try {
      final bytes = await _downloadPdf(sessionId);
      final dir = Directory.systemTemp;
      final file = File('${dir.path}/reporte_fermentacion_$sessionId.pdf');
      await file.writeAsBytes(bytes);
      _isDownloading = false;
      _downloadCompleted = true;
      // Abre el PDF con el visor del sistema.
      await OpenFilex.open(file.path);
    } catch (e) {
      _isDownloading = false;
      _downloadError = e.toString().replaceFirst('Exception: ', '');
    }
    notifyListeners();
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
