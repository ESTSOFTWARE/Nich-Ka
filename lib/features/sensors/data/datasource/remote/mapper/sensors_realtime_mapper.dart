import '../../../../domain/entities/sensor_realtime_reading.dart';
import '../model/dto/response/sensor_data_response_dto.dart';

class SensorsRealtimeMapper {
  const SensorsRealtimeMapper._();

  static SensorRealtimeReading fromDataResponse(SensorDataResponseDto dto) =>
      SensorRealtimeReading(sensorType: dto.sensorType, value: dto.value);
}
