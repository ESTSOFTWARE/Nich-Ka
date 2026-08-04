import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/http_client.dart';
import '../../data/datasource/remote/class_remote_datasource.dart';
import '../../domain/entities/class_detail.dart';
import 'class_detail_state.dart';

/// Family sobre la ClassDetail que abre la vista.
class ClassDetailNotifier
    extends FamilyNotifier<ClassDetailState, ClassDetail> {
  final ScrollController scrollController = ScrollController();
  late final ClassRemoteDataSource _remote;

  @override
  ClassDetailState build(ClassDetail detail) {
    _remote = ClassRemoteDataSource(HttpClient.instance);
    scrollController.addListener(_onScroll);
    ref.onDispose(() {
      scrollController.removeListener(_onScroll);
      scrollController.dispose();
    });
    _loadFermentations(detail);
    return ClassDetailState(detail: detail);
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != state.isScrolled) {
      state = state.copyWith(isScrolled: scrolled);
    }
  }

  Future<void> _loadFermentations(ClassDetail detail) async {
    final groupId = int.tryParse(detail.id);
    if (groupId == null) return;
    try {
      final fermentations = await _remote.getGroupSessions(groupId);
      state = state.copyWith(fermentations: fermentations);
    } catch (_) {}
  }
}

final classDetailProvider =
    NotifierProvider.family<ClassDetailNotifier, ClassDetailState, ClassDetail>(
      ClassDetailNotifier.new,
    );
