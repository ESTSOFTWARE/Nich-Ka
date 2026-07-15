import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'assistant_state.dart';

class AssistantNotifier extends AutoDisposeNotifier<AssistantState> {
  @override
  AssistantState build() => const AssistantState();

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return '¡Buenos días!';
    if (hour < 19) return '¡Buenas tardes!';
    return '¡Buenas noches!';
  }

  List<String> get suggestions => state.suggestions;
}

final assistantProvider =
    NotifierProvider.autoDispose<AssistantNotifier, AssistantState>(
      AssistantNotifier.new,
    );
