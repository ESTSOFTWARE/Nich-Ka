import '../entities/class_fermentation.dart';
import '../repositories/class_repository.dart';

class GetClassFermentationsUseCase {
  final ClassRepository _repository;

  const GetClassFermentationsUseCase(this._repository);

  Future<List<ClassFermentation>> call(int groupId) =>
      _repository.getFermentations(groupId);
}
