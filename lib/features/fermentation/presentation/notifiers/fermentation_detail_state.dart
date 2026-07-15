import '../../domain/entities/active_fermentation_session.dart';

class FermentationDetailState {
  final bool isLoading;
  final ActiveFermentationSession? session;
  final Map<String, double> liveData;
  final List<double> tempHistory;
  final String? error;

  const FermentationDetailState({
    this.isLoading = true,
    this.session,
    this.liveData = const {},
    this.tempHistory = const [],
    this.error,
  });

  FermentationDetailState copyWith({
    bool? isLoading,
    ActiveFermentationSession? session,
    bool clearSession = false,
    Map<String, double>? liveData,
    List<double>? tempHistory,
    String? error,
    bool clearError = false,
  }) => FermentationDetailState(
    isLoading: isLoading ?? this.isLoading,
    session: clearSession ? null : (session ?? this.session),
    liveData: liveData ?? this.liveData,
    tempHistory: tempHistory ?? this.tempHistory,
    error: clearError ? null : (error ?? this.error),
  );
}
