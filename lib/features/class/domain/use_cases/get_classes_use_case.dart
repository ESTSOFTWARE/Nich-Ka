import '../entities/class_detail.dart';
import '../repositories/class_repository.dart';

class GetClassesUseCase {
  final ClassRepository _repository;

  const GetClassesUseCase(this._repository);

  Future<List<ClassDetail>> call() => _repository.getClasses();
}
