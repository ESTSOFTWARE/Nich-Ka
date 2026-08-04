import '../../domain/entities/class_detail.dart';
import '../../domain/entities/class_summary.dart';
import '../states/ui_state.dart';

class ClassListState {
  final bool isScrolled;
  final UiState<List<ClassDetail>> classesState;
  final UiState<ClassSummary> summaryState;

  const ClassListState({
    this.isScrolled = false,
    this.classesState = const UiLoading(),
    this.summaryState = const UiLoading(),
  });

  ClassListState copyWith({
    bool? isScrolled,
    UiState<List<ClassDetail>>? classesState,
    UiState<ClassSummary>? summaryState,
  }) => ClassListState(
    isScrolled: isScrolled ?? this.isScrolled,
    classesState: classesState ?? this.classesState,
    summaryState: summaryState ?? this.summaryState,
  );
}
