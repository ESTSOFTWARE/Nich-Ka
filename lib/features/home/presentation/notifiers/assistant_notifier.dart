import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssistantState {
  final bool isScrolled;
  const AssistantState({this.isScrolled = false});

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return '¡Buenos días!';
    if (hour < 19) return '¡Buenas tardes!';
    return '¡Buenas noches!';
  }

  AssistantState copyWith({bool? isScrolled}) =>
      AssistantState(isScrolled: isScrolled ?? this.isScrolled);
}

class AssistantNotifier extends Notifier<AssistantState> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();

  static const List<String> suggestions = [
    '¿Cómo va mi fermentación F-024?',
    'Predicción de perfil de sabor',
    'Comparar con fermentación anterior',
    '¿Cuándo termina mi fermentación?',
  ];

  @override
  AssistantState build() {
    scrollController.addListener(_onScroll);
    ref.onDispose(() {
      scrollController.removeListener(_onScroll);
      scrollController.dispose();
    });
    return const AssistantState();
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != state.isScrolled) {
      state = state.copyWith(isScrolled: scrolled);
    }
  }
}

final assistantProvider = NotifierProvider<AssistantNotifier, AssistantState>(
  AssistantNotifier.new,
);
