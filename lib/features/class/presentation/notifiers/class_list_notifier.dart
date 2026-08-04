import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/class_repository_impl.dart';
import '../../domain/entities/class_summary.dart';
import '../../domain/use_cases/get_classes_use_case.dart';
import '../states/ui_state.dart';
import 'class_list_state.dart';

class ClassListNotifier extends Notifier<ClassListState> {
  final ScrollController scrollController = ScrollController();
  late final GetClassesUseCase _getClasses;

  @override
  ClassListState build() {
    _getClasses = GetClassesUseCase(ClassRepositoryImpl());
    scrollController.addListener(_onScroll);
    ref.onDispose(() {
      scrollController.removeListener(_onScroll);
      scrollController.dispose();
    });
    _loadData();
    return const ClassListState();
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != state.isScrolled) {
      state = state.copyWith(isScrolled: scrolled);
    }
  }

  Future<void> _loadData() async {
    state = state.copyWith(
      classesState: const UiLoading(),
      summaryState: const UiLoading(),
    );
    try {
      final classes = await _getClasses();
      state = state.copyWith(
        classesState: UiSuccess(classes),
        summaryState: UiSuccess(
          ClassSummary(totalGroups: classes.length, unreadItems: 0),
        ),
      );
    } catch (e) {
      state = state.copyWith(
        classesState: const UiError('No se pudieron cargar las clases.'),
        summaryState: const UiError(''),
      );
    }
  }

  Future<void> refresh() => _loadData();
}

final classListProvider = NotifierProvider<ClassListNotifier, ClassListState>(
  ClassListNotifier.new,
);
