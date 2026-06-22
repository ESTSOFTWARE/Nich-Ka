class FermentationReportResponseDto {
  final int id;
  final int sessionId;
  final double? efficiency;
  final double initialSugar;
  final double? finalSugar;
  final double? ethanolDetected;
  final double? theoreticalEthanol;
  final String? generatedAt;
  final String? notes;

  final double? phInitial;
  final double? phFinal;
  final double? phLastReading;

  final double? temperatureInitial;
  final double? temperatureFinal;
  final double? temperatureLastReading;

  final double? alcoholInitial;
  final double? alcoholFinal;
  final double? alcoholLastReading;

  final double? conductivityInitial;
  final double? conductivityFinal;
  final double? conductivityLastReading;

  final double? turbidityInitial;
  final double? turbidityFinal;
  final double? turbidityLastReading;

  final double? densityInitial;
  final double? densityFinal;
  final double? densityLastReading;

  final double? rpmInitial;
  final double? rpmFinal;
  final double? rpmLastReading;

  const FermentationReportResponseDto({
    required this.id,
    required this.sessionId,
    this.efficiency,
    required this.initialSugar,
    this.finalSugar,
    this.ethanolDetected,
    this.theoreticalEthanol,
    this.generatedAt,
    this.notes,
    this.phInitial,
    this.phFinal,
    this.phLastReading,
    this.temperatureInitial,
    this.temperatureFinal,
    this.temperatureLastReading,
    this.alcoholInitial,
    this.alcoholFinal,
    this.alcoholLastReading,
    this.conductivityInitial,
    this.conductivityFinal,
    this.conductivityLastReading,
    this.turbidityInitial,
    this.turbidityFinal,
    this.turbidityLastReading,
    this.densityInitial,
    this.densityFinal,
    this.densityLastReading,
    this.rpmInitial,
    this.rpmFinal,
    this.rpmLastReading,
  });

  factory FermentationReportResponseDto.fromJson(Map<String, dynamic> json) =>
      FermentationReportResponseDto(
        id: json['id'] as int,
        sessionId: json['session_id'] as int,
        efficiency: (json['efficiency'] as num?)?.toDouble(),
        initialSugar: (json['initial_sugar'] as num?)?.toDouble() ?? 0.0,
        finalSugar: (json['final_sugar'] as num?)?.toDouble(),
        ethanolDetected: (json['ethanol_detected'] as num?)?.toDouble(),
        theoreticalEthanol: (json['theoretical_ethanol'] as num?)?.toDouble(),
        generatedAt: json['generated_at'] as String?,
        notes: json['notes'] as String?,
        phInitial: (json['ph_initial'] as num?)?.toDouble(),
        phFinal: (json['ph_final'] as num?)?.toDouble(),
        phLastReading: (json['ph_last_reading'] as num?)?.toDouble(),
        temperatureInitial: (json['temperature_initial'] as num?)?.toDouble(),
        temperatureFinal: (json['temperature_final'] as num?)?.toDouble(),
        temperatureLastReading: (json['temperature_last_reading'] as num?)
            ?.toDouble(),
        alcoholInitial: (json['alcohol_initial'] as num?)?.toDouble(),
        alcoholFinal: (json['alcohol_final'] as num?)?.toDouble(),
        alcoholLastReading: (json['alcohol_last_reading'] as num?)?.toDouble(),
        conductivityInitial: (json['conductivity_initial'] as num?)?.toDouble(),
        conductivityFinal: (json['conductivity_final'] as num?)?.toDouble(),
        conductivityLastReading: (json['conductivity_last_reading'] as num?)
            ?.toDouble(),
        turbidityInitial: (json['turbidity_initial'] as num?)?.toDouble(),
        turbidityFinal: (json['turbidity_final'] as num?)?.toDouble(),
        turbidityLastReading: (json['turbidity_last_reading'] as num?)
            ?.toDouble(),
        densityInitial: (json['density_initial'] as num?)?.toDouble(),
        densityFinal: (json['density_final'] as num?)?.toDouble(),
        densityLastReading: (json['density_last_reading'] as num?)?.toDouble(),
        rpmInitial: (json['rpm_initial'] as num?)?.toDouble(),
        rpmFinal: (json['rpm_final'] as num?)?.toDouble(),
        rpmLastReading: (json['rpm_last_reading'] as num?)?.toDouble(),
      );
}
