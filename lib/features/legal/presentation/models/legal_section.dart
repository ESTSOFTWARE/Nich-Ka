/// Responsabilidad única: representar una sección numerada de un documento
/// legal (número, título y cuerpo).
class LegalSection {
  final String number;
  final String title;
  final String body;

  const LegalSection({
    required this.number,
    required this.title,
    required this.body,
  });
}
