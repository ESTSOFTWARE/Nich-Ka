# Instalación y Configuración del Entorno de Desarrollo

Guía paso a paso para instalar, configurar y ejecutar la aplicación Nich-Ká en un entorno de desarrollo local.

> **Versión documentada:** `1.0.0+22`

---

## Índice

- [Prerrequisitos](#prerrequisitos)
- [Clonar el repositorio](#clonar-el-repositorio)
- [Configurar Flutter](#configurar-flutter)
- [Instalar dependencias](#instalar-dependencias)
- [Configurar variables de entorno](#configurar-variables-de-entorno)
- [Configurar Firebase](#configurar-firebase)
- [Ejecutar la aplicación](#ejecutar-la-aplicación)
- [Comandos útiles](#comandos-útiles)
- [Solución de problemas](#solución-de-problemas)

---

## Prerrequisitos

### Herramientas obligatorias

| Herramienta | Versión mínima | Propósito |
|---|---|---|
| **Flutter SDK** | 3.41.9 (stable) | Framework de desarrollo |
| **Dart SDK** | ^3.11.5 | Lenguaje de programación |
| **Android Studio** | Hedgehog (2023.1.1) o superior | IDE y emulador Android |
| **Git** | 2.x | Control de versiones |

### Opcional

| Herramienta | Propósito |
|---|---|
| **VS Code** | IDE alternativo con extensiones de Flutter |
| **Chrome** | Ejecución en Flutter Web |
| **Dispositivo físico Android** | Pruebas en dispositivo real |

---

## Clonar el repositorio

```bash
git clone https://github.com/ESTSOFTWARE/nich_ka.git
cd nich_ka
```

---

## Configurar Flutter

### Instalar Flutter

Sigue la guía oficial: https://docs.flutter.dev/get-started/install

```bash
# Verificar instalación
flutter --version

# Debe mostrar Flutter 3.41.9 o superior
```

### Configurar para Android

1. Abrir Android Studio
2. Ir a **Settings → Languages & Frameworks → Android SDK**
3. Instalar SDK Platform API 34 o superior
4. Instalar Android SDK Build-Tools 34
5. Instalar Android SDK Command-line Tools

### Configurar para desarrollo

```bash
# Verificar que todo esté configurado
flutter doctor

# Salida esperada:
# [✓] Flutter (Channel stable, 3.41.9)
# [✓] Android toolchain
# [✓] Android Studio
# [✓] VS Code (opcional)
# [✓] Connected device
```

---

## Instalar dependencias

```bash
flutter pub get
```

Esto descargará todas las dependencias definidas en `pubspec.yaml`.

---

## Configurar variables de entorno

### Crear archivo `.env`

```bash
cp .env.example .env
```

### Editar `.env`

```env
GROQ_API_KEY=tu_api_key_de_groq_aqui
BASE_URL=https://api.nich-ka.space/api
```

### Obtener API Key de Groq

1. Visita https://console.groq.com
2. Crea una cuenta o inicia sesión
3. Ve a **API Keys** y genera una nueva clave
4. Copia la clave al archivo `.env`

> **Importante:** Nunca commitees el archivo `.env` al repositorio. Ya está en `.gitignore`.

---

## Configurar Firebase

### Archivos necesarios

El archivo `android/app/google-services.json` debe estar presente (ya incluido en el repositorio).

### Si necesitas regenerar

1. Ve a la consola de Firebase: https://console.firebase.google.com
2. Selecciona el proyecto de Nich-Ká
3. Ve a **Project Settings → General → Your apps**
4. Descarga el archivo `google-services.json`
5. Colócalo en `android/app/`

---

## Ejecutar la aplicación

### En emulador Android

```bash
# Listar dispositivos disponibles
flutter devices

# Ejecutar en emulador
flutter run
```

### En dispositivo físico

1. Habilitar **Depuración USB** en el dispositivo
2. Conectar por USB
3. Ejecutar:

```bash
flutter run
```

### Ejecutar en Web (Chrome)

```bash
flutter run -d chrome
```

> **Nota:** Algunas funcionalidades (Firebase, biometría, sensores) no están disponibles en web.

### Parámetros de compilación

```bash
# Pasar variables de entorno personalizadas
flutter run --dart-define=BASE_URL=https://api.nich-ka.space/api --dart-define=GROQ_API_KEY=tu_key
```

---

## Comandos útiles

### Desarrollo

```bash
# Ejecutar con hot reload
flutter run

# Ejecutar en modo debug con dispositivo específico
flutter run -d <device_id>

# Recargar dependencias
flutter pub get

# Actualizar dependencias a última versión
flutter pub upgrade
```

### Análisis de código

```bash
# Verificar formato
dart format --output=none --set-exit-if-changed lib/

# Análisis estático
flutter analyze lib/

# Corregir formato automáticamente
dart format lib/
```

### Pruebas

```bash
# Ejecutar todas las pruebas
flutter test

# Ejecutar pruebas con cobertura
flutter test --coverage

# Ver reporte de cobertura
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Build

```bash
# Build APK debug
flutter build apk --debug

# Build APK release
flutter build apk --release

# Build App Bundle (para Play Store)
flutter build appbundle --release
```

### Limpieza

```bash
# Limpiar build anterior
flutter clean

# Limpiar y reinstalar dependencias
flutter clean && flutter pub get
```

---

## Solución de problemas

### Errores comunes

| Problema | Solución |
|---|---|
| `flutter pub get` falla | Ejecutar `flutter clean` y volver a intentar |
| Error de SDK version | Verificar que Flutter 3.41.9+ esté instalado |
| Error de `google-services.json` | Verificar que el archivo esté en `android/app/` |
| Error de Java/JDK | Instalar JDK 17 y configurar `JAVA_HOME` |
| Error de Gradle | Ejecutar `flutter clean` y verificar `android/gradle.properties` |
| Error de WebSocket | Verificar que `BASE_URL` esté correctamente configurado |
| Push notifications no funcionan | Verificar que Firebase esté configurado y el dispositivo tenga Google Play Services |

### Verificar configuración

```bash
# Verificar Flutter
flutter doctor -v

# Verificar variables de entorno compiladas
flutter run --verbose | grep "dart-define"
```

---

## Enlaces

- [← Integración con APIs](api-integration.md)
- [Despliegue →](deployment.md)
