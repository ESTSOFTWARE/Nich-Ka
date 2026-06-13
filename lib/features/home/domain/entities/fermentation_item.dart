class FermentationItem {
  final String id;
  final String name;
  final String process;
  final String dayInfo;
  final String status;

  const FermentationItem({
    required this.id,
    required this.name,
    required this.process,
    required this.dayInfo,
    required this.status,
  });

  String get subtitle => '$id · $dayInfo';
}
