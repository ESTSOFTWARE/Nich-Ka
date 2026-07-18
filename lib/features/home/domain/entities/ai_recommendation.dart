class AiRecommendation {
  final String body;
  final String actionLabel;

  /// Encabezado de la card. Las predicciones ML usan el suyo propio para no
  /// mostrarse como "Recomendación IA".
  final String title;

  /// true → estilo de predicción (morado); false → estilo por defecto (accent).
  final bool isPrediction;

  const AiRecommendation({
    required this.body,
    required this.actionLabel,
    this.title = 'RECOMENDACIÓN IA',
    this.isPrediction = false,
  });
}
