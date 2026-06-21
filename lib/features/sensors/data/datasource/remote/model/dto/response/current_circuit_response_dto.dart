class CurrentCircuitResponseDto {
  final int? circuitId;

  const CurrentCircuitResponseDto({required this.circuitId});

  factory CurrentCircuitResponseDto.fromJson(Map<String, dynamic> json) =>
      CurrentCircuitResponseDto(circuitId: json['circuit_id'] as int?);
}
