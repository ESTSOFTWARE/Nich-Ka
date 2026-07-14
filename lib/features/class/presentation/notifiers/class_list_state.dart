import '../../domain/entities/class_detail.dart';
import '../../domain/entities/class_summary.dart';
import '../states/ui_state.dart';

class ClassListState {
  final UiState<List<ClassDetail>> classesState;
  final UiState<ClassSummary> summaryState;

  const ClassListState({
    this.classesState = const UiLoading(),
    this.summaryState = const UiLoading(),
  });

  ClassListState copyWith({
    UiState<List<ClassDetail>>? classesState,
    UiState<ClassSummary>? summaryState,
  }) => ClassListState(
    classesState: classesState ?? this.classesState,
    summaryState: summaryState ?? this.summaryState,
  );
}
