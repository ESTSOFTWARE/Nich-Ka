import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/http_client.dart';
import '../../data/datasource/remote/fermentation_batches_datasource.dart';
import '../../data/repositories/fermentation_batches_repository_impl.dart';
import '../../domain/entities/fermentation_filter.dart';
import '../../domain/use_cases/get_fermentation_batches_use_case.dart';
import 'fermentation_list_state.dart';

class FermentationListNotifier extends Notifier<FermentationListState> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  late final GetFermentationBatchesUseCase _getBatches;

  @override
  FermentationListState build() {
    _getBatches = GetFermentationBatchesUseCase(
      FermentationBatchesRepositoryImpl(
        FermentationBatchesDatasource(HttpClient.instance),
      ),
    );
    scrollController.addListener(_onScroll);
    searchController.addListener(_onSearchChanged);
    ref.onDispose(() {
      scrollController.removeListener(_onScroll);
      scrollController.dispose();
      searchController.removeListener(_onSearchChanged);
      searchController.dispose();
    });
    _init();
    return const FermentationListState();
  }

  /// Limpia posibles etiquetas/símbolos de inyección del texto de búsqueda.
  void _onSearchChanged() {
    final raw = searchController.text.trim().toLowerCase();
    final noTags = raw.replaceAll(RegExp(r'<[^>]*>'), '');
    final clean = noTags.replaceAll(RegExp(r'[<>&;="\x27]'), '');
    if (clean != state.query) state = state.copyWith(query: clean);
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true, hasError: false);
    try {
      final all = await _getBatches();
      state = state.copyWith(all: all, hasError: false, isLoading: false);
    } catch (_) {
      state = state.copyWith(all: [], hasError: true, isLoading: false);
    }
  }

  void refresh() => _init();

  void setFilter(FermentationFilter f) {
    if (state.filter == f) return;
    state = state.copyWith(filter: f);
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != state.isScrolled) {
      state = state.copyWith(isScrolled: scrolled);
    }
  }
}

final fermentationListProvider =
    NotifierProvider<FermentationListNotifier, FermentationListState>(
      FermentationListNotifier.new,
    );
