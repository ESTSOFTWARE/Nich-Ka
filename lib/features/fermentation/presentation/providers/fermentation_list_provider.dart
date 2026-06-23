import 'package:flutter/material.dart';
import '../../../../core/network/http_client.dart';
import '../../../home/domain/entities/fermentation_item.dart';
import '../../data/datasource/remote/fermentation_batches_datasource.dart';
import '../../data/repositories/fermentation_batches_repository_impl.dart';
import '../../domain/entities/fermentation_filter.dart';
import '../../domain/repositories/fermentation_batches_repository.dart';
import '../../domain/use_cases/get_fermentation_batches_use_case.dart';

class FermentationListProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  String get query => searchController.text.trim().toLowerCase();

  final GetFermentationBatchesUseCase _getBatches;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  FermentationListProvider({FermentationBatchesRepository? repository})
    : _getBatches = GetFermentationBatchesUseCase(
        repository ??
            FermentationBatchesRepositoryImpl(
              FermentationBatchesDatasource(HttpClient.instance),
            ),
      ) {
    scrollController.addListener(_onScroll);
    searchController.addListener(notifyListeners);
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      _all = await _getBatches();
      _hasError = false;
    } catch (_) {
      _all = [];
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  void refresh() {
    _init();
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

  List<FermentationItem> _all = [];

  List<FermentationItem> get items {
    final byFilter = switch (_filter) {
      FermentationFilter.todos => _all,
      FermentationFilter.activos =>
        _all.where((i) => i.statusLabel == 'En proceso').toList(),
      FermentationFilter.secado =>
        _all
            .where(
              (i) =>
                  i.statusLabel == 'Interrumpida' ||
                  i.statusLabel == 'Programada',
            )
            .toList(),
      FermentationFilter.completados =>
        _all.where((i) => i.statusLabel == 'Completada').toList(),
    };
    if (query.isEmpty) return byFilter;
    return byFilter
        .where(
          (i) =>
              i.id.toLowerCase().contains(query) ||
              i.name.toLowerCase().contains(query) ||
              i.farm.toLowerCase().contains(query),
        )
        .toList();
  }

  int get total => _all.length;
}
