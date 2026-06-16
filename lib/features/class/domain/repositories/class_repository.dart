import '../entities/class_detail.dart';

abstract class ClassRepository {
  Future<List<ClassDetail>> getClasses();
  Future<void> joinClass(String code);
}
