import '../../domain/entities/class_detail.dart';
import '../../domain/entities/class_fermentation.dart';

class ClassDetailState {
  final ClassDetail detail;
  final List<ClassFermentation> fermentations;
  final bool isScrolled;

  const ClassDetailState({
    required this.detail,
    this.fermentations = const [],
    this.isScrolled = false,
  });

  ClassDetailState copyWith({
    List<ClassFermentation>? fermentations,
    bool? isScrolled,
  }) => ClassDetailState(
    detail: detail,
    fermentations: fermentations ?? this.fermentations,
    isScrolled: isScrolled ?? this.isScrolled,
  );
}
