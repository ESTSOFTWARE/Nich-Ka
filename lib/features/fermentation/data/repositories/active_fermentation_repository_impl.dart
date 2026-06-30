import '../../domain/entities/active_fermentation_session.dart';
import '../../domain/repositories/active_fermentation_repository.dart';
import '../datasource/remote/active_fermentation_datasource.dart';

class ActiveFermentationRepositoryImpl implements ActiveFermentationRepository {
  final ActiveFermentationDatasource _datasource;

  const ActiveFermentationRepositoryImpl(this._datasource);

  @override
  Future<ActiveFermentationSession?> getActive() async {
    final dto = await _datasource.fetchActive();
    if (dto == null) return null;

    return ActiveFermentationSession(
      id: dto.id,
      circuitId: dto.circuitId,
      groupId: dto.groupId,
      scheduledStart: _parseUtc(dto.scheduledStart),
      scheduledEnd: _parseUtc(dto.scheduledEnd),
      actualStart: dto.actualStart != null ? _parseUtc(dto.actualStart!) : null,
      status: dto.status,
    );
  }

  /// El backend guarda las fechas como UTC sin zona (ej. "2026-06-23T07:32:00").
  /// `DateTime.parse` las tomaría como locales; las forzamos a UTC.
  DateTime _parseUtc(String raw) {
    final d = DateTime.parse(raw);
    if (d.isUtc) return d;
    return DateTime.utc(
      d.year,
      d.month,
      d.day,
      d.hour,
      d.minute,
      d.second,
      d.millisecond,
    );
  }
}
