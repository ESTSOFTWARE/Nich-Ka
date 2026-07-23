# Módulo: Dashboard (Home)

Documentación del módulo de Dashboard / Home, que incluye la vista principal del estudiante, el asistente IA y el resumen de fermentaciones.

> **Ubicación:** `lib/features/home/`

---

## Índice

- [Descripción](#descripción)
- [Pantallas](#pantallas)
- [Componentes](#componentes)
- [Providers](#providers)
- [Entidades de dominio](#entidades-de-dominio)
- [Flujo de datos](#flujo-de-datos)

---

## Descripción

El módulo Home es la pantalla principal de la aplicación. Presenta dos variantes según el estado del usuario:

- **HomeStudentView** (`/`): Dashboard general cuando no hay fermentación activa
- **HomeView** (`/home`): Dashboard con fermentación activa en curso

Ambas variantes incluyen acceso rápido a las funcionalidades principales y un asistente de IA contextual.

---

## Pantallas

| Pantalla | Ruta | Descripción |
|---|---|---|
| `HomeStudentView` | `/` | Dashboard principal del estudiante |
| `HomeView` | `/home` | Dashboard con fermentación activa |
| `OverviewView` | `/overview` | Resumen general de datos |
| `AssistantView` | `/assistant` | Asistente IA embebido en home |
| `AssistantEmptyView` | `/assistant-empty` | Estado vacío del asistente |

---

## Componentes

### Tarjetas principales

| Componente | Propósito |
|---|---|
| `ActiveFermentationCard` | Muestra la fermentación activa actual |
| `ActiveFermentationSummary` | Resumen de métricas de la fermentación activa |
| `FermentationProgressCard` | Barra de progreso de la fermentación |
| `FermentationProgressList` | Lista de fermentaciones en progreso |
| `FermentationChart` | Gráfica de curva de fermentación |
| `FermentationCurveCard` | Tarjeta con la curva de fermentación |

### Asistente IA

| Componente | Propósito |
|---|---|
| `AiMessageCard` | Mensaje del asistente IA |
| `AiRecommendationCard` | Recomendación de IA |
| `AiCardHeader` | Cabecera del chat de IA |
| `AiCardMessage` | burbuja de mensaje de IA |
| `AiCardWelcomeMessage` | Mensaje de bienvenida del asistente |
| `ChatInputField` | Campo de entrada para el chat |
| `AssistantEmptyState` | Estado vacío cuando no hay datos |
| `AssistantMetricChip` | Chip con métrica del asistente |

### Widgets de datos

| Componente | Propósito |
|---|---|
| `MetricsGrid` | Grid de métricas principales |
| `MetricTile` | Tile individual de métrica |
| `StatsOverviewGrid` | Grid de estadísticas |
| `SummaryStatCard` | Tarjeta de estadística resumen |
| `HomeFeatureItem` | Item de feature accesible desde home |
| `SuggestionsGrid` | Grid de sugerencias rápidas |
| `SuggestionChip` | Chip de sugerencia individual |
| `QuickActionsRow` | Fila de acciones rápidas |
| `QuickActionButton` | Botón de acción rápida |

### Gráficas

| Componente | Propósito |
|---|---|
| `ChartPainter` | Painter personalizado para gráficas |
| `ChartLegendItem` | Item de leyenda de gráfica |
| `CircularProgressRing` | Anillo de progreso circular |
| `ProgressRingPainter` | Painter del anillo de progreso |
| `RingPainter` | Painter genérico de anillos |

---

## Providers

| Provider | Tipo | Propósito |
|---|---|---|
| `HomeProvider` | `ChangeNotifier` | Datos del dashboard principal |
| `HomeStudentProvider` | `ChangeNotifier` | Dashboard del estudiante |
| `OverviewProvider` | `ChangeNotifier` | Datos de overview |
| `AssistantProvider` | `ChangeNotifier` | Estado del chat con asistente IA |

---

## Entidades de dominio

| Entidad | Campos |
|---|---|
| `ActiveFermentation` | Datos de la fermentación en curso |
| `AiRecommendation` | Recomendación generada por IA |
| `ChartPoint` | Punto para gráficas (x, y) |
| `DashboardStat` | Estadística del dashboard |
| `FermentationCard` | Datos para tarjeta de fermentación |
| `FermentationItem` | Elemento de lista de fermentación |
| `FermentationMetric` | Métrica de fermentación |
| `HomeFeature` | Feature accesible desde home |

---

## Flujo de datos

```mermaid
flowchart TD
    App[App Inicia] --> Gate{resolveEntryRoute}
    Gate -->|Fermentación activa| HomeView[/home<br/>HomeView]
    Gate -->|Sin fermentación| HomeStudent[/ <br/>HomeStudentView]
    
    HomeView --> HomeProvider[HomeProvider]
    HomeProvider -->|GET /fermentation/active| API[Backend API]
    HomeProvider -->|POST /fermentation/{id}/predict-now| API
    
    HomeStudent --> HomeStudentProvider[HomeStudentProvider]
    HomeStudentProvider -->|GET /fermentation/sessions| API
    
    HomeView --> AssistantProvider[AssistantProvider]
    AssistantProvider -->|Groq API| Groq[Groq AI]
```

---

## Enlaces

- [← Despliegue](../deployment.md)
- [Módulo Autenticación →](auth.md)
