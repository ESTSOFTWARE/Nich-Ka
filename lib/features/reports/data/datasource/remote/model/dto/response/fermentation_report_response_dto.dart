class FermentationReportResponseDto {
  final int id;
  final int sessionId;
  final double efficiency;
  final double initialSugar;
  final double finalSugar;
  final double ethanolDetected;
  final double theoreticalEthanol;
  final String generatedAt;
  final String? notes;

  const FermentationReportResponseDto({
    required this.id,
    required this.sessionId,
    required this.efficiency,
    required this.initialSugar,
    required this.finalSugar,
    required this.ethanolDetected,
    required this.theoreticalEthanol,
    required this.generatedAt,
    this.notes,
  });

  factory FermentationReportResponseDto.fromJson(Map<String, dynamic> json) =>
      FermentationReportResponseDto(
        id: json['id'] as int,
        sessionId: json['session_id'] as int,
        efficiency: (json['efficiency'] as num).toDouble(),
        initialSugar: (json['initial_sugar'] as num).toDouble(),
        finalSugar: (json['final_sugar'] as num).toDouble(),
        ethanolDetected: (json['ethanol_detected'] as num).toDouble(),
        theoreticalEthanol: (json['theoretical_ethanol'] as num).toDouble(),
        generatedAt: json['generated_at'] as String,
        notes: json['notes'] as String?,
      );
}
