import 'package:flutter/material.dart';
import '../../../../domain/entities/nlp_analysis.dart';
import '../../../../domain/entities/report_detail.dart';
import '../../../../domain/entities/sensor_metric.dart';
import '../model/dto/response/fermentation_report_response_dto.dart';
import '../model/dto/response/fermentation_session_response_dto.dart';
import '../model/dto/response/report_history_response_dto.dart';

class ReportsDetailMapper {
  const ReportsDetailMapper._();

  static ReportDetail toReportDetail({
    required FermentationReportResponseDto report,
    required FermentationSessionResponseDto session,
    required List<ReportHistoryResponseDto> history,
  }) {
    final duration = _formatDuration(
      session.actualStart ?? session.scheduledStart,
      session.actualEnd ?? session.scheduledEnd,
    );
    final date = _formatDate(
      report.generatedAt ?? session.actualStart ?? session.scheduledStart,
    );

    final reportId = report.id;
    final downloads = history
        .where((h) => h.reportId == reportId && h.action == 'downloaded')
        .length;
    final views = history
        .where((h) => h.reportId == reportId && h.action == 'viewed')
        .length;

    return ReportDetail(
      reportNumber: report.id.toString(),
      fermentationCode: 'F-${session.id.toString().padLeft(3, '0')}',
      batchName: '',
      date: date,
      efficiency: report.efficiency ?? 0.0,
      ethanolDetected: report.ethanolDetected ?? 0.0,
      ethanolTheoretical: report.theoreticalEthanol ?? 0.0,
      duration: duration,
      nlpAnalysis: _buildNlpAnalysis(report.notes),
      sensorMetrics: _buildSensorMetrics(report),
      generatedAt: _formatGeneratedAt(report.generatedAt),
      downloads: downloads,
      views: views,
    );
  }

  static NlpAnalysis _buildNlpAnalysis(String? notes) {
    return NlpAnalysis(
      title: 'Análisis NLP',
      summary: notes ?? 'No hay análisis disponible para este reporte.',
      interpretation: '',
      observations: '',
    );
  }

  static List<SensorMetric> _buildSensorMetrics(
    FermentationReportResponseDto report,
  ) {
    return [
      if (report.phInitial != null)
        SensorMetric(
          label: 'pH',
          initialValue: _formatValue(report.phInitial),
          finalValue: _formatValue(report.phFinal),
          lastValue: _formatValue(report.phLastReading),
          unit: '',
          valueColor: const Color(0xFF86CDFF),
          icon: Icons.science_outlined,
        ),
      if (report.temperatureInitial != null)
        SensorMetric(
          label: 'Temperatura',
          initialValue: '${_formatValue(report.temperatureInitial)} °C',
          finalValue: '${_formatValue(report.temperatureFinal)} °C',
          lastValue: '${_formatValue(report.temperatureLastReading)} °C',
          unit: '°C',
          valueColor: const Color(0xFFF0A646),
          icon: Icons.thermostat_outlined,
        ),
      if (report.alcoholInitial != null)
        SensorMetric(
          label: 'Alcohol',
          initialValue: '${_formatValue(report.alcoholInitial)} %',
          finalValue: '${_formatValue(report.alcoholFinal)} %',
          lastValue: '${_formatValue(report.alcoholLastReading)} %',
          unit: '%',
          valueColor: const Color(0xFFFF9C8B),
          icon: Icons.liquor_outlined,
        ),
      if (report.conductivityInitial != null)
        SensorMetric(
          label: 'Conductividad',
          initialValue: '${_formatValue(report.conductivityInitial)} mS',
          finalValue: '${_formatValue(report.conductivityFinal)} mS',
          lastValue: '${_formatValue(report.conductivityLastReading)} mS',
          unit: 'mS',
          valueColor: const Color(0xFF60A5FA),
          icon: Icons.bolt_outlined,
        ),
      if (report.turbidityInitial != null)
        SensorMetric(
          label: 'Turbidez',
          initialValue: '${_formatValue(report.turbidityInitial)} NTU',
          finalValue: '${_formatValue(report.turbidityFinal)} NTU',
          lastValue: '${_formatValue(report.turbidityLastReading)} NTU',
          unit: 'NTU',
          valueColor: const Color(0xFF75D079),
          icon: Icons.water_drop_outlined,
        ),
    ];
  }

  static String _formatValue(dynamic value) {
    if (value == null) return '—';
    if (value is double) {
      return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1);
    }
    return value.toString();
  }

  static String _formatDuration(String start, String end) {
    try {
      final startDt = DateTime.parse(start);
      final endDt = DateTime.parse(end);
      final diff = endDt.difference(startDt);
      if (diff.inMinutes < 0) return '—';
      final hours = diff.inHours;
      final minutes = diff.inMinutes.remainder(60);
      return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
    } catch (_) {
      return '—';
    }
  }

  static String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      final months = [
        'ene', 'feb', 'mar', 'abr', 'may', 'jun',
        'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return isoDate;
    }
  }

  static String _formatGeneratedAt(String? generatedAt) {
    if (generatedAt == null) return '—';
    try {
      final dt = DateTime.parse(generatedAt);
      final months = [
        'ene', 'feb', 'mar', 'abr', 'may', 'jun',
        'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
      ];
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final amPm = dt.hour >= 12 ? 'p. m.' : 'a. m.';
      return '${dt.day} ${months[dt.month - 1]}, $hour:${dt.minute.toString().padLeft(2, '0')} $amPm';
    } catch (_) {
      return generatedAt;
    }
  }
}
