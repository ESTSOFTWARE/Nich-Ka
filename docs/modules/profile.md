# Módulo: Perfil

Documentación del módulo de Perfil, que incluye la visualización y edición del perfil de usuario, configuración de tema y cierre de sesión.

> **Ubicación:** `lib/features/profile/`

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

El módulo de perfil permite a los usuarios ver y editar su información personal, cambiar la foto de perfil, configurar el tema de la aplicación (claro/oscuro/sistema) y cerrar sesión.

---

## Pantallas

| Pantalla | Ruta | Descripción |
|---|---|---|
| `ProfileView` | `/profile` | Vista principal del perfil |

---

## Componentes

| Componente | Propósito |
|---|---|
| `ProfileHeaderCard` | Card principal con avatar y nombre |
| `ProfileInfoRow` | Fila de información (email, rol, etc.) |
| `ProfileSection` | Sección agrupada de opciones |
| `ProfileTileRow` | Fila de opción con icono |
| `EditButton` | Botón de edición |
| `RoleBadge` | Badge del rol del usuario |
| `TopGlow` | Efecto visual superior |
| `ThemeModeSelector` | Selector de modo de tema |
| `ThemeSegment` | Segmento individual del selector |
| `ThemeToggle` | Toggle de tema claro/oscuro |

---

## Providers

| Provider | Tipo | Propósito |
|---|---|---|
| `ProfileProvider` | `ChangeNotifier` | Datos del perfil |
| `DrawerProvider` | `ChangeNotifier` | Estado del drawer |

---

## Entidades de dominio

| Entidad | Propósito |
|---|---|
| `ProfileUser` | Datos del usuario (nombre, email, rol, imagen) |

---

## Capa de datos

### Endpoints utilizados

| Método | Endpoint | Descripción |
|---|---|---|
| `GET` | `/users/me` | Obtener perfil del usuario |
| `GET` | `/users/{userId}` | Obtener perfil de otro usuario |
| `PUT` | `/users/{userId}` | Actualizar datos del usuario |
| `POST` | `/users/me/profile-image` | Subir imagen de perfil (multipart) |

---

## Configuración de tema

El perfil permite seleccionar entre 3 modos de tema:

| Modo | Comportamiento |
|---|---|
| `light` | Tema claro forzado |
| `dark` | Tema oscuro forzado |
| `system` | Sigue la configuración del dispositivo |

La preferencia se persiste en `SharedPreferences` con la clave `theme_choice`.

### Gestión del tema global

El `AppThemeProvider` (en `core/presentation/`) gestiona el estado del tema:

```dart
class AppThemeProvider extends ChangeNotifier with WidgetsBindingObserver {
  ThemeChoice _choice = ThemeChoice.system;
  
  ThemeMode get themeMode => switch (_choice) {
    ThemeChoice.light => ThemeMode.light,
    ThemeChoice.dark => ThemeMode.dark,
    ThemeChoice.system => ThemeMode.system,
  };
  
  bool get isDark { ... }
}
```

---

## Paleta de colores

Cada feature puede definir su propia paleta. El perfil usa `ProfilePalette`:

```dart
// features/profile/presentation/theme/profile_palette.dart
```

La paleta global está en `shared/theme/app_palette.dart` y se adapta automáticamente al tema claro/oscuro.

---

## Enlaces

- [← Clases](classes.md)
- [Volver al índice](../README.md)
