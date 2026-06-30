import '../network/http_client.dart';
import '../../features/fermentation/data/datasource/remote/active_fermentation_datasource.dart';
import '../../features/fermentation/data/repositories/active_fermentation_repository_impl.dart';
import '../../features/fermentation/domain/use_cases/get_active_fermentation_use_case.dart';

/// Decide a dónde entrar tras iniciar sesión:
///   - hay fermentación activa  → '/overview'
///   - no hay                   → '/' (home)
/// Ante cualquier error cae a '/' para no bloquear el ingreso.
Future<String> resolveEntryRoute() async {
  try {
    final active = await GetActiveFermentationUseCase(
      ActiveFermentationRepositoryImpl(
        ActiveFermentationDatasource(HttpClient.instance),
      ),
    ).call();
    return active != null ? '/overview' : '/';
  } catch (_) {
    return '/';
  }
}
