# Módulo: Clases

Documentación del módulo de Clases, que incluye la gestión académica, unión por código/QR y visualización de miembros.

> **Ubicación:** `lib/features/class/`

---

## Índice

- [Descripción](#descripción)
- [Pantallas](#pantallas)
- [Componentes](#componentes)
- [Providers](#providers)
- [Entidades de dominio](#entidades-de-dominio)
- [Capa de datos](#capa-de-datos)
- [Deep links](#deep-links)

---

## Descripción

El módulo de clases permite a los estudiantes unirse a grupos académicos mediante códigos o escaneo de QR. Cada clase tiene miembros, fermentaciones asociadas y un profesor responsable.

---

## Pantallas

| Pantalla | Ruta | Descripción |
|---|---|---|
| `ClassListView` | `/classes` | Lista de clases del usuario |
| `ClassDetailView` | `/class-detail` | Detalle de una clase |
| `ClassMembersView` | `/class-members` | Lista de miembros de la clase |
| `JoinClassView` | `/class` o `/join` | Unirse a una clase por código o QR |

---

## Componentes

### Lista de clases

| Componente | Propósito |
|---|---|
| `ClassesHeader` | Cabecera de la lista |
| `ClassCard` | Tarjeta de cada clase |
| `ClassesSkeleton` | Skeleton de carga |
| `ClassesErrorState` | Estado de error |
| `EmptyClassesState` | Estado vacío |

### Detalle de clase

| Componente | Propósito |
|---|---|
| `ClassDetailHeroCard` | Card principal con info de la clase |
| `ClassDetailStatsRow` | Fila de estadísticas |
| `ClassStatTile` | Tile de estadística |
| `ClassTeacherCard` | Card del profesor |
| `ClassMembersRow` | Fila de avatares de miembros |
| `ClassMemberAvatar` | Avatar de miembro |
| `ClassFermentationItem` | Item de fermentación de la clase |

### Unirse a clase

| Componente | Propósito |
|---|---|
| `ClassCodeInput` | Campo de entrada de código |
| `JoinClassDivider` | Divisor visual |
| `QrScannerFrame` | Marco de escaneo QR |
| `QrCornersPainter` | Painter de esquinas del QR |
| `QrWebPlaceholder` | Placeholder para web (sin cámara) |

---

## Providers

| Provider | Tipo | Propósito |
|---|---|---|
| `ClassListProvider` | `ChangeNotifier` | Lista de clases |
| `ClassDetailProvider` | `ChangeNotifier` | Detalle de una clase |
| `JoinClassProvider` | `ChangeNotifier` | Unión a una clase |

---

## Entidades de dominio

| Entidad | Propósito |
|---|---|
| `ClassItem` | Resumen de una clase |
| `ClassSummary` | Resumen con estadísticas |
| `ClassDetail` | Detalle completo de la clase |
| `ClassMember` | Miembro de la clase |
| `ClassFermentation` | Fermentación asociada a la clase |

---

## Capa de datos

### Endpoints utilizados

| Método | Endpoint | Descripción |
|---|---|---|
| `GET` | `/groups/me` | Clases del usuario |
| `POST` | `/groups/join` | Unirse a una clase por código |
| `GET` | `/fermentation/sessions` | Sesiones de fermentación |

### Datasources

| Datasource | Propósito |
|---|---|
| `ClassRemoteDataSource` | Datos remotos de clases |
| `ClassLocalDataSource` | Cache local de clases |

---

## Deep links

La app soporta deep links para unirse a clases:

```
https://nich-ka.space/join?code=XXXX
```

**Comportamiento:**
1. Sin sesión → Guardar código y redirigir a `/login`
2. Con sesión → Abrir `JoinClassView` con el código
3. Rol != estudiante → Rechazar unión

---

## Enlaces

- [← Reportes](reports.md)
- [Perfil →](profile.md)
