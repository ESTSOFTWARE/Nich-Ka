import '../entities/class_detail.dart';
import '../repositories/class_repository.dart';

class JoinClassUseCase {
  final ClassRepository _repository;

  const JoinClassUseCase(this._repository);

  Future<ClassDetail> call(String code) => _repository.joinClass(code);
}
