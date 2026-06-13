enum TimeRange { sixHours, twentyFourHours, total }

extension TimeRangeLabel on TimeRange {
  String get label {
    switch (this) {
      case TimeRange.sixHours:
        return '6h';
      case TimeRange.twentyFourHours:
        return '24h';
      case TimeRange.total:
        return 'Total';
    }
  }
}
