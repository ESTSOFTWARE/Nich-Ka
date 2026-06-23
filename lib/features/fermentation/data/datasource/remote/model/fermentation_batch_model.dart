import 'package:flutter/material.dart';

import '../../../../../../shared/theme/app_palette.dart';
import '../../../../../home/domain/entities/fermentation_item.dart';
import 'dto/fermentation_batch_dto.dart';

class FermentationBatchModel {
  final int id;
  final int circuitId;
  final String status;
  final DateTime scheduledStart;
  final DateTime scheduledEnd;
  final DateTime? actualStart;
  final DateTime? actualEnd;
  final DateTime? createdAt;

  const FermentationBatchModel({
    required this.id,
    required this.circuitId,
    required this.status,
    required this.scheduledStart,
    required this.scheduledEnd,
    this.actualStart,
    this.actualEnd,
    this.createdAt,
  });

  factory FermentationBatchModel.fromDto(
    FermentationBatchDto dto,
  ) => FermentationBatchModel(
    id: dto.id,
    circuitId: dto.circuitId,
    status: dto.status,
    scheduledStart: DateTime.tryParse(dto.scheduledStart) ?? DateTime.now(),
    scheduledEnd: DateTime.tryParse(dto.scheduledEnd) ?? DateTime.now(),
    actualStart: dto.actualStart != null
        ? DateTime.tryParse(dto.actualStart!)
        : null,
    actualEnd: dto.actualEnd != null ? DateTime.tryParse(dto.actualEnd!) : null,
    createdAt: dto.createdAt != null ? DateTime.tryParse(dto.createdAt!) : null,
  );

  FermentationItem toEntity() {
    final now = DateTime.now();
    final displayId = 'F-$id';

    final statusLabel = switch (status) {
      'scheduled' => 'Programada',
      'running' => 'En proceso',
      'completed' => 'Completada',
      'interrupted' => 'Interrumpida',
      _ => status,
    };

    final statusColor = switch (status) {
      'running' => AppPalette.accent,
      'completed' => const Color(0xFF787878),
      'interrupted' => AppPalette.metricOrange,
      _ => const Color(0xFF787878),
    };

    final ringProgress = switch (status) {
      'completed' => 1.0,
      'running' => _calcProgress(now),
      'interrupted' => _calcProgress(now),
      _ => 0.0,
    };

    final timeInfo = _formatTimeInfo(now);

    return FermentationItem(
      id: displayId,
      name: displayId,
      process: '',
      farm: '',
      statusLabel: statusLabel,
      statusColor: statusColor,
      timeInfo: timeInfo,
      ringProgress: ringProgress,
      ringColor: statusColor,
    );
  }

  double _calcProgress(DateTime now) {
    final start = actualStart ?? scheduledStart;
    final end = actualEnd ?? scheduledEnd;
    final total = end.difference(start).inSeconds;
    if (total <= 0) {
      return 0.0;
    }
    final elapsed = now.difference(start).inSeconds;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  String _formatTimeInfo(DateTime now) {
    switch (status) {
      case 'scheduled':
        return 'Inicia ${_formatDate(scheduledStart)}';
      case 'running':
        final start = actualStart ?? scheduledStart;
        final elapsed = now.difference(start);
        if (elapsed.inDays > 0) {
          final total = scheduledEnd.difference(scheduledStart).inDays;
          return 'Día ${elapsed.inDays + 1} / ${total + 1}';
        }
        if (elapsed.inHours > 0) {
          return '${elapsed.inHours}h ${elapsed.inMinutes % 60}m';
        }
        return '${elapsed.inMinutes}m';
      case 'completed':
        final end = actualEnd ?? scheduledEnd;
        final diff = now.difference(end);
        if (diff.inDays > 0) {
          return 'Hace ${diff.inDays}d';
        }
        if (diff.inHours > 0) {
          return 'Hace ${diff.inHours}h';
        }
        return 'Ahora';
      case 'interrupted':
        return 'Interrumpido';
      default:
        return '';
    }
  }

  static String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}';
  }
}
