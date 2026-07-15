import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/class_dependencies.dart';
import '../states/ui_state.dart';
import 'join_class_state.dart';

class JoinClassNotifier extends Notifier<JoinClassState> {
  @override
  JoinClassState build() => const JoinClassState();

  Future<bool> onSearch(String code) async {
    if (code.isEmpty) {
      state = state.copyWith(
        joinState: const UiError('Ingresa o escanea un código de clase.'),
      );
      return false;
    }

    state = state.copyWith(joinState: const UiLoading());
    try {
      await ClassDependencies.joinClass(code);
      state = state.copyWith(joinState: const UiSuccess(null));
      return true;
    } catch (e) {
      state = state.copyWith(
        joinState: UiError(e.toString().replaceFirst('Exception: ', '')),
      );
      return false;
    }
  }
}

final joinClassProvider = NotifierProvider<JoinClassNotifier, JoinClassState>(
  JoinClassNotifier.new,
);
