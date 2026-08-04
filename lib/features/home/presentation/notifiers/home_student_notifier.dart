import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/home_feature.dart';

class HomeStudentState {
  final bool isScrolled;
  const HomeStudentState({this.isScrolled = false});

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return '¡Buenos días!';
    if (hour < 19) return '¡Buenas tardes!';
    return '¡Buenas noches!';
  }

  HomeStudentState copyWith({bool? isScrolled}) =>
      HomeStudentState(isScrolled: isScrolled ?? this.isScrolled);
}

class HomeStudentNotifier extends Notifier<HomeStudentState> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();

  static const List<HomeFeature> features = [
    HomeFeature(
      title: 'Monitorear sensores en vivo',
      description: 'pH, temperatura, alcohol y más en tiempo real',
      icon: Icons.ssid_chart,
      iconColor: Color(0xFF14B8A6),
    ),
    HomeFeature(
      title: 'Seguir cada fermentación',
      description: 'Curvas, fases y progreso de cada lote',
      icon: Icons.show_chart,
      iconColor: Color(0xFFF59E0B),
    ),
    HomeFeature(
      title: 'Consultar al asistente IA',
      description: 'Pregunta sobre perfiles de sabor y predicciones',
      icon: Icons.auto_awesome,
      iconColor: Color(0xFF75D079),
    ),
    HomeFeature(
      title: 'Descargar reportes',
      description: 'Resultados y análisis NLP en PDF',
      icon: Icons.description_outlined,
      iconColor: Color(0xFF818CF8),
    ),
  ];

  @override
  HomeStudentState build() {
    scrollController.addListener(_onScroll);
    ref.onDispose(() {
      scrollController.removeListener(_onScroll);
      scrollController.dispose();
    });
    return const HomeStudentState();
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != state.isScrolled) {
      state = state.copyWith(isScrolled: scrolled);
    }
  }
}

final homeStudentProvider =
    NotifierProvider<HomeStudentNotifier, HomeStudentState>(
      HomeStudentNotifier.new,
    );
