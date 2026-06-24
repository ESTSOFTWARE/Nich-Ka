enum ReportStatus { nuevo, completado, interrumpida }

class ReportItem {
  final String id;
  final String variety;
  final String process;
  final String date;
  final String duration;
  final double? efficiency;
  final ReportStatus status;

  const ReportItem({
    required this.id,
    required this.variety,
    required this.process,
    required this.date,
    required this.duration,
    this.efficiency,
    required this.status,
  });

  String get title {
    final v = variety.trim();
    final p = process.trim();
    if (v.isEmpty && p.isEmpty) return 'Fermentación $id';
    if (p.isEmpty) return v;
    if (v.isEmpty) return p;
    return '$v · $p';
  }

  bool get isInterrupted => status == ReportStatus.interrumpida;
  bool get isNew => status == ReportStatus.nuevo;
  bool get isCompleted => status == ReportStatus.completado;
}
