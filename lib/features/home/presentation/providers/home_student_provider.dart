import 'package:flutter/material.dart';
import '../../domain/entities/home_feature.dart';

class HomeStudentProvider extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();

  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  HomeStudentProvider() {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      _isScrolled = scrolled;
      notifyListeners();
    }
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return '¡Buenos días!';
    if (hour < 19) return '¡Buenas tardes!';
    return '¡Buenas noches!';
  }

  final List<HomeFeature> features = const [
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
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
