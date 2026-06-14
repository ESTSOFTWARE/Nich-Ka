import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/entities/sensor_reading.dart';
import '../../domain/entities/sensors_status.dart';

class SensorsProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  final _rng = Random();
  Timer? _timer;

  late List<SensorReading> _readings;
  List<SensorReading> get readings => _readings;

  final SensorsStatus status = const SensorsStatus(
    online: 6,
    total: 6,
    allInRange: true,
    statusLabel: 'Todo en rango óptimo',
    fermentationId: 'F-024',
    variety: 'Caturra',
  );

  SensorsProvider() {
    scrollController.addListener(_onScroll);
    _readings = _buildInitialReadings();
    _timer = Timer.periodic(const Duration(milliseconds: 1100), _onTick);
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      _isScrolled = scrolled;
      notifyListeners();
    }
  }

  void _onTick(Timer _) {
    _readings = _readings.map((r) {
      final delta = (_rng.nextDouble() - 0.48) * r.rawValue * 0.008;
      final next = r.rawValue + delta;
      return r.copyWith(
        rawValue: next,
        history: [...r.history.skip(1), next],
        trendUp: delta >= 0,
      );
    }).toList();
    notifyListeners();
  }

  List<SensorReading> _buildInitialReadings() {
    return [
      _make(
        id: 'ph',
        label: 'pH',
        value: 4.10,
        decimals: 2,
        unit: '',
        icon: Icons.ssid_chart,
        color: const Color(0xFF4FA8E8),
      ),
      _make(
        id: 'temp',
        label: 'Temperatura',
        value: 23.5,
        decimals: 1,
        unit: '°C',
        icon: Icons.thermostat,
        color: const Color(0xFFF0A646),
      ),
      _make(
        id: 'alcohol',
        label: 'Alcohol',
        value: 6.1,
        decimals: 1,
        unit: '%v/v',
        icon: Icons.science,
        color: const Color(0xFFFF6B6B),
      ),
      _make(
        id: 'conductividad',
        label: 'Conductividad',
        value: 3.1,
        decimals: 1,
        unit: 'mS',
        icon: Icons.bolt,
        color: const Color(0xFF14B8A6),
      ),
      _make(
        id: 'turbidez',
        label: 'Turbidez',
        value: 173,
        decimals: 0,
        unit: 'NTU',
        icon: Icons.grain,
        color: const Color(0xFFA78BFA),
      ),
      _make(
        id: 'rpm',
        label: 'RPM del motor',
        value: 120,
        decimals: 0,
        unit: 'rpm',
        icon: Icons.settings,
        color: const Color(0xFFF97316),
      ),
    ];
  }

  SensorReading _make({
    required String id,
    required String label,
    required double value,
    required int decimals,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    final history = List.generate(20, (i) {
      final noise = (_rng.nextDouble() - 0.5) * value * 0.04;
      return value + noise;
    });
    return SensorReading(
      id: id,
      label: label,
      rawValue: value,
      decimals: decimals,
      unit: unit,
      icon: icon,
      color: color,
      history: history,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
