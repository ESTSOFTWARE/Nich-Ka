# Estructura del Proyecto

Documento que describe la organización de carpetas, módulos y la estructura de archivos del código fuente de Nich-Ká.

> **Versión documentada:** `1.0.0+22`

---

## Índice

- [Visión general](#visión-general)
- [Estructura raíz](#estructura-raíz)
- [Árbol completo de `lib/`](#árbol-completo-de-lib)
- [Capa Core](#capa-core)
- [Capa Features](#capa-features)
- [Capa Shared](#capa-shared)
- [Assets](#assets)
- [Configuración nativa Android](#configuración-nativa-android)
- [Configuración Web](#configuración-web)
- [CI/CD](#cicd)

---

## Visión general

El proyecto sigue el patrón de **Vertical Slicing (Screaming Architecture)**, donde la estructura de carpetas refleja el dominio de negocio de inmediato. Cada feature es un módulo vertical completo con sus propias capas de Clean Architecture.

---

## Estructura raíz

```
nich_ka/
├── android/                   # Configuración nativa Android (Gradle, Kotlin)
├── assets/                    # Recursos estáticos de la aplicación
│   ├── img/                   # Imágenes (logo, perfil, launcher)
│   ├── icons/                 # Iconos SVG
│   ├── sounds/                # Archivos de audio (notificaciones, mensajes)
│   └── stickers/              # Packs de stickers organizados por categoría
├── lib/                       # Código fuente Dart/Flutter
├── docs/                      # Documentación técnica (Markdown + Mermaid)
├── test/                      # Pruebas unitarias y de widgets
├── web/                       # Configuración para Flutter Web
├── .github/                   # Configuración de GitHub Actions (CI)
├── pubspec.yaml               # Dependencias y metadata del proyecto
├── pubspec.lock               # Lockfile de dependencias
├── analysis_options.yaml      # Reglas de análisis estático de Dart
├── .env                       # Variables de entorno (no commitear)
├── .gitignore                 # Archivos ignorados por Git
└── README.md                  # Documentación principal
```

---

## Árbol completo de `lib/`

```
lib/
├── main.dart                          # Punto de entrada (Firebase, ProviderScope)
├── app.dart                           # Widget raíz (MultiProvider + MaterialApp)
├── app_content.dart                   # Part de app.dart (_AppContent)
│
├── core/                              # Servicios globales compartidos
│   ├── audio/                         # Servicio de sonidos
│   │   ├── active_chat.dart           # Identificador del chat activo
│   │   └── sound_service.dart         # Reproductor de efectos de sonido
│   ├── auth/                          # Autenticación y sesión
│   │   ├── biometric_service.dart     # Servicio de huella/rostro (local_auth)
│   │   └── session_manager.dart       # Guardado/restauración de sesión (SecureStorage)
│   ├── errors/                        # Manejo centralizado de errores (futuro)
│   ├── navigation/                    # Lógica de navegación de entrada
│   │   └── entry_route.dart           # Decisión de ruta tras login
│   ├── network/                       # Cliente HTTP centralizado
│   │   └── http_client.dart           # Singleton con manejo de tokens y headers
│   ├── presentation/                  # Componentes de presentación globales
│   │   ├── app_theme_provider.dart    # Provider de tema (light/dark/system)
│   │   ├── app_theme_scope.dart       # InheritedWidget para tema
│   │   ├── change_notifier_provider.dart
│   │   ├── theme_choice.dart          # Enum: light, dark, system
│   │   └── ui_state.dart             # Sealed class UiState<T>
│   ├── providers/                     # Providers globales
│   │   └── auth_provider.dart         # Estado de autenticación (AuthProvider)
│   ├── push/                          # Notificaciones push
│   │   └── push_service.dart          # Firebase Cloud Messaging + notificaciones locales
│   ├── router/                        # Sistema de rutas
│   │   └── app_router.dart            # GoRouter con todas las rutas definidas
│   ├── session/                       # Sesión del usuario
│   │   └── current_user_avatar.dart   # Fuente única del avatar (ValueNotifier)
│   ├── theme/                         # Tema de la aplicación
│   │   ├── app_colors.dart            # Colores personalizados
│   │   └── app_theme.dart             # ThemeData light/dark con Material 3
│   ├── utils/                         # Utilidades generales
│   │   └── server_date.dart           # Parseo de fechas del servidor
│   └── validation/                    # Validadores
│       └── validators.dart            # Email, password, nombre, etc.
│
├── features/                          # Módulos de negocio (vertical slicing)
│   ├── auth/                          # Autenticación
│   ├── home/                          # Dashboard principal
│   ├── chat/                          # Asistente IA (Groq)
│   ├── fermentation/                  # Lotes de fermentación
│   ├── sensors/                       # Sensores en tiempo real
│   ├── messages/                      # Mensajería grupal
│   ├── notifications/                 # Notificaciones WebSocket
│   ├── reports/                       # Reportes y análisis
│   ├── class/                         # Gestión de clases
│   ├── profile/                       # Perfil de usuario
│   ├── calculator/                    # Calculadora de eficiencia
│   ├── simulator/                     # Simulador de fermentación
│   └── legal/                         # Documentos legales
│
└── shared/                            # Componentes y utilidades compartidas
    ├── components/                    # Widgets reutilizables
    ├── pages/                         # Páginas compartidas
    ├── providers/                     # Providers compartidos
    ├── theme/                         # Paleta de colores global
    └── utils/                         # Utilidades de navegación
```

---

## Capa Core

### `core/router/app_router.dart`

Define todas las rutas de la aplicación usando **GoRouter**. El punto de entrada es `/gate` (SplashGateView) que decide si redirigir a `/login` o a la pantalla principal.

Rutas principales:

| Ruta | Pantalla |
|---|---|
| `/gate` | SplashGateView (decisión de sesión) |
| `/login` | LoginView (selección de método) |
| `/login-email` | LoginEmailView (login con email/password) |
| `/` | HomeStudentView (dashboard estudiante) |
| `/home` | HomeView (dashboard con fermentación activa) |
| `/fermentations` | FermentationListView |
| `/fermentation` | FermentationDetailView |
| `/sensors` | SensorsView |
| `/messages` | MessagesView |
| `/chat` | ChatView (asistente IA) |
| `/reports` | ReportsView |
| `/classes` | ClassListView |
| `/profile` | ProfileView |
| `/notifications` | NotificationsView |
| `/simulator` | SimulatorView |
| `/calculator` | CalculatorView |
| `/join?code=...` | JoinClassView (deep link) |

### `core/network/http_client.dart`

Singleton `HttpClient` que centraliza todas las peticiones HTTP:

- Gestión automática de headers (`Authorization: Bearer <token>`)
- Métodos: `get`, `post`, `put`, `patch`, `delete`, `postMultipart`
- Manejo de tokens: `setTokens()`, `setAccessToken()`, `clearTokens()`
- URL del WebSocket derivada de la URL base

### `core/auth/session_manager.dart`

Singleton `SessionManager` que persiste la sesión del usuario de forma segura:

- Guarda refresh token + datos del usuario en `FlutterSecureStorage`
- `restore()`: renueva el access token usando el refresh token guardado
- Permite re-login automático con biometría sin credenciales

### `core/push/push_service.dart`

Singleton `PushService` para notificaciones push:

- Inicializa Firebase Cloud Messaging
- Registra token FCM en el backend
- Muestra notificaciones en primer plano con `flutter_local_notifications`
- Maneja navegación al tocar una notificación (chat, fermentaciones)
- Soporte para archivos adjuntos (abrir con `open_filex`)

---

## Capa Features

Cada feature sigue la estructura interna:

```
feature/
├── data/
│   ├── datasource/
│   │   ├── remote/
│   │   │   ├── mapper/          # Conversión DTO → Entity
│   │   │   ├── model/
│   │   │   │   ├── dto/
│   │   │   │   │   ├── request/ # DTOs de request
│   │   │   │   │   └── response/# DTOs de response
│   │   │   │   └── ...          # Modelos externos
│   │   │   └── *datasource.dart  # Fuente de datos remota
│   │   └── local/               # Fuente de datos local
│   ├── repositories/            # Implementación de repositorios
│   └── services/                # Servicios de infraestructura
├── domain/
│   ├── entities/                # Entidades de negocio puras
│   ├── use_cases/               # Casos de uso
│   └── repositories/            # Contratos (interfaces)
├── presentation/
│   ├── pages/                   # Pantallas principales
│   ├── components/              # Widgets exclusivos
│   ├── providers/               # ViewModels (ChangeNotifier)
│   ├── states/                  # UiState sealed class
│   └── theme/                   # Paleta de colores (opcional)
├── di/                          # Inyección de dependencias
└── utils/                       # Utilidades específicas de la feature
```

### Features con estructura completa

| Feature | Domain | Data | Presentation | DI |
|---|---|---|---|---|
| `auth` | ✅ | ✅ | ✅ | ✅ |
| `home` | ✅ | parcial | ✅ | — |
| `chat` | ✅ | ✅ | ✅ | ✅ |
| `fermentation` | ✅ | ✅ | ✅ | ✅ |
| `sensors` | ✅ | ✅ | ✅ | ✅ |
| `messages` | ✅ | ✅ | ✅ | ✅ |
| `notifications` | ✅ | ✅ | ✅ | ✅ |
| `reports` | ✅ | ✅ | ✅ | ✅ |
| `class` | ✅ | ✅ | ✅ | ✅ |
| `profile` | ✅ | ✅ | ✅ | ✅ |
| `calculator` | — | — | ✅ | — |
| `simulator` | ✅ | — | ✅ | — |
| `legal` | ✅ | ✅ | ✅ | — |

---

## Capa Shared

### `shared/components/`

Widgets reutilizables en múltiples features:

| Componente | Propósito |
|---|---|
| `app_drawer.dart` | Drawer lateral con menú de navegación |
| `app_drawer_item.dart` | Enum de items del drawer |
| `app_drawer_header.dart` | Cabecera del drawer (avatar, nombre, rol) |
| `bottom_nav_bar.dart` | Barra de navegación inferior |
| `app_tab.dart` | Enum de tabs: Inicio, Lotes, Sensores, Asistente |
| `main_app_bar.dart` | AppBar principal reutilizable |
| `circle_icon_button.dart` | Botón circular con icono |
| `drawer_menu_item.dart` | Item de menú del drawer |
| `drawer_bottom_action.dart` | Acción inferior del drawer (config, logout) |
| `full_screen_image_viewer.dart` | Visor de imágenes a pantalla completa |
| `tab_icon.dart` | Icono de cada tab |

### `shared/utils/`

Utilidades de navegación:

| Archivo | Propósito |
|---|---|
| `drawer_navigation.dart` | Navegación del drawer (switch por AppDrawerItem) |
| `bottom_nav_navigation.dart` | Navegación del bottom nav (switch por AppTab) |
| `go_home.dart` | Lógica para volver al home (con o sin fermentación activa) |
| `save_file.dart` | Guardado de archivos en el dispositivo |

---

## Assets

```
assets/
├── img/
│   ├── logo_launcher.png         # Icono de launcher
│   ├── nich-ka-animado.png       # Logo animado
│   └── profile.png               # Imagen de perfil por defecto
├── icons/
│   ├── logo.svg                  # Logo principal
│   ├── home.svg, ia.svg, ...     # Iconos de features
│   ├── google.svg, gmail.svg     # Iconos de autenticación
│   ├── eye.svg, eye-slash.svg    # Iconos de visibilidad
│   └── dark.svg, light.svg       # Iconos de tema
├── sounds/
│   ├── send_message.mp3          # Sonido de envío
│   ├── sound_message.mp3         # Sonido de mensaje recibido
│   ├── sound_notification.mp3    # Sonido de notificación
│   └── sound_response_message.mp3
└── stickers/
    ├── emotions/                  # Happy, sad, love, etc.
    ├── angry/                     # Stickers de enojo
    ├── fun/, funny/, dizzy/       # Stickers divertidos
    ├── astonished/                # Sorprendido
    ├── reactions/                 # Reacciones
    └── animations/                # Stickers animados
```

---

## Configuración nativa Android

### `android/app/build.gradle.kts`

- **applicationId**: `com.nichka.app`
- **namespace**: `com.nichka.nich_ka`
- **compileSdk**: Flutter compileSdkVersion
- **minSdk**: Flutter minSdkVersion
- **Java/Kotlin**: VERSION_17
- **Google Services plugin** habilitado
- **Signing**: Lee `key.properties` si existe para release builds

### `android/app/src/main/AndroidManifest.xml`

Permisos solicitados:

| Permiso | Uso |
|---|---|
| `CAMERA` | Escaneo de códigos QR |
| `READ_MEDIA_IMAGES` | Galería (Android 13+) |
| `READ_EXTERNAL_STORAGE` | Galería (Android ≤12) |
| `POST_NOTIFICATIONS` | Notificaciones push |
| `USE_BIOMETRIC` | Login con huella |

Deep link configurado: `https://nich-ka.space/join?code=...`

### `android/settings.gradle.kts`

- Android Gradle Plugin 8.11.1
- Kotlin 2.2.20
- Google Services 4.4.2

---

## Configuración Web

`web/manifest.json` configura la app como PWA con:

- Display: standalone
- Orientation: portrait-primary
- Iconos maskable 192x192 y 512x512

---

## CI/CD

`.github/workflows/ci.yml` ejecuta en push/PR a `main` o `develop`:

1. **Lint**: `dart format` + `flutter analyze`
2. **Build and Test**: `flutter test --coverage` + `flutter build apk --debug`

Flutter version: `3.41.9` (stable channel)

---

## Enlaces

- [← Arquitectura](architecture.md)
- [Configuración →](configuration.md)
