import '../../domain/entities/profile_user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasource/remote/mapper/profile_mapper.dart';
import '../datasource/remote/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _dataSource;

  const ProfileRepositoryImpl(this._dataSource);

  @override
  Future<ProfileUser> getCurrentUser() async {
    final dto = await _dataSource.getCurrentUser();
    return ProfileMapper.fromUserProfileDto(dto);
  }
}
