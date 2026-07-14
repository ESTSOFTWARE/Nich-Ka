import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/class_dependencies.dart';
import '../../domain/entities/class_summary.dart';
import '../states/ui_state.dart';
import 'class_list_state.dart';

class ClassListNotifier extends Notifier<ClassListState> {
  @override
  ClassListState build() {
    _loadData();
    return const ClassListState();
  }

  Future<void> _loadData() async {
    try {
      final classes = await ClassDependencies.getClasses();
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
