import '../entities/profile_user.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository _repository;

  const GetProfileUseCase(this._repository);

  Future<ProfileUser> call() => _repository.getCurrentUser();
}
