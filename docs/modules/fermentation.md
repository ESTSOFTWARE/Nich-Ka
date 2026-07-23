# Módulo: Fermentaciones

Documentación del módulo de Fermentaciones, que incluye la gestión de lotes, vista de detalle y seguimiento en tiempo real.

> **Ubicación:** `lib/features/fermentation/`

---

## Índice

- [Descripción](#descripción)
- [Pantallas](#pantallas)
- [Componentes](#componentes)
- [Providers](#providers)
- [Entidades de dominio](#entidades-de-dominio)
- [Capa de datos](#capa-de-datos)
- [Utilidades](#utilidades)

---

## Descripción

El módulo de fermentaciones permite a los estudiantes visualizar y dar seguimiento a los lotes de fermentación de café. Incluye una lista filtrable de todos los lotes y una vista de detalle con métricas, gráficas y eventos.

---

## Pantallas

| Pantalla | Ruta | Descripción |
|---|---|---|
| `FermentationListView` | `/fermentations` | Lista de todos los lotes de fermentación |
| `FermentationDetailView` | `/fermentation` | Detalle de un lote específico |

---

## Componentes

### Lista de fermentaciones

| Componente | Propósito |
|---|---|
| `FermentationSearchBar` | Barra de búsqueda de lotes |
| `FermentationFilterBar` | Filtros por estado, fecha, etc. |
| `FermentationInfoBanner` | Banner informativo sobre fermentaciones |
| `FermentationListItem` | Item de lista de un lote |

### Detalle de fermentación

| Componente | Propósito |
|---|---|
| `FermentationDetailStatusCard` | Estado actual de la fermentación |
| `FermentationDetailMetricsGrid` | Grid de métricas del lote |
| `FermentationDetailMetricCard` | Tarjeta individual de métrica |
| `FermentationDetailChartCard` | Gráfica de la fermentación |
| `FermentationEventsSection` | Sección de eventos del lote |
| `FermentationEventItem` | Item de evento individual |

---

## Providers

| Provider | Tipo | Propósito |
|---|---|---|
| `FermentationListProvider` | `ChangeNotifier` | Gestión de la lista de lotes |
| `FermentationDetailProvider` | `ChangeNotifier` | Gestión del detalle de un lote |

---

## Entidades de dominio

| Entidad | Propósito |
|---|---|
| `ActiveFermentationSession` | Datos de la fermentación activa |
| `FermentationDetail` | Detalle completo de un lote |
| `FermentationEvent` | Evento registrado en la fermentación |
| `FermentationFilter` | Filtros de búsqueda |

---

## Capa de datos

### Endpoints utilizados

| Método | Endpoint | Descripción |
|---|---|---|
| `GET` | `/fermentation/active` | Fermentación activa del usuario |
| `GET` | `/fermentation/sessions` | Lista de todos los lotes |
| `GET` | `/fermentation/history` | Historial de fermentaciones |
| `POST` | `/fermentation/{sessionId}/predict-now` | Solicitar predicción inmediata |

### Repositorios

| Repositorio | Propósito |
|---|---|
| `ActiveFermentationRepository` | Acceso a fermentación activa |
| `FermentationBatchesRepository` | Acceso a lista de lotes |

---

## Utilidades

| Archivo | Propósito |
|---|---|
| `fermentation_progress.dart` | Cálculo de progreso de fermentación |
| `fermentation_time_info.dart` | Información de tiempo de fermentación |
| `status_color.dart` | Color asociado a cada estado |
| `status_label.dart` | Label de texto para cada estado |

---

## Enlaces

- [← Autenticación](auth.md)
- [Sensores →](sensors.md)
