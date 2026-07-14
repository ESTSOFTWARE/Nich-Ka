import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/class_dependencies.dart';
import '../states/ui_state.dart';
import 'class_detail_state.dart';

class ClassDetailNotifier
    extends AutoDisposeFamilyNotifier<ClassDetailState, String> {
  @override
  ClassDetailState build(String classId) {
    final groupId = int.tryParse(classId);
    if (groupId == null) {
      return const ClassDetailState(fermentationsState: UiSuccess([]));
    }
    _loadFermentations(groupId);
    return const ClassDetailState();
  }

  Future<void> _loadFermentations(int groupId) async {
    try {
      final fermentations = await ClassDependencies.getFermentations(groupId);
      state = state.copyWith(fermentationsState: UiSuccess(fermentations));
    } catch (e) {
      state = state.copyWith(
        fermentationsState: const UiError(
          'No se pudieron cargar las fermentaciones.',
        ),
      );
    }
  }
}

final classDetailProvider = NotifierProvider.autoDispose
    .family<ClassDetailNotifier, ClassDetailState, String>(
      ClassDetailNotifier.new,
    );
