import '../../../domain/entities/class_item.dart';
import '../../../domain/entities/class_summary.dart';

const _classes = [
  ClassItem(
    id: 'C-001',
    name: '5A Biotecnología 2026',
    subject: 'Biotecnología Agroindustrial',
    professor: 'Dorian Toledo',
    studentCount: 24,
    lastActivity: 'Hace 2 horas',
    hasUnread: true,
    unreadCount: 2,
    imageUrl: 'assets/img/logo_launcher.png',
  ),
  ClassItem(
    id: 'C-002',
    name: 'Procesos de fermentación',
    subject: 'Microbiología Aplicada',
    professor: 'Lucía Mendoza',
    studentCount: 18,
    lastActivity: 'Ayer',
    hasUnread: false,
    unreadCount: 0,
    imageUrl: 'assets/img/logo_launcher.png',
  ),
  ClassItem(
    id: 'C-003',
    name: 'Café especial Panamá',
    subject: 'Análisis Sensorial',
    professor: 'Marco Quiroz',
    studentCount: 31,
    lastActivity: 'Hace 3 días',
    hasUnread: false,
    unreadCount: 0,
    imageUrl: 'assets/img/logo_launcher.png',
  ),
  ClassItem(
    id: 'C-004',
    name: 'Programación en Dart',
    subject: 'Informática',
    professor: 'Ing. Carlos Mendoza',
    studentCount: 30,
    lastActivity: 'Hace 3 días',
    hasUnread: true,
    unreadCount: 5,
    imageUrl: 'assets/img/logo_launcher.png',
  ),
  ClassItem(
    id: 'C-005',
    name: 'Historia del Arte',
    subject: 'Arte',
    professor: 'Mtro. Ricardo Flores',
    studentCount: 18,
    lastActivity: 'Hace 5 horas',
    hasUnread: true,
    unreadCount: 1,
    imageUrl: 'assets/img/logo_launcher.png',
  ),
];

List<ClassItem> getMockClasses() => _classes;

ClassSummary getMockSummary() {
  final unread = _classes.where((c) => c.hasUnread).length;
  return ClassSummary(totalGroups: _classes.length, unreadItems: unread);
}