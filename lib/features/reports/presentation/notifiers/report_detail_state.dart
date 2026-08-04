import '../../domain/entities/report_detail.dart';
import '../states/ui_state.dart';

/// Estado inmutable del detalle de un reporte.
class ReportDetailState {
  final UiState<ReportDetail> detail;
  final bool isScrolled;
  final bool isDownloading;
  final String? downloadError;
  final bool downloadCompleted;

  const ReportDetailState({
    this.detail = const UiLoading(),
    this.isScrolled = false,
    this.isDownloading = false,
    this.downloadError,
    this.downloadCompleted = false,
  });

  static const Object _keep = Object();

  ReportDetailState copyWith({
    UiState<ReportDetail>? detail,
    bool? isScrolled,
    bool? isDownloading,
    Object? downloadError = _keep,
    bool? downloadCompleted,
  }) => ReportDetailState(
    detail: detail ?? this.detail,
    isScrolled: isScrolled ?? this.isScrolled,
    isDownloading: isDownloading ?? this.isDownloading,
    downloadError: identical(downloadError, _keep)
        ? this.downloadError
        : downloadError as String?,
    downloadCompleted: downloadCompleted ?? this.downloadCompleted,
  );
}
