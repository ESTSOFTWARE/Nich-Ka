class ClassFermentation {
  final String id;

  /// Id numérico de la sesión en el backend (para abrir su reporte).
  final int sessionId;
  final String variety;
  final String process;
  final bool isActive;

  const ClassFermentation({
    required this.id,
    required this.sessionId,
    required this.variety,
    required this.process,
    required this.isActive,
  });
}
