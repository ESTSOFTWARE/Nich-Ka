class SensorDataResponseDto {
  final String type;
  final String sensorType;
  final double value;

  const SensorDataResponseDto({
    required this.type,
    required this.sensorType,
    required this.value,
  });

  factory SensorDataResponseDto.fromJson(Map<String, dynamic> json) =>
      SensorDataResponseDto(
        type: json['type'] as String? ?? '',
        sensorType: json['sensor_type'] as String? ?? '',
        value: (json['value'] as num?)?.toDouble() ?? 0,
      );
}
