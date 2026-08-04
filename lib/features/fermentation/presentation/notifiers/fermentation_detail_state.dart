import 'package:flutter/material.dart';
import '../../../home/domain/entities/chart_point.dart';
import '../../../home/domain/entities/fermentation_metric.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../domain/entities/active_fermentation_session.dart';
import '../../domain/entities/fermentation_detail.dart';

class FermentationDetailState {
  final bool isScrolled;
  final bool isLoading;
  final ActiveFermentationSession? session;
  final Map<String, double> live;
  final List<double> tempHistory;

  const FermentationDetailState({
    this.isScrolled = false,
    this.isLoading = true,
    this.session,
    this.live = const {},
    this.tempHistory = const [],
  });

  bool get hasActive => session != null;

  FermentationMetric _metric(
    String label,
    String type,
    String unit,
    Color color, {
    int decimals = 1,
  }) {
    final v = live[type];
    return FermentationMetric(
      label: label,
      value: v != null ? v.toStringAsFixed(decimals) : '—',
      unit: unit,
      change: v != null ? 'en vivo' : 'sin datos',
      color: color,
    );
  }

  List<ChartPoint> get _tempChart {
    if (tempHistory.isEmpty) return const [];
    final maxV = tempHistory.reduce((a, b) => a > b ? a : b);
    final minV = tempHistory.reduce((a, b) => a < b ? a : b);
    final range = (maxV - minV).abs() < 0.001 ? 1.0 : (maxV - minV);
    final n = tempHistory.length;
    return [
      for (var i = 0; i < n; i++)
        ChartPoint(
          n == 1 ? 0.0 : i / (n - 1),
          ((tempHistory[i] - minV) / range).clamp(0.0, 1.0),
        ),
    ];
  }

  static String _fmt(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  /// Detalle del lote con datos REALES (sesión activa + sensores en vivo).
  FermentationDetail get detail {
    final s = session;
    final ph = _metric('PH', 'ph', '', AppPalette.metricCyan, decimals: 2);
    final density = _metric(
      'DENSIDAD',
      'density',
      '',
      AppPalette.accent,
      decimals: 3,
    );
    final alcohol = _metric('ALCOHOL', 'alcohol', '%', AppPalette.metricRed);
    final turbidity = _metric(
      'TURBIDEZ',
      'turbidity',
      'NTU',
      AppPalette.metricPurple,
      decimals: 0,
    );

    if (s == null) {
      return FermentationDetail(
        id: '—',
        variety: 'Sin fermentación',
        process: 'activa',
        tank: '',
        progress: 0,
        elapsed: '0h 0m',
        objectiveLabel: '',
        chartPoints: const [],
        ph: ph,
        density: density,
        alcohol: alcohol,
        turbidity: turbidity,
        events: const [],
      );
    }

    return FermentationDetail(
      id: 'F-${s.id.toString().padLeft(3, '0')}',
      variety: s.groupId != null ? 'Grupo ${s.groupId}' : 'Fermentación',
      process: s.isRunning ? 'En fermentación' : s.status,
      tank: 'Circuito #${s.circuitId}',
      progress: s.progress,
      elapsed: _fmt(s.elapsed),
      objectiveLabel: 'de ${_fmt(s.objective)} objetivo',
      chartPoints: _tempChart,
      ph: ph,
      density: density,
      alcohol: alcohol,
      turbidity: turbidity,
      events: const [],
    );
  }

  FermentationDetailState copyWith({
    bool? isScrolled,
    bool? isLoading,
    ActiveFermentationSession? session,
    bool clearSession = false,
    Map<String, double>? live,
    List<double>? tempHistory,
  }) => FermentationDetailState(
    isScrolled: isScrolled ?? this.isScrolled,
    isLoading: isLoading ?? this.isLoading,
    session: clearSession ? null : (session ?? this.session),
    live: live ?? this.live,
    tempHistory: tempHistory ?? this.tempHistory,
  );
}
