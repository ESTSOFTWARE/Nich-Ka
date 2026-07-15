import 'package:flutter/material.dart';
import '../../domain/entities/active_fermentation.dart';
import '../../domain/entities/ai_recommendation.dart';
import '../../domain/entities/fermentation_item.dart';
import '../../domain/entities/fermentation_metric.dart';

class HomeState {
  final bool isLoading;
  final bool isPredicting;
  final ActiveFermentation active;
  final List<FermentationItem> fermentations;
  final AiRecommendation recommendation;
  final String? error;

  const HomeState({
    this.isLoading = true,
    this.isPredicting = false,
    this.active = const ActiveFermentation(
      id: '—',
      variety: 'Sin fermentación',
      process: 'activa',
      farm: '',
      tank: '',
      elapsed: Duration.zero,
      objective: Duration.zero,
      progressPercent: 0,
      chartPoints: [],
      temperature: FermentationMetric(
        label: 'TEMPERATURA',
        value: '—',
        unit: '°C',
        change: 'sin datos',
        color: Color(0xFFF0A646),
      ),
      alcohol: FermentationMetric(
        label: 'ALCOHOL',
        value: '—',
        unit: '%v/v',
        change: 'sin datos',
        color: Color(0xFFFF6B6B),
      ),
      conductivity: FermentationMetric(
        label: 'CONDUCTIVIDAD',
        value: '—',
        unit: 'mS/cm',
        change: 'sin datos',
        color: Color(0xFF14B8A6),
      ),
      turbidity: FermentationMetric(
        label: 'TURBIDEZ',
        value: '—',
        unit: 'NTU',
        change: 'sin datos',
        color: Color(0xFFA78BFA),
      ),
      ph: FermentationMetric(
        label: 'PH',
        value: '—',
        unit: '',
        change: 'sin datos',
        color: Color(0xFF4FA8E8),
      ),
      rpm: FermentationMetric(
        label: 'RPM MOTOR',
        value: '—',
        unit: 'rpm',
        change: 'sin datos',
        color: Color(0xFF14B8A6),
      ),
    ),
    this.fermentations = const [],
    this.recommendation = const AiRecommendation(
      body: 'Mantén la temperatura estable para una fermentación uniforme.',
      actionLabel: 'Ver análisis',
    ),
    this.error,
  });

  HomeState copyWith({
    bool? isLoading,
    bool? isPredicting,
    ActiveFermentation? active,
    List<FermentationItem>? fermentations,
    AiRecommendation? recommendation,
    String? error,
    bool clearError = false,
  }) => HomeState(
    isLoading: isLoading ?? this.isLoading,
    isPredicting: isPredicting ?? this.isPredicting,
    active: active ?? this.active,
    fermentations: fermentations ?? this.fermentations,
    recommendation: recommendation ?? this.recommendation,
    error: clearError ? null : (error ?? this.error),
  );
}
