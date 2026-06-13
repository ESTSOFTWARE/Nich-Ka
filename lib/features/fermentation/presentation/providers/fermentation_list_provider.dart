import 'package:flutter/material.dart';
import '../../../home/domain/entities/fermentation_item.dart';
import '../../../home/presentation/theme/home_palette.dart';
import '../../domain/entities/fermentation_filter.dart';

class FermentationListProvider extends ChangeNotifier {
  FermentationFilter _filter = FermentationFilter.todos;
  FermentationFilter get filter => _filter;

  void setFilter(FermentationFilter f) {
    if (_filter == f) return;
    _filter = f;
    notifyListeners();
  }

  static const _all = [
    FermentationItem(
      id: 'F-024',
      name: 'Caturra',
      process: 'Lavado',
      farm: 'La Esperanza',
      statusLabel: 'Fermentación',
      statusColor: HomePalette.accent,
      timeInfo: '18h 42m',
      ringProgress: 0.78,
      ringColor: HomePalette.accent,
    ),
    FermentationItem(
      id: 'F-023',
      name: 'Geisha',
      process: 'Honey',
      farm: 'El Mirador',
      statusLabel: 'Secado',
      statusColor: HomePalette.metricOrange,
      timeInfo: 'Día 3 / 12',
      ringProgress: 0.40,
      ringColor: HomePalette.metricOrange,
    ),
    FermentationItem(
      id: 'F-022',
      name: 'Bourbon',
      process: 'Natural',
      farm: 'La Esperanza',
      statusLabel: 'Reposo',
      statusColor: HomePalette.metricCyan,
      timeInfo: '5 días',
      ringProgress: 0.25,
      ringColor: HomePalette.metricCyan,
    ),
    FermentationItem(
      id: 'F-021',
      name: 'Typica',
      process: 'Lavado',
      farm: 'Buena Vista',
      statusLabel: 'Completado',
      statusColor: Color(0xFF787878),
      timeInfo: 'Hace 2d',
      ringProgress: 1.0,
      ringColor: Color(0xFF787878),
    ),
    FermentationItem(
      id: 'F-020',
      name: 'SL-28',
      process: 'Honey',
      farm: 'El Mirador',
      statusLabel: 'Completado',
      statusColor: Color(0xFF787878),
      timeInfo: 'Hace 5d',
      ringProgress: 1.0,
      ringColor: Color(0xFF787878),
    ),
  ];

  List<FermentationItem> get items {
    switch (_filter) {
      case FermentationFilter.todos:
        return _all;
      case FermentationFilter.activos:
        return _all.where((i) => i.statusLabel == 'Fermentación').toList();
      case FermentationFilter.secado:
        return _all.where((i) => i.statusLabel == 'Secado').toList();
      case FermentationFilter.completados:
        return _all.where((i) => i.statusLabel == 'Completado').toList();
    }
  }

  int get total => _all.length;
}
