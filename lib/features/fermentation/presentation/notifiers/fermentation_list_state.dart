import '../../../../core/presentation/ui_state.dart';
import '../../../home/domain/entities/fermentation_item.dart';
import '../../domain/entities/fermentation_filter.dart';

class FermentationListState {
  final UiState<List<FermentationItem>> status;
  final FermentationFilter filter;
  final String query;

  const FermentationListState({
    this.status = const UiIdle(),
    this.filter = FermentationFilter.todos,
    this.query = '',
  });

  FermentationListState copyWith({
    UiState<List<FermentationItem>>? status,
    FermentationFilter? filter,
    String? query,
  }) => FermentationListState(
    status: status ?? this.status,
    filter: filter ?? this.filter,
    query: query ?? this.query,
  );
}
