import '../../domain/entities/fermentation_card.dart';
import '../../domain/entities/dashboard_stat.dart';
import '../components/time_range.dart';
import '../../../sensors/domain/entities/sensor_reading.dart';

class OverviewState {
  final bool isLoading;
  final List<SensorReading> readings;
  final TimeRange selectedRange;
  final List<DashboardStat> stats;
  final List<FermentationCard> fermentationCards;
  final String? error;

  const OverviewState({
    this.isLoading = true,
    this.readings = const [],
    this.selectedRange = TimeRange.twentyFourHours,
    this.stats = const [],
    this.fermentationCards = const [],
    this.error,
  });

  OverviewState copyWith({
    bool? isLoading,
    List<SensorReading>? readings,
    TimeRange? selectedRange,
    List<DashboardStat>? stats,
    List<FermentationCard>? fermentationCards,
    String? error,
    bool clearError = false,
  }) => OverviewState(
    isLoading: isLoading ?? this.isLoading,
    readings: readings ?? this.readings,
    selectedRange: selectedRange ?? this.selectedRange,
    stats: stats ?? this.stats,
    fermentationCards: fermentationCards ?? this.fermentationCards,
    error: clearError ? null : (error ?? this.error),
  );
}
