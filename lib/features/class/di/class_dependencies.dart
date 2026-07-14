import '../../../core/network/http_client.dart';
import '../data/datasource/remote/class_remote_datasource.dart';
import '../data/repositories/class_repository_impl.dart';
import '../domain/use_cases/get_class_fermentations_use_case.dart';
import '../domain/use_cases/get_classes_use_case.dart';
import '../domain/use_cases/join_class_use_case.dart';

class ClassDependencies {
  ClassDependencies._();

  static final ClassRemoteDataSource _dataSource = ClassRemoteDataSource(
    HttpClient.instance,
  );

  static final ClassRepositoryImpl _repository = ClassRepositoryImpl(
    remote: _dataSource,
  );

  static GetClassesUseCase get getClasses => GetClassesUseCase(_repository);

  static JoinClassUseCase get joinClass => JoinClassUseCase(_repository);

  static GetClassFermentationsUseCase get getFermentations =>
      GetClassFermentationsUseCase(_repository);
}
