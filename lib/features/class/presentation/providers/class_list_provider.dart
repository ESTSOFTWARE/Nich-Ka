import 'package:flutter/material.dart';
import '../../data/repositories/class_repository_impl.dart';
import '../../domain/entities/class_item.dart';
import '../../domain/entities/class_summary.dart';
import '../../domain/repositories/class_repository.dart';
import '../states/ui_state.dart';

class ClassListProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  final ClassRepository _repository = ClassRepositoryImpl();

  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  UiState<List<ClassItem>> _classesState = const UiLoading();
  UiState<List<ClassItem>> get classesState => _classesState;

  UiState<ClassSummary> _summaryState = const UiLoading();
  UiState<ClassSummary> get summaryState => _summaryState;

  ClassListProvider() {
    scrollController.addListener(_onScroll);
    _loadData();
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      _isScrolled = scrolled;
      notifyListeners();
    }
  }

  Future<void> _loadData() async {
    _classesState = const UiLoading();
    _summaryState = const UiLoading();
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getClasses(),
        _repository.getSummary(),
      ]);
      _classesState = UiSuccess(results[0] as List<ClassItem>);
      _summaryState = UiSuccess(results[1] as ClassSummary);
    } catch (e) {
      _classesState = const UiError('No se pudieron cargar las clases.');
      _summaryState = const UiError('No se pudo cargar el resumen.');
    }
    notifyListeners();
  }

  Future<void> refresh() => _loadData();

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
