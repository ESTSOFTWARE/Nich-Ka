# Configuración, Dependencias y Variables de Entorno

Documento técnico que describe las variables de entorno, dependencias, librerías y configuración del proyecto Nich-Ká.

> **Versión documentada:** `1.0.0+22`

---

## Índice

- [Variables de entorno](#variables-de-entorno)
- [Dependencias principales](#dependencias-principales)
- [Dependencias de desarrollo](#dependencias-de-desarrollo)
- [Configuración de Firebase](#configuración-de-firebase)
- [Configuración de Android](#configuración-de-android)
- [Configuración de Flutter](#configuración-de-flutter)

---

## Variables de entorno

Las variables de entorno se definen en el archivo `.env` en la raíz del proyecto y se leen en tiempo de compilación mediante `String.fromEnvironment()`.

| Variable | Descripción | Ejemplo |
|---|---|---|
| `BASE_URL` | URL base del backend API REST | `https://api.nich-ka.space/api` |
| `GROQ_API_KEY` | API key del servicio Groq para el asistente IA | `gsk_...` |

### Archivo `.env`

```
GROQ_API_KEY=gsk_xxxxxxxxxxxxxxxx
BASE_URL=https://api.nich-ka.space/api
```

> **Importante:** El archivo `.env` NO debe commitearse al repositorio. Está incluido en `.gitignore`.

### Uso en código

Las variables se inyectan en tiempo de compilación:

```dart
// core/network/http_client.dart
static const String _baseUrl = String.fromEnvironment('BASE_URL');

// features/chat/data/groq_api_service.dart
const _apiKey = String.fromEnvironment('GROQ_API_KEY', defaultValue: '');
```

### URL del WebSocket

La URL de WebSocket se deriva automáticamente de `BASE_URL`:

```dart
// core/network/http_client.dart
static String get wsBaseUrl => _baseUrl
    .replaceFirst(RegExp(r'^http'), 'ws')
    .replaceFirst(RegExp(r'/api/?$'), '');
```

Ejemplo: `https://api.nich-ka.space/api` → `wss://api.nich-ka.space`

---

## Dependencias principales

Listado de dependencias del `pubspec.yaml` organizadas por categoría:

### Flutter SDK

| Paquete | Versión | Propósito |
|---|---|---|
| `flutter` | SDK | Framework UI |
| `cupertino_icons` | ^1.0.8 | Iconos iOS-style |

### Navegación

| Paquete | Versión | Propósito |
|---|---|---|
| `go_router` | ^17.3.0 | Sistema de rutas declarativo con deep links |

### Gestión de estado

| Paquete | Versión | Propósito |
|---|---|---|
| `provider` | ^6.1.5+1 | Gestión de estado principal (MVVM) |
| `flutter_riverpod` | ^2.6.1 | State management alternativo para features específicas |

### Networking

| Paquete | Versión | Propósito |
|---|---|---|
| `http` | ^1.6.0 | Cliente HTTP para peticiones REST |
| `http_parser` | ^4.0.2 | Parser de content-type HTTP |
| `web_socket_channel` | ^3.0.3 | Conexiones WebSocket en tiempo real |

### UI y visualización

| Paquete | Versión | Propósito |
|---|---|---|
| `google_fonts` | ^8.1.0 | Tipografías Google Fonts |
| `flutter_svg` | ^2.3.0 | Renderizado de archivos SVG |
| `fl_chart` | ^0.71.0 | Gráficas y charts |
| `flutter_markdown` | ^0.7.7+1 | Renderizado de Markdown |
| `device_preview` | ^1.2.0 | Preview responsivo en desarrollo |
| `emoji_picker_flutter` | ^4.4.0 | Selector de emojis |

### Autenticación y seguridad

| Paquete | Versión | Propósito |
|---|---|---|
| `google_sign_in` | ^6.2.1 | Login con cuenta Google |
| `local_auth` | ^2.3.0 | Autenticación biométrica (huella/rostro) |
| `flutter_secure_storage` | ^9.2.2 | Almacenamiento seguro de tokens |

### Firebase

| Paquete | Versión | Propósito |
|---|---|---|
| `firebase_core` | ^3.6.0 | Inicialización de Firebase |
| `firebase_messaging` | ^15.1.3 | Notificaciones push (FCM) |
| `flutter_local_notifications` | ^18.0.0 | Notificaciones locales en primer plano |

### Almacenamiento y archivos

| Paquete | Versión | Propósito |
|---|---|---|
| `shared_preferences` | ^2.3.2 | Almacenamiento clave-valor simple |
| `path_provider` | ^2.1.6 | Rutas del sistema de archivos |
| `file_picker` | ^8.0.0 | Selector de archivos |
| `open_filex` | ^4.5.0 | Apertura de archivos externos |
| `image_picker` | ^1.1.2 | Selección de imágenes de galería/cámara |

### Multimedia

| Paquete | Versión | Propósito |
|---|---|---|
| `audioplayers` | ^6.1.0 | Reproducción de efectos de sonido |
| `mobile_scanner` | ^7.0.0 | Escaneo de códigos QR |

### Utilidades

| Paquete | Versión | Propósito |
|---|---|---|
| `url_launcher` | ^6.3.0 | Apertura de URLs externas |

---

## Dependencias de desarrollo

| Paquete | Versión | Propósito |
|---|---|---|
| `flutter_test` | SDK | Framework de pruebas |
| `flutter_lints` | ^6.0.0 | Reglas de linting |
| `flutter_launcher_icons` | ^0.14.3 | Generación de iconos de launcher |

---

## Configuración de Firebase

### Archivos de configuración

- `android/app/google-services.json` — Configuración de Firebase para Android

### Servicios utilizados

| Servicio | Paquete | Uso |
|---|---|---|
| Firebase Core | `firebase_core` | Inicialización |
| Cloud Messaging | `firebase_messaging` | Notificaciones push |

### Inicialización

Firebase se inicializa solo en plataformas móviles (no en web):

```dart
// main.dart
if (!kIsWeb) {
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  await PushService.instance.initLocalNotifications();
}
```

---

## Configuración de Android

### `android/app/build.gradle.kts`

| Propiedad | Valor |
|---|---|
| `applicationId` | `com.nichka.app` |
| `namespace` | `com.nichka.nich_ka` |
| `compileSdk` | Flutter compileSdkVersion |
| `minSdk` | Flutter minSdkVersion |
| `targetSdk` | Flutter.targetSdkVersion |
| Java/Kotlin version | 17 |
| Core Library Desugaring | `com.android.tools:desugar_jdk_libs:2.1.4` |

### `android/settings.gradle.kts`

| Plugin | Versión |
|---|---|
| Android Gradle Plugin | 8.11.1 |
| Kotlin Android | 2.2.20 |
| Google Services | 4.4.2 |
| Flutter Plugin Loader | 1.0.0 |

### `android/gradle.properties`

```properties
org.gradle.jvmargs=-Xmx8G -XX:MaxMetaspaceSize=4G -XX:ReservedCodeCacheSize=512m -XX:+HeapDumpOnOutOfMemoryError
android.useAndroidX=true
```

### Signing (Release)

Si existe `android/key.properties`, se usa para firmar el release build:

```properties
keyAlias=...
keyPassword=...
storeFile=...
storePassword=...
```

Si no existe, se usa la configuración de debug.

---

## Configuración de Flutter

### `pubspec.yaml`

| Campo | Valor |
|---|---|
| `name` | `nich_ka` |
| `version` | `1.0.0+22` |
| `sdk` | `^3.11.5` |
| `publish_to` | `none` (paquete privado) |

### `flutter_launcher_icons`

```yaml
flutter_launcher_icons:
  android: true
  ios: false
  image_path: "assets/img/logo_launcher.png"
  adaptive_icon_background: "#0A0A0B"
  adaptive_icon_foreground: "assets/img/logo_launcher.png"
  min_sdk_android: 21
```

### `analysis_options.yaml`

Reglas de análisis estático de Dart para mantener calidad de código.

---

## Enlaces

- [← Estructura del proyecto](project-structure.md)
- [Navegación →](navigation.md)
