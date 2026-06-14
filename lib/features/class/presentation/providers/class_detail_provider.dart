import 'package:flutter/material.dart';
import '../../domain/entities/class_detail.dart';

class ClassDetailProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  final ClassDetail detail;

  ClassDetailProvider(this.detail) {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      _isScrolled = scrolled;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
