import '../../../core/network/http_client.dart';
import '../data/datasource/remote/profile_remote_datasource.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../domain/use_cases/get_profile_use_case.dart';
import '../domain/use_cases/upload_profile_image_use_case.dart';

class ProfileDependencies {
  ProfileDependencies._();

  static final ProfileRemoteDataSource _dataSource = ProfileRemoteDataSource(
    HttpClient.instance,
  );

  static final ProfileRepositoryImpl _repository = ProfileRepositoryImpl(
    _dataSource,
  );

  static GetProfileUseCase get getProfile => GetProfileUseCase(_repository);

  static UploadProfileImageUseCase get uploadProfileImage =>
      UploadProfileImageUseCase(_repository);
}
