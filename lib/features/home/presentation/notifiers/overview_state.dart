import 'package:flutter/material.dart';
import '../../../../features/fermentation/domain/entities/active_fermentation_session.dart';
import '../../../../features/sensors/domain/entities/sensor_reading.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../domain/entities/chart_point.dart';
import '../../domain/entities/dashboard_stat.dart';
import '../../domain/entities/fermentation_card.dart';
import '../components/time_range.dart';

class OverviewState {
  final bool isScrolled;
  final TimeRange selectedRange;
  final bool isLoading;
  final ActiveFermentationSession? session;
  final List<SensorReading> readings;

  const OverviewState({
    this.isScrolled = false,
    this.selectedRange = TimeRange.twentyFourHours,
    this.isLoading = true,
    this.session,
    this.readings = const [],
  });

  bool get hasActive => session != null;

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return '¡Buenos días!';
    if (hour < 19) return '¡Buenas tardes!';
    return '¡Buenas noches!';
  }

  String get loteLabel => session?.loteLabel ?? 'Sin lote activo';

  String get statusLabel {
    if (session == null) return 'Sin fermentación activa';
    return session!.isRunning ? 'En fermentación' : session!.status;
  }

  String get elapsedLabel =>
      session == null ? '—' : _fmtDuration(session!.elapsed);

  int get progressPercent =>
      session == null ? 0 : (session!.progress * 100).round();

  static String _fmtDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  SensorReading? _byId(String id) {
    for (final r in readings) {
      if (r.id == id) return r;
    }
    return null;
  }

  List<DashboardStat> get stats {
    if (session == null) {
      return const [
        DashboardStat(
          label: 'FERMENTACIONES ACTIVAS',
          value: '0',
          subtitle: 'sin actividad',
          color: AppPalette.metricCyan,
        ),
      ];
    }
    final temp = _byId('temp');
    final alcohol = _byId('alcohol');
    return [
      DashboardStat(
        label: 'ESTADO',
        value: 'Activa',
        subtitle: statusLabel,
        color: const Color(0xFF75D079),
      ),
      DashboardStat(
        label: 'TIEMPO',
        value: elapsedLabel,
        subtitle: 'transcurrido',
        color: AppPalette.metricOrange,
      ),
      DashboardStat(
        label: 'TEMPERATURA',
        value: temp != null ? '${temp.displayValue}°C' : '—',
        subtitle: 'en vivo',
        color: AppPalette.metricRed,
      ),
      DashboardStat(
        label: 'ALCOHOL',
        value: alcohol != null ? '${alcohol.displayValue}%' : '—',
        subtitle: 'en vivo',
        color: AppPalette.metricCyan,
      ),
    ];
  }

  List<ChartPoint> get chartPoints {
    final reading =
        _byId('alcohol') ?? (readings.isNotEmpty ? readings.first : null);
    if (reading == null || reading.history.isEmpty) return const [];
    final hist = reading.history;
    final maxV = hist.reduce((a, b) => a > b ? a : b);
    final denom = maxV <= 0 ? 1.0 : maxV;
    final n = hist.length;
    return [
      for (var i = 0; i < n; i++)
        ChartPoint(
          n == 1 ? 0.0 : i / (n - 1),
          (hist[i] / denom).clamp(0.0, 1.0),
        ),
    ];
  }

  List<FermentationCard> get fermentationCards {
    if (session == null) return const [];
    return [
      FermentationCard(
        id: session!.loteLabel,
        name: session!.groupId != null
            ? 'Grupo ${session!.groupId}'
            : 'Fermentación',
        stage: statusLabel,
        progress: session!.progress,
        ringColor: AppPalette.accent,
        sessionId: session!.id,
      ),
    ];
  }

  OverviewState copyWith({
    bool? isScrolled,
    TimeRange? selectedRange,
    bool? isLoading,
    ActiveFermentationSession? session,
    bool clearSession = false,
    List<SensorReading>? readings,
  }) => OverviewState(
    isScrolled: isScrolled ?? this.isScrolled,
    selectedRange: selectedRange ?? this.selectedRange,
    isLoading: isLoading ?? this.isLoading,
    session: clearSession ? null : (session ?? this.session),
    readings: readings ?? this.readings,
  );
}
