import 'package:flutter/material.dart';
import '../../../home/domain/entities/fermentation_item.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../domain/entities/fermentation_filter.dart';

class FermentationListProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  String get query => searchController.text.trim().toLowerCase();

  FermentationListProvider() {
    scrollController.addListener(_onScroll);
    searchController.addListener(notifyListeners);
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      _isScrolled = scrolled;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchController.removeListener(notifyListeners);
    searchController.dispose();
    super.dispose();
  }

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
      statusColor: AppPalette.accent,
      timeInfo: '18h 42m',
      ringProgress: 0.78,
      ringColor: AppPalette.accent,
    ),
    FermentationItem(
      id: 'F-023',
      name: 'Geisha',
      process: 'Honey',
      farm: 'El Mirador',
      statusLabel: 'Secado',
      statusColor: AppPalette.metricOrange,
      timeInfo: 'Día 3 / 12',
      ringProgress: 0.40,
      ringColor: AppPalette.metricOrange,
    ),
    FermentationItem(
      id: 'F-022',
      name: 'Bourbon',
      process: 'Natural',
      farm: 'La Esperanza',
      statusLabel: 'Reposo',
      statusColor: AppPalette.metricCyan,
      timeInfo: '5 días',
      ringProgress: 0.25,
      ringColor: AppPalette.metricCyan,
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
    final byFilter = switch (_filter) {
      FermentationFilter.todos => _all,
      FermentationFilter.activos =>
        _all.where((i) => i.statusLabel == 'Fermentación').toList(),
      FermentationFilter.secado =>
        _all.where((i) => i.statusLabel == 'Secado').toList(),
      FermentationFilter.completados =>
        _all.where((i) => i.statusLabel == 'Completado').toList(),
    };
    if (query.isEmpty) return byFilter;
    return byFilter
        .where(
          (i) =>
              i.id.toLowerCase().contains(query) ||
              i.name.toLowerCase().contains(query) ||
              i.process.toLowerCase().contains(query) ||
              i.farm.toLowerCase().contains(query),
        )
        .toList();
  }

  int get total => _all.length;
}
