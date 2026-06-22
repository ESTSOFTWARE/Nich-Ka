import '../../../../domain/entities/report_item.dart';
import '../../../../domain/entities/report_period_filter.dart';
import '../../../../domain/entities/reports_summary.dart';
import '../model/dto/response/fermentation_report_response_dto.dart';
import '../model/dto/response/fermentation_session_response_dto.dart';

class ReportsMapper {
  const ReportsMapper._();

  static ReportItem sessionToReportItem({
    required FermentationSessionResponseDto session,
    FermentationReportResponseDto? report,
  }) {
    final start = session.actualStart ?? session.scheduledStart;
    final end = session.actualEnd ?? session.scheduledEnd;

    return ReportItem(
      id: 'F-${session.id.toString().padLeft(3, '0')}',
      variety: '',
      process: '',
      date: _formatDate(start),
      duration: _formatDuration(start, end),
      efficiency: report?.efficiency,
      status: _mapStatus(session.status),
    );
  }

  static ReportsSummary calculateSummary(List<ReportItem> reports) {
    final withEfficiency = reports.where((r) => r.efficiency != null).toList();
    final avg = withEfficiency.isEmpty
        ? 0.0
        : withEfficiency.fold(0.0, (sum, r) => sum + r.efficiency!) /
              withEfficiency.length;
    final completed = reports
        .where((r) => r.status == ReportStatus.completado)
        .length;
    return ReportsSummary(
      avgEfficiency: avg,
      total: reports.length,
      completed: completed,
    );
  }

  static List<ReportItem> filterByPeriod(
    List<ReportItem> reports,
    ReportPeriodFilter filter,
  ) {
    if (filter == ReportPeriodFilter.todos) return reports;

    final now = DateTime.now();
    return reports.where((r) {
      final date = _parseDate(r.date);
      if (date == null) return true;

      return switch (filter) {
        ReportPeriodFilter.estaSemana => _isSameWeek(date, now),
        ReportPeriodFilter.esteMes =>
          date.month == now.month && date.year == now.year,
        ReportPeriodFilter.anio => date.year == now.year,
        ReportPeriodFilter.todos => true,
      };
    }).toList();
  }

  static ReportStatus _mapStatus(String status) {
    switch (status) {
      case 'completed':
        return ReportStatus.completado;
      case 'interrupted':
        return ReportStatus.interrumpida;
      default:
        return ReportStatus.nuevo;
    }
  }

  static String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.day} ${_monthAbbr(dt.month)} ${dt.year}';
    } catch (_) {
      return isoDate;
    }
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

  static DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split(' ');
      if (parts.length != 3) return null;
      final day = int.tryParse(parts[0]);
      final month = _monthNumber(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day == null || month == null || year == null) return null;
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  static bool _isSameWeek(DateTime a, DateTime b) {
    final diff = a.difference(b).inDays.abs();
    return diff < 7;
  }

  static String _monthAbbr(int month) {
    const months = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    return months[month - 1];
  }

  static int? _monthNumber(String abbr) {
    const months = {
      'ene': 1,
      'feb': 2,
      'mar': 3,
      'abr': 4,
      'may': 5,
      'jun': 6,
      'jul': 7,
      'ago': 8,
      'sep': 9,
      'oct': 10,
      'nov': 11,
      'dic': 12,
    };
    return months[abbr.toLowerCase()];
  }
}
