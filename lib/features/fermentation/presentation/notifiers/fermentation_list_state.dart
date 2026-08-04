import '../../../home/domain/entities/fermentation_item.dart';
import '../../domain/entities/fermentation_filter.dart';

class FermentationListState {
  final bool isScrolled;
  final bool isLoading;
  final bool hasError;
  final FermentationFilter filter;
  final String query;
  final List<FermentationItem> all;

  const FermentationListState({
    this.isScrolled = false,
    this.isLoading = true,
    this.hasError = false,
    this.filter = FermentationFilter.todos,
    this.query = '',
    this.all = const [],
  });

  List<FermentationItem> get items {
    final byFilter = switch (filter) {
      FermentationFilter.todos => all,
      FermentationFilter.activos =>
        all.where((i) => i.statusLabel == 'En proceso').toList(),
      FermentationFilter.secado =>
        all
            .where(
              (i) =>
                  i.statusLabel == 'Interrumpida' ||
                  i.statusLabel == 'Programada',
            )
            .toList(),
      FermentationFilter.completados =>
        all.where((i) => i.statusLabel == 'Completada').toList(),
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

  int get total => all.length;

  FermentationListState copyWith({
    bool? isScrolled,
    bool? isLoading,
    bool? hasError,
    FermentationFilter? filter,
    String? query,
    List<FermentationItem>? all,
  }) => FermentationListState(
    isScrolled: isScrolled ?? this.isScrolled,
    isLoading: isLoading ?? this.isLoading,
    hasError: hasError ?? this.hasError,
    filter: filter ?? this.filter,
    query: query ?? this.query,
    all: all ?? this.all,
  );
}
