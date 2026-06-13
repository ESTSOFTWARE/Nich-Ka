class FermentationEvent {
  final String time;
  final String description;
  final bool isAiSuggestion;

  const FermentationEvent({
    required this.time,
    required this.description,
    this.isAiSuggestion = false,
  });
}
