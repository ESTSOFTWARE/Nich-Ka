enum ReportPeriodFilter { todos, estaSemana, esteMes, anio }

extension ReportPeriodFilterLabel on ReportPeriodFilter {
  String get label {
    switch (this) {
      case ReportPeriodFilter.todos:
        return 'Todos';
      case ReportPeriodFilter.estaSemana:
        return 'Esta semana';
      case ReportPeriodFilter.esteMes:
        return 'Este mes';
      case ReportPeriodFilter.anio:
        return 'Año';
    }
  }
}
