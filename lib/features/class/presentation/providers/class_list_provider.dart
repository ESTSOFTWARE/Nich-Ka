import 'package:flutter/material.dart';
import '../../data/repositories/class_repository_impl.dart';
import '../../domain/entities/class_detail.dart';
import '../../domain/entities/class_summary.dart';
import '../../domain/use_cases/get_classes_use_case.dart';
import '../states/ui_state.dart';

class ClassListProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  final GetClassesUseCase _getClasses;

  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  UiState<List<ClassDetail>> _classesState = const UiLoading();
  UiState<List<ClassDetail>> get classesState => _classesState;

  UiState<ClassSummary> _summaryState = const UiLoading();
  UiState<ClassSummary> get summaryState => _summaryState;

  ClassListProvider({GetClassesUseCase? getClasses})
    : _getClasses = getClasses ?? GetClassesUseCase(ClassRepositoryImpl()) {
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
      final classes = await _getClasses();
      _classesState = UiSuccess(classes);
      _summaryState = UiSuccess(
        ClassSummary(totalGroups: classes.length, unreadItems: 0),
      );
    } catch (e) {
      _classesState = const UiError('No se pudieron cargar las clases.');
      _summaryState = const UiError('');
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
