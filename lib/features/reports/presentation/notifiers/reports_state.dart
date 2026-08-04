import '../../domain/entities/report_item.dart';
import '../../domain/entities/report_period_filter.dart';
import '../../domain/entities/reports_summary.dart';
import '../states/ui_state.dart';

/// Estado inmutable de la lista de reportes.
class ReportsState {
  final bool isScrolled;
  final ReportPeriodFilter selectedFilter;
  final UiState<List<ReportItem>> reportsState;
  final UiState<ReportsSummary> summaryState;
  final bool isDownloading;
  final String? downloadError;
  final bool downloadCompleted;

  const ReportsState({
    this.isScrolled = false,
    this.selectedFilter = ReportPeriodFilter.todos,
    this.reportsState = const UiLoading(),
    this.summaryState = const UiLoading(),
    this.isDownloading = false,
    this.downloadError,
    this.downloadCompleted = false,
  });

  // Centinela para distinguir "no cambiar" de "poner en null" en downloadError.
  static const Object _keep = Object();

  ReportsState copyWith({
    bool? isScrolled,
    ReportPeriodFilter? selectedFilter,
    UiState<List<ReportItem>>? reportsState,
    UiState<ReportsSummary>? summaryState,
    bool? isDownloading,
    Object? downloadError = _keep,
    bool? downloadCompleted,
  }) => ReportsState(
    isScrolled: isScrolled ?? this.isScrolled,
    selectedFilter: selectedFilter ?? this.selectedFilter,
    reportsState: reportsState ?? this.reportsState,
    summaryState: summaryState ?? this.summaryState,
    isDownloading: isDownloading ?? this.isDownloading,
    downloadError: identical(downloadError, _keep)
        ? this.downloadError
        : downloadError as String?,
    downloadCompleted: downloadCompleted ?? this.downloadCompleted,
  );
}
