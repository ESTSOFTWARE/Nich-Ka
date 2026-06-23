import 'dart:io';
import '../repositories/profile_repository.dart';

class UploadProfileImageUseCase {
  final ProfileRepository _repository;

  const UploadProfileImageUseCase(this._repository);

  Future<String> call(File file) => _repository.uploadProfileImage(file);
}
