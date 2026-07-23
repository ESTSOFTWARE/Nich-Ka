import '../entities/class_detail.dart';

abstract class ClassRepository {
  Future<List<ClassDetail>> getClasses();
  Future<ClassDetail> joinClass(String code);
}
