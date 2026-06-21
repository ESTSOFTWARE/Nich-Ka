import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../../../../core/network/http_client.dart';
import '../../../domain/entities/sensor_realtime_reading.dart';
import 'mapper/sensors_realtime_mapper.dart';
import 'model/dto/response/current_circuit_response_dto.dart';
import 'model/dto/response/sensor_data_response_dto.dart';

class SensorsRealtimeDataSource {
  final HttpClient _client;

  SensorsRealtimeDataSource(this._client);

  WebSocket? _socket;
  StreamController<SensorRealtimeReading>? _controller;
  Timer? _retryTimer;
  bool _closed = false;
  int _circuitId = 0;

  Future<int?> fetchCircuitId() async {
    final response = await _client.get('/users/me');
    if (response.statusCode < 200 || response.statusCode >= 300) return null;
    final dto = CurrentCircuitResponseDto.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
    return dto.circuitId;
  }

  Stream<SensorRealtimeReading> watch(int circuitId) {
    _closed = false;
    _circuitId = circuitId;
    _controller ??= StreamController<SensorRealtimeReading>.broadcast();
    _open();
    return _controller!.stream;
  }

  Future<void> _open() async {
    if (_closed) return;
    final token = _client.accessToken;
    final url = '${HttpClient.wsBaseUrl}/ws/sensors/$_circuitId';
    try {
      _socket = await WebSocket.connect(
        url,
        headers: token != null ? {'Cookie': 'access_token=$token'} : null,
      );
      _socket!.listen(
        _onData,
        onDone: _scheduleRetry,
        onError: (_) => _scheduleRetry(),
        cancelOnError: true,
      );
    } catch (_) {
      _scheduleRetry();
    }
  }

  void _onData(dynamic raw) {
    try {
      final dto = SensorDataResponseDto.fromJson(
        jsonDecode(raw as String) as Map<String, dynamic>,
      );
      if (dto.type != 'sensor_data' || dto.sensorType.isEmpty) return;
      _controller?.add(SensorsRealtimeMapper.fromDataResponse(dto));
    } catch (_) {
      // mensaje malformado → ignorar
    }
  }

  void _scheduleRetry() {
    _socket = null;
    if (_closed) return;
    _retryTimer?.cancel();
    _retryTimer = Timer(const Duration(seconds: 3), _open);
  }

  Future<void> dispose() async {
    _closed = true;
    _retryTimer?.cancel();
    await _socket?.close();
    _socket = null;
    await _controller?.close();
    _controller = null;
  }
}
