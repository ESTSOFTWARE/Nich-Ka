import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/ui_state.dart';
import '../../../home/domain/entities/fermentation_item.dart';
import '../../di/fermentation_dependencies.dart';
import '../../domain/entities/fermentation_filter.dart';
import 'fermentation_list_state.dart';

class FermentationListNotifier
    extends AutoDisposeNotifier<FermentationListState> {
  @override
  FermentationListState build() => const FermentationListState();

  Future<void> load() async {
    state = state.copyWith(status: const UiLoading());
    try {
      final batches = await FermentationDependencies.getBatches();
      state = state.copyWith(status: UiSuccess(batches));
    } catch (e) {
      state = state.copyWith(
        status: UiError(e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  Future<void> refresh() => load();

  void setFilter(FermentationFilter filter) {
    if (state.filter == filter) return;
    state = state.copyWith(filter: filter);
  }

  void setQuery(String raw) {
    final sanitized = raw
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'[<>&;="\x27]'), '');
    state = state.copyWith(query: sanitized);
  }

  List<FermentationItem> get items {
    final data = state.status;
    if (data is! UiSuccess<List<FermentationItem>>) return const [];
    final all = data.data;

    final byFilter = switch (state.filter) {
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

    if (state.query.isEmpty) return byFilter;
    return byFilter
        .where(
          (i) =>
              i.id.toLowerCase().contains(state.query) ||
              i.name.toLowerCase().contains(state.query) ||
              i.farm.toLowerCase().contains(state.query),
        )
        .toList();
  }

  int get total {
    final data = state.status;
    if (data is! UiSuccess<List<FermentationItem>>) return 0;
    return data.data.length;
  }
}

final fermentationListProvider =
    NotifierProvider.autoDispose<
      FermentationListNotifier,
      FermentationListState
    >(FermentationListNotifier.new);
