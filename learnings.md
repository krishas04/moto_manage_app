# 📚 My Learning Journey

While building Moto Manage, I have encountered and mastered several new concepts in Flutter and mobile development.

### 1. Networking with Local IP Addresses
I learned that when testing an app on a physical device, `localhost` (127.0.0.1) does not work because the phone is a separate device from the computer.
*   **The Fix**: I learned how to find the computer's local IP address and use it in the API URL (e.g., `192.168.101.4`).
*   **Network Permission**: I discovered that Android requires `android:usesCleartextTraffic="true"` in the `AndroidManifest.xml` to allow `http` (non-secure) connections during development.

### 2. The Power of Models (Serialization)
I learned that raw JSON data from an API is just a Map. To use it effectively in Flutter, I need to create **Model Classes**.
*   Creating a `factory` constructor like `Model.fromJson` allows me to map JSON keys directly to Dart objects, preventing typos and making the code "Type Safe."

### 3. Separation of Concerns (Clean Architecture)
Originally, I had all my code in `main.dart`. I learned that this is bad practice.
*   By moving API logic to a **Service** and UI to **Screens**, the code is much easier to debug. If the data isn't showing, I check the Service. If the text is the wrong color, I check the Screen.

### 4. Handling Asynchronous Data
I learned how to use `async`, `await`, and the `Future` type.
*   **FutureBuilder**: I learned how to use this widget to show a loading spinner (`CircularProgressIndicator`) while waiting for the API and then automatically switch to the list once the data arrives.

### 5. Advanced UI Widgets
*   **ListView.separated**: I learned how to use this to add clean spacing between items without manually adding logic to the loop.
*   **ListTile & Card**: Learned how to use these to create professional-looking rows quickly.

---

### 6. Imperative vs. Declarative:
Imperative navigation (Navigator 1.0) manually pushes and pops screens like a stack, whereas declarative navigation (GoRouter) defines exactly what screen to show based on a specific URL or state.

### 7. GoRouter: 
It centralizes your app's navigation into a single configuration file, making it easy to handle complex routing and pass dynamic data through path parameters like /owner/:id.

---

### 8. Serialization & Models
- Learned to convert `JSON` to `Dart objects` using `Model.fromJson` and back with `toJson`.
- Makes code type-safe and reduces errors when mapping API responses.

### 9. POST Requests & Status Codes
- Learned `http.post` to send new owner data to the backend.
- Checked response status codes to confirm success (201) or handle failure (400/500).
- Used SnackBar to give real-time feedback to users.

### 10. Forms & Dropdowns
- `Form` with `GlobalKey<FormState>` allows validation of multiple fields.
- `TextFormField` for text input with validator.
- `DropdownButtonFormField` for selecting gender, integrated with form state.

### 12. Dependency Injection — get_it Package

**The problem before get_it:** Every screen manually built the entire dependency
chain from scratch:
```dart
final remoteDataSource = OwnerRemoteDataSource();
final repository = OwnerRepositoryImpl(remoteDataSource);
final useCase = GetOwnersUseCase(repository);
```

This caused three problems. First, the same chain was duplicated in every screen.
Second, the screen knew about `OwnerRemoteDataSource` — a Data layer class —
which violates clean architecture. Third, every screen created its own separate
instance, wasting memory.

**What get_it is:** A global service locator — think of it as a phone book for
your app. You register how to build each object once. Any screen looks it up by
type and gets back the already-built instance.

**The three registration types:**

`registerLazySingleton` — created only when first requested, then the same
instance is reused forever. Use this for stateless classes like data sources,
repositories, and use cases.

`registerSingleton` — created immediately when `setupLocator()` runs, before
anyone asks for it. Use when something must exist before anything else starts.

`registerFactory` — creates a brand new instance every single time `getIt()` is
called. Use when each caller needs its own fresh copy.

For this project, `registerLazySingleton` is correct for everything because use
cases and repositories hold no state — they just do work.

**Why `GetIt.instance` is global:** No matter how many files write
`final getIt = GetIt.instance`, they all point to the exact same object. There is
one phone book for the entire app. A screen in `owner_management` and a screen
in `vehicles_management` both call `getIt()` and talk to the same registry.

**Why register order matters:** Register dependencies before the things that need
them. Data sources have no dependencies, so they go first. Repositories need a
data source, so they go second. Use cases need a repository, so they go last.
Registering in the wrong order causes a "not registered" crash.

**Why register as the interface, not the concrete class:**
```dart
// Correct — register as the abstract type
getIt.registerLazySingleton<OwnerRepository>(
  () => OwnerRepositoryImpl(getIt()),
);
```

Use cases are written to depend on `OwnerRepository` (the abstract interface).
If tomorrow the backend switches to a local database, only this one line in
`service_locator.dart` changes. Every use case and every screen stays untouched.

**Why `setupLocator()` must run before `runApp()`:** The moment `runApp` starts,
Flutter begins building widgets. The first screen to build immediately calls
`getIt<UseCase>()`. If `setupLocator()` hasn't run yet, the phone book is empty and
the app crashes with "not registered". The phone book must exist before any
widget asks for anything.

**The outcome:** Screens dropped from three lines of manual wiring to one line:
```dart
// Before
final remoteDataSource = OwnerRemoteDataSource();
final repository = OwnerRepositoryImpl(remoteDataSource);
final useCase = GetOwnersUseCase(repository);

// After
final useCase = getIt<GetOwnersUseCase>();
```

The screen now has zero knowledge of `OwnerRemoteDataSource` or
`OwnerRepositoryImpl`. Clean architecture is fully restored.

**Splitting registrations by feature:** Rather than one flat list of
registrations, `setupLocator()` calls `_registerOwnerFeature()` and
`_registerVehicleFeature()` as separate private functions. This means adding a
new feature is one new line in `setupLocator()` and one new private function —
existing registrations are never touched.

**Shared singletons across use cases:** Both `GetVehiclesUseCase` and
`GetVehiclesByOwnerUseCase` call `getIt<VehicleRepository>()` in their factory
functions. Because `VehicleRepository` is a `lazySingleton`, both use cases
receive the exact same repository instance. One HTTP client, two use cases, zero
duplication.