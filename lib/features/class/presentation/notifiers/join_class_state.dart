import '../states/ui_state.dart';

class JoinClassState {
  final UiState<void> joinState;

  const JoinClassState({this.joinState = const UiIdle()});

  JoinClassState copyWith({UiState<void>? joinState}) =>
      JoinClassState(joinState: joinState ?? this.joinState);
}
