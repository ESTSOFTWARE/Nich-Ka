import 'package:flutter/material.dart';
import '../../data/datasource/local/reports_local_datasource.dart';
import '../../domain/entities/report_item.dart';
import '../../domain/entities/report_period_filter.dart';
import '../../domain/entities/reports_summary.dart';
import '../states/ui_state.dart';

class ReportsProvider extends ChangeNotifier {
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

  ReportsProvider() {
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
    _loadData();
  }

  Future<void> _loadData() async {
    _reportsState = const UiLoading();
    _summaryState = const UiLoading();
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));
      final reports = getMockReports(_selectedFilter);
      final summary = getMockSummary(_selectedFilter);
      _reportsState = UiSuccess(reports);
      _summaryState = UiSuccess(summary);
    } catch (e) {
      _reportsState = const UiError('No se pudieron cargar los reportes.');
      _summaryState = const UiError('No se pudo cargar el resumen.');
    }
    notifyListeners();
  }

  Future<void> refresh() => _loadData();

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
