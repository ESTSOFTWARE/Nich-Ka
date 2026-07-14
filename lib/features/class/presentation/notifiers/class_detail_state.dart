import '../../domain/entities/class_fermentation.dart';
import '../states/ui_state.dart';

class ClassDetailState {
  final UiState<List<ClassFermentation>> fermentationsState;

  const ClassDetailState({this.fermentationsState = const UiLoading()});

  ClassDetailState copyWith({
    UiState<List<ClassFermentation>>? fermentationsState,
  }) => ClassDetailState(
    fermentationsState: fermentationsState ?? this.fermentationsState,
  );
}
