import '../../domain/entities/class_item.dart';
import '../../domain/entities/class_summary.dart';
import '../../domain/repositories/class_repository.dart';
import '../datasource/local/class_local_datasource.dart';

class ClassRepositoryImpl implements ClassRepository {
  @override
  Future<List<ClassItem>> getClasses() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return getMockClasses();
  }

  @override
  Future<ClassSummary> getSummary() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return getMockSummary();
  }
}
