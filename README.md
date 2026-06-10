# Nich-Ká Flutter App

Este proyecto contiene la aplicación móvil para Nich-Ká, desarrollada en Flutter. Se ha inicializado utilizando estándares que aseguran mantenibilidad y escalabilidad.

## Arquitectura Implementada

El proyecto sigue estrictamente un enfoque híbrido optimizado para aplicaciones robustas:
- **Clean Architecture:** Separación estricta de responsabilidades en capas.
- **Vertical Slicing & Screaming Architecture:** Organización basada en funcionalidades (*features*) que refleja el negocio inmediatamente al ver la estructura.
- **MVVM (Model-View-ViewModel):** Patrón de diseño para la capa de presentación, garantizando que la UI sea reactiva y "tonta".
- **Repository Pattern:** Abstracción de las fuentes de datos.

## Estructura de Carpetas

La aplicación está modularizada por funcionalidades (Features).

```text
lib/
├── core/                  # Configuraciones globales y setup inicial
│   ├── config/            # Variables de entorno (env)
│   ├── di/                # Inyección de dependencias (Service Locator / GetIt)
│   ├── errors/            # Manejo centralizado (Failures, Exceptions)
│   ├── network/           # Cliente HTTP centralizado (Ej. Dio interceptors)
│   ├── router/            # Sistema de rutas (Ej. GoRouter)
│   └── theme/             # Configuración de temas (Light/Dark mode)
├── shared/                # Componentes reutilizables en múltiples features
└── features/              # (Screaming Architecture)
    ├── auth/
    ├── dashboard/
    ├── fermentations/
    ├── groups/
    ├── products/
    ├── billing/
    ├── support/
    └── chat/

```

## Capas Internas de cada Feature

Cada feature es independiente y contiene exactamente 4 capas:

1. **Domain:** El núcleo del negocio. No depende de NADA (ni de Flutter ni de paquetes externos).
* `entities/`: Modelos de negocio puros.
* `value_objects/`: Tipos primitivos validados.
* `repositories/`: Contratos (Interfaces abstractas).


2. **Application:** Orquestación de la lógica.
* `use_cases/`: Casos de uso específicos (ej. `LoginUserUseCase`).
* `services/`: Servicios de aplicación si son requeridos.


3. **Infrastructure:** La comunicación con el mundo exterior.
* `datasources/`: APIs, Firebase, Bases de datos locales.
* `repositories/`: Implementación de los contratos de Domain.
* `dtos/` & `mappers/`: Modelos de datos externos y su conversión a Entidades.


4. **Presentation:** Interfaz de usuario (MVVM).
* `views/`: Pantallas principales de la app.
* `viewmodels/`: Gestores de estado que se comunican con los Use Cases.
* `widgets/`: Componentes UI exclusivos de la feature.
* `states/`: Clases que representan el estado de la UI (Cargando, Error, Éxito).



## Flujo de Dependencias (Regla de Oro)

**UI (View) ➔ ViewModel ➔ Use Case (Application) ➔ Repository Interface (Domain) ➔ Repository Impl (Infrastructure) ➔ Data Source.**

> *Las capas externas dependen de las internas. La capa Domain no conoce a ninguna otra capa.*

## 🚀 Guía: Ejemplo de creación de una nueva Feature

Si deseas agregar una funcionalidad como `notifications`:

1. Crea la carpeta en `lib/features/notifications`.
2. Define primero tu Entidad en `domain/entities/notification.dart`.
3. Define el contrato en `domain/repositories/notification_repository.dart`.
4. Crea el caso de uso en `application/use_cases/get_notifications_use_case.dart`.
5. Implementa la lógica de red en `infrastructure/datasources/notification_api.dart`.
6. Implementa el repositorio en `infrastructure/repositories/notification_repository_impl.dart`.
7. Crea el ViewModel en `presentation/viewmodels/notification_viewmodel.dart` inyectando el caso de uso.
8. Diseña la Vista en `presentation/views/notification_view.dart` para consumir el ViewModel.

## 🛠 Convenciones de Desarrollo

* **SRP (Responsabilidad Única):** Ninguna clase debe hacer más de una cosa.
* **Inyección de Dependencias:** Todo debe ser inyectado (preferiblemente usando `get_it` o similar), prohibido instanciar clases pesadas directamente.
* **Cero Lógica en UI:** Las validaciones y cálculos van en `Application` o `Domain`.

```

```