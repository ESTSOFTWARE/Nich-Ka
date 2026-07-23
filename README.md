# Nich-Ká — Aplicación Móvil

Aplicación móvil multiplataforma desarrollada en **Flutter** para la plataforma [Nich-Ká](https://nich-ka.space), orientada al monitoreo, análisis y optimización de la fermentación de café. Incluye asistente de IA, sensores en tiempo real, mensajería, gestión de clases y reportes.

> **Versión documentada:** `1.0.0+22` (según `pubspec.yaml`)

---

## Índice de documentación

| Documento | Contenido |
|---|---|
| [docs/architecture.md](docs/architecture.md) | Arquitectura de la aplicación, capas, patrones de diseño y responsabilidades |
| [docs/project-structure.md](docs/project-structure.md) | Estructura de carpetas, organización de módulos y convenciones del código fuente |
| [docs/configuration.md](docs/configuration.md) | Variables de entorno, dependencias, librerías y configuración del proyecto |
| [docs/navigation.md](docs/navigation.md) | Sistema de navegación, rutas, deep links y flujo entre pantallas |
| [docs/state-management.md](docs/state-management.md) | Gestión de estado con Provider y Riverpod, patrones de UiState |
| [docs/api-integration.md](docs/api-integration.md) | Comunicación HTTP, WebSocket, autenticación y conexión con servicios backend |
| [docs/installation.md](docs/installation.md) | Instalación local, configuración del entorno de desarrollo y ejecución |
| [docs/deployment.md](docs/deployment.md) | Compilación, generación de APK/AAB y proceso de despliegue |
| [docs/modules/dashboard.md](docs/modules/dashboard.md) | Módulo de Dashboard / Home — vista principal y asistente |
| [docs/modules/auth.md](docs/modules/auth.md) | Módulo de Autenticación — login, registro, biometría y sesión |
| [docs/modules/fermentation.md](docs/modules/fermentation.md) | Módulo de Fermentaciones — lotes, detalle y seguimiento |
| [docs/modules/sensors.md](docs/modules/sensors.md) | Módulo de Sensores — lecturas en tiempo real y gráficas |
| [docs/modules/messages.md](docs/modules/messages.md) | Módulo de Mensajes — chat grupal, conversaciones y stickers |
| [docs/modules/reports.md](docs/modules/reports.md) | Módulo de Reportes — historial, detalle, PDF y análisis NLP |
| [docs/modules/classes.md](docs/modules/classes.md) | Módulo de Clases — gestión académica, QR y miembros |
| [docs/modules/profile.md](docs/modules/profile.md) | Módulo de Perfil — usuario, configuración y tema |
| [docs/diagrams/](docs/diagrams/) | Diagramas Mermaid de arquitectura y flujos |

---

## Descripción general

Nich-Ká es una plataforma integral para la gestión y optimización de la fermentación de café. La aplicación móvil permite a los estudiantes:

1. **Monitorear fermentaciones activas** con datos de sensores en tiempo real (pH, temperatura, turbidez, conductividad, % de alcohol).
2. **Consultar un asistente de IA** (Nich-KáBot) especializado en fermentación de café, alimentado por el modelo Llama 3.1 vía Groq API.
3. **Gestionar clases y lotes** mediante códigos QR, unirse a grupos y seguir el progreso.
4. **Visualizar reportes** con análisis de eficiencia, métricas de sensores y resúmenes generados por NLP.
5. **Comunicarse** con compañeros mediante chat grupal con soporte de stickers, reacciones y archivos adjuntos.
6. **Simular fermentaciones** con parámetros ajustables y visualización de curvas.
7. **Calcular eficiencia** de procesamiento de café con fórmulas especializadas.

---

## Inicio rápido

```bash
git clone https://github.com/ESTSOFTWARE/nich_ka.git
cd nich_ka

flutter pub get

cp .env.example .env   # configurar BASE_URL y GROQ_API_KEY

flutter run
```

Guía completa de instalación y configuración: [docs/installation.md](docs/installation.md).

---

## Estructura del proyecto

```
nich_ka/
├── android/                  # Configuración nativa Android
├── assets/                   # Imágenes, iconos, sonidos y stickers
├── lib/
│   ├── core/                 # Configuración global, servicios compartidos
│   ├── features/             # Módulos de negocio (vertical slicing)
│   ├── shared/               # Componentes y utilidades reutilizables
│   ├── app.dart              # Widget raíz (MultiProvider + MaterialApp)
│   └── main.dart             # Punto de entrada
├── docs/                     # Documentación técnica
├── test/                     # Pruebas unitarias y de widgets
├── web/                      # Configuración para Flutter Web
├── pubspec.yaml              # Dependencias y configuración del proyecto
└── .env                      # Variables de entorno (no commitear)
```

Detalle completo: [docs/project-structure.md](docs/project-structure.md).

---

## Arquitectura

El proyecto combina **Clean Architecture** con **Vertical Slicing (Screaming Architecture)** y el patrón **MVVM** en la capa de presentación:

```
UI (View) → ViewModel (Provider) → Use Case → Repository Interface → Repository Impl → DataSource
```

Ver diagrama completo en [docs/architecture.md](docs/architecture.md).

---

## Tecnologías principales

| Categoría | Tecnología |
|---|---|
| Framework | Flutter 3.41.9 / Dart SDK ^3.11.5 |
| Navegación | GoRouter 17.3.0 |
| Estado | Provider 6.1.5 + flutter_riverpod 2.6.1 |
| Networking | http 1.6.0 + web_socket_channel 3.0.3 |
| Autenticación | google_sign_in 6.2.1 + local_auth 2.3.0 |
| Firebase | firebase_core 3.6.0 + firebase_messaging 15.1.3 |
| IA / Chat | Groq API (Llama 3.1 8B) |
| UI | google_fonts, fl_chart, flutter_svg, emoji_picker_flutter |
| Almacenamiento | flutter_secure_storage 9.2.2 + shared_preferences 2.3.2 |

Listado completo en [docs/configuration.md](docs/configuration.md).

---

## Enlaces internos

- [Arquitectura](docs/architecture.md)
- [Estructura del proyecto](docs/project-structure.md)
- [Configuración y dependencias](docs/configuration.md)
- [Navegación y rutas](docs/navigation.md)
- [Gestión de estado](docs/state-management.md)
- [Integración con APIs](docs/api-integration.md)
- [Instalación y desarrollo](docs/installation.md)
- [Despliegue y publicación](docs/deployment.md)
- [Módulo Dashboard](docs/modules/dashboard.md)
- [Módulo Autenticación](docs/modules/auth.md)
- [Módulo Fermentaciones](docs/modules/fermentation.md)
- [Módulo Sensores](docs/modules/sensors.md)
- [Módulo Mensajes](docs/modules/messages.md)
- [Módulo Reportes](docs/modules/reports.md)
- [Módulo Clases](docs/modules/classes.md)
- [Módulo Perfil](docs/modules/profile.md)
