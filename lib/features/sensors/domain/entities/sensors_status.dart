class SensorsStatus {
  final int online;
  final int total;
  final bool allInRange;
  final String statusLabel;
  final String fermentationId;
  final String variety;

  const SensorsStatus({
    required this.online,
    required this.total,
    required this.allInRange,
    required this.statusLabel,
    required this.fermentationId,
    required this.variety,
  });
}
