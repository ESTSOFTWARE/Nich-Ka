import '../../../../core/network/http_client.dart';
import '../../domain/entities/class_detail.dart';
import '../../domain/entities/class_fermentation.dart';
import '../../domain/repositories/class_repository.dart';
import '../datasource/remote/class_remote_datasource.dart';

class ClassRepositoryImpl implements ClassRepository {
  final ClassRemoteDataSource _remote;

  ClassRepositoryImpl({ClassRemoteDataSource? remote})
    : _remote = remote ?? ClassRemoteDataSource(HttpClient.instance);

  @override
  Future<List<ClassDetail>> getClasses() => _remote.getClasses();

  @override
  Future<void> joinClass(String code) => _remote.joinClass(code);

  @override
  Future<List<ClassFermentation>> getFermentations(int groupId) =>
      _remote.getGroupSessions(groupId);
}
