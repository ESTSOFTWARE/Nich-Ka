import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/home_feature.dart';
import 'home_student_state.dart';

class HomeStudentNotifier extends AutoDisposeNotifier<HomeStudentState> {
  @override
  HomeStudentState build() => const HomeStudentState();

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return '¡Buenos días!';
    if (hour < 19) return '¡Buenas tardes!';
    return '¡Buenas noches!';
  }

  List<HomeFeature> get features => state.features;
}

final homeStudentProvider =
    NotifierProvider.autoDispose<HomeStudentNotifier, HomeStudentState>(
      HomeStudentNotifier.new,
    );
