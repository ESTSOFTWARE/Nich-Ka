import 'package:flutter/material.dart';
import '../../../../../core/network/http_client.dart';
import '../../data/datasource/remote/class_remote_datasource.dart';
import '../../domain/entities/class_detail.dart';
import '../../domain/entities/class_fermentation.dart';

class ClassDetailProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  final ClassDetail detail;
  final ClassRemoteDataSource _remote;

  List<ClassFermentation> _fermentations = [];
  List<ClassFermentation> get fermentations => _fermentations;

  ClassDetailProvider(
    this.detail, {
    ClassRemoteDataSource? remote,
  }) : _remote = remote ?? ClassRemoteDataSource(HttpClient.instance) {
    scrollController.addListener(_onScroll);
    _loadFermentations();
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      _isScrolled = scrolled;
      notifyListeners();
    }
  }

  Future<void> _loadFermentations() async {
    final groupId = int.tryParse(detail.id);
    if (groupId == null) return;
    try {
      _fermentations = await _remote.getGroupSessions(groupId);
    } catch (_) {}
    notifyListeners();
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
