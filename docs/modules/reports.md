# Módulo: Reportes

Documentación del módulo de Reportes, que incluye el historial de reportes, detalle con métricas de sensores, análisis NLP y descarga de PDF.

> **Ubicación:** `lib/features/reports/`

---

## Índice

- [Descripción](#descripción)
- [Pantallas](#pantallas)
- [Componentes](#componentes)
- [Providers](#providers)
- [Entidades de dominio](#entidades-de-dominio)
- [Capa de datos](#capa-de-datos)

---

## Descripción

El módulo de reportes muestra el historial de fermentaciones completadas con sus reportes asociados. Cada reporte incluye métricas de eficiencia, datos de sensores, análisis NLP (procesamiento de lenguaje natural) y la opción de descargar el reporte en PDF.

---

## Pantallas

| Pantalla | Ruta | Descripción |
|---|---|---|
| `ReportsView` | `/reports` | Lista de reportes históricos |
| `ReportDetailView` | `/report-detail?sessionId=` | Detalle de un reporte específico |

---

## Componentes

### Lista de reportes

| Componente | Propósito |
|---|---|
| `ReportsList` | Lista de reportes |
| `ReportCard` | Tarjeta de cada reporte |
| `ReportsFilterBar` | Filtros por período |
| `ReportsSkeleton` | Skeleton de carga |
| `ReportsEmptyState` | Estado vacío |
| `ReportsErrorState` | Estado de error |
| `ReportSummaryCards` | Cards de resumen |

### Detalle de reporte

| Componente | Propósito |
|---|---|
| `ReportHeader` | Cabecera del reporte |
| `ReportMetadata` | Metadata (fecha, duración, etc.) |
| `ReportSummaryCard` | Card de resumen del reporte |
| `EfficiencyCard` | Card de eficiencia |
| `EfficiencyRingPainter` | Anillo de eficiencia |
| `SensorsMetricsCard` | Métricas de sensores |
| `EthanolBarsCard` | Gráfica de barras de etanol |
| `NlpAnalysisCard` | Análisis NLP del reporte |
| `ReportDetailSkeleton` | Skeleton de carga del detalle |
| `ReportDetailEmptyState` | Estado vacío del detalle |

---

## Providers

| Provider | Tipo | Propósito |
|---|---|---|
| `ReportsProvider` | `ChangeNotifier` | Lista de reportes |
| `ReportDetailProvider` | `ChangeNotifier` | Detalle de un reporte |

---

## Entidades de dominio

| Entidad | Propósito |
|---|---|
| `ReportItem` | Resumen de un reporte en la lista |
| `ReportDetail` | Detalle completo del reporte |
| `ReportPeriodFilter` | Filtro de período |
| `ReportsSummary` | Resumen general de reportes |
| `SensorMetric` | Métrica de un sensor en el reporte |
| `NlpAnalysis` | Resultado del análisis NLP |

---

## Capa de datos

### Endpoints utilizados

| Método | Endpoint | Descripción |
|---|---|---|
| `GET` | `/fermentation/sessions-with-reports?limit=50` | Sesiones con reportes |
| `GET` | `/fermentation/{sessionId}/report` | Detalle del reporte |
| `GET` | `/fermentation/{sessionId}/report/pdf` | Descargar PDF |
| `GET` | `/fermentation/history` | Historial de fermentaciones |

### Datasources

| Datasource | Propósito |
|---|---|
| `ReportsRemoteDataSource` | Datos remotos del reporte |
| `ReportsLocalDataSource` | Almacenamiento local de reportes descargados |

---

## Enlaces

- [← Mensajes](messages.md)
- [Clases →](classes.md)
