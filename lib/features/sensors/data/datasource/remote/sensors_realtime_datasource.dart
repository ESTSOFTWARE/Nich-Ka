import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../../core/network/http_client.dart';
import '../../../domain/entities/sensor_realtime_reading.dart';
import 'mapper/sensors_realtime_mapper.dart';
import 'model/dto/response/current_circuit_response_dto.dart';
import 'model/dto/response/sensor_data_response_dto.dart';

class SensorsRealtimeDataSource {
  final HttpClient _client;

  SensorsRealtimeDataSource(this._client);

  WebSocketChannel? _channel;
  StreamController<SensorRealtimeReading>? _controller;
  StreamController<void>? _stopController;
  Timer? _retryTimer;

  /// Emite cuando el backend detiene la fermentación (evento WS, sin polling).
  Stream<void> get onFermentationStopped =>
      (_stopController ??= StreamController<void>.broadcast()).stream;
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
    final base = HttpClient.wsBaseUrl;
    final uri = Uri.parse(
      '$base/ws/sensors/$_circuitId${token != null ? '?token=$token' : ''}',
    );

    try {
      _channel = WebSocketChannel.connect(uri);
      await _channel!.ready;
      _channel!.stream.listen(
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
      final json = jsonDecode(raw as String) as Map<String, dynamic>;
      if (json['type'] == 'fermentation_stopped') {
        _stopController?.add(null);
        return;
      }
      final dto = SensorDataResponseDto.fromJson(json);
      if (dto.type != 'sensor_data' || dto.sensorType.isEmpty) return;
      _controller?.add(SensorsRealtimeMapper.fromDataResponse(dto));
    } catch (_) {}
  }

  void _scheduleRetry() {
    _channel = null;
    if (_closed) return;
    _retryTimer?.cancel();
    _retryTimer = Timer(const Duration(seconds: 3), _open);
  }

  Future<void> dispose() async {
    _closed = true;
    _retryTimer?.cancel();
    await _channel?.sink.close();
    _channel = null;
    await _controller?.close();
    _controller = null;
    await _stopController?.close();
    _stopController = null;
  }
}
