import '../entities/active_fermentation_session.dart';

abstract class ActiveFermentationRepository {
  /// Devuelve la fermentación activa, o `null` si no hay ninguna.
  Future<ActiveFermentationSession?> getActive();
}
