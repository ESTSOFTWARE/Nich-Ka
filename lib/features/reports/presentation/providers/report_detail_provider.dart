import 'package:flutter/material.dart';
import '../../data/datasource/local/reports_local_datasource.dart';
import '../../domain/entities/report_detail.dart';
import '../states/ui_state.dart';

class ReportDetailProvider extends ChangeNotifier {
  UiState<ReportDetail> _state = const UiLoading();
  UiState<ReportDetail> get state => _state;

  ReportDetailProvider() {
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    _state = const UiLoading();
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final detail = getMockReportDetail();
      _state = UiSuccess(detail);
    } catch (e) {
      _state = const UiError('No se pudo cargar el detalle del reporte.');
    }
    notifyListeners();
  }

  Future<void> retry() => _loadDetail();
}
