import '../entities/class_detail.dart';
import '../entities/class_fermentation.dart';

abstract class ClassRepository {
  Future<List<ClassDetail>> getClasses();
  Future<void> joinClass(String code);
  Future<List<ClassFermentation>> getFermentations(int groupId);
}
