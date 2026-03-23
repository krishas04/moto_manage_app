## Moto Manage 🏍️
Moto Manage is a Flutter application designed to help manage vehicle owners and their respective vehicles. The app communicates with a Django REST Framework backend to fetch, create, and display real-time data about owners and their motorbikes/cars — built with a strict Clean Architecture approach.

### 🚀 Recent Updates & Progress

✅ Implemented Clean Architecture with full layer separation (Presentation → Domain → Data)
✅ Integrated get_it for dependency injection — all wiring centralised in service_locator.dart
✅ Removed all manual dependency chains from screens

### 🛠️ Tech Stack & Key Dependencies
`Purpose`               `Package`
Framework               Flutter
Navigation              go_router — declarative routing with path parameters
Networking              http — RESTful API communication
Dependency Injection    get_it — service locator pattern
Backend                 Django REST Framework (DRF)

### 🏗️ Architecture
This project follows Clean Architecture with a Feature-First folder structure. Each feature is fully self-contained with its own data, domain, and presentation layers.
lib/
├── core/
│   ├── constants/
│   │   └── api_constants.dart        # Base URL and endpoint constants
│   └── di/
│       └── service_locator.dart      # get_it — single wiring file for the whole app
│
└── features/
├── owner_management/
│   ├── data/
│   │   ├── data_sources/         # Raw HTTP calls (OwnerRemoteDataSource)
│   │   ├── models/               # JSON ↔ Dart conversion (OwnerModel)
│   │   └── repositories/         # Implements domain interface (OwnerRepositoryImpl)
│   ├── domain/
│   │   ├── entities/             # Pure Dart objects — no imports (OwnerEntity)
│   │   ├── repository_interfaces/ # Abstract contracts (OwnerRepository)
│   │   └── usecases/             # Single-responsibility actions (GetOwnersUseCase)
│   └── presentation/
│       ├── pages/                # Screens (OwnerScreen, CreateOwnerScreen)
│       ├── state_management/     # ChangeNotifiers / Cubits
│       └── widgets/              # Reusable UI components
│
└── vehicles_management/
├── data/
│   ├── data_sources/         # VehicleRemoteDataSource
│   ├── models/               # VehicleModel
│   └── repositories/         # VehicleRepositoryImpl
├── domain/
│   ├── entities/             # VehicleEntity
│   ├── repository_interfaces/ # VehicleRepository
│   └── usecases/             # GetVehiclesUseCase, GetVehiclesByOwnerUseCase
└── presentation/
├── pages/                # VehiclesScreen, VehiclesByOwnerScreen
├── state_management/
└── widgets/

### Layer Responsibilities
`Presentation` — UI only. Shows data, captures input, calls use cases. No HTTP, no JSON, no repositories.
`Domain` — Pure Dart. Zero external imports. Entities, abstract repository interfaces, and use cases. This is the core of the app — it never changes when the data source changes.
`Data` — Implements the domain interfaces. Handles HTTP calls, JSON parsing, and model conversion. Only this layer knows about http or any external service.
**Dependency Rule**
Dependencies only point inward. Presentation knows about Domain. Data knows about Domain. Nothing knows about Presentation. Domain knows about nobody.
Presentation  →  Domain  ←  Data

### 💉 Dependency Injection with get_it
All dependencies are registered once in lib/core/di/service_locator.dart and called from main.dart before runApp. Screens access use cases via getIt<UseCaseType>() — they never instantiate repositories or data sources directly.
    ```
    void main() {
    setupLocator(); // register everything
    runApp(const MyApp());
    }
    ```
    ```
    // any screen
    final getOwnersUseCase = getIt<GetOwnersUseCase>();
    ```

### 🛣️ Navigation
Centralised declarative routing using GoRouter in lib/config/router/router.dart.
RouteScreen/OwnerScreen/usersCreateOwnerScreen/vehiclesVehiclesScreen/vehicles/:ownerIdVehiclesByOwnerScreen

### 📱 Features Implemented
FeatureStatusList all owners from API✅Create new owner with form validation✅List all vehicles✅List vehicles filtered by owner✅Dropdown gender selection✅SnackBar feedback on API success/failure✅Loading indicator during API calls✅Clean Architecture — full layer separation✅Dependency injection with get_it✅Centralised routing with GoRouter✅

### 🔧 Running the Project

Ensure your Django backend is running locally
Update lib/core/constants/api_constants.dart with your machine's local IP:
    ```
     static const String baseUrl = 'http://192.168.x.x:8000/api';
    ```
On Android, confirm AndroidManifest.xml has:
    ```
     android:usesCleartextTraffic="true"
    ```
Run the app:
    ```    
    bash   flutter pub get
    flutter run
    ```