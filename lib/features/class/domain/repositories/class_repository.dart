import '../entities/class_item.dart';
import '../entities/class_summary.dart';

abstract class ClassRepository {
  Future<List<ClassItem>> getClasses();
  Future<ClassSummary> getSummary();
}
