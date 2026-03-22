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

### Imperative vs. Declarative:
Imperative navigation (Navigator 1.0) manually pushes and pops screens like a stack, whereas declarative navigation (GoRouter) defines exactly what screen to show based on a specific URL or state.

### GoRouter: 
It centralizes your app's navigation into a single configuration file, making it easy to handle complex routing and pass dynamic data through path parameters like /owner/:id.

---
### Serialization & Models
- Learned to convert `JSON` to `Dart objects` using `Model.fromJson` and back with `toJson`.
- Makes code type-safe and reduces errors when mapping API responses.

### POST Requests & Status Codes
- Learned `http.post` to send new owner data to the backend.
- Checked response status codes to confirm success (201) or handle failure (400/500).
- Used SnackBar to give real-time feedback to users.

### Forms & Dropdowns
- `Form` with `GlobalKey<FormState>` allows validation of multiple fields.
- `TextFormField` for text input with validator.
- `DropdownButtonFormField` for selecting gender, integrated with form state.

*Next Goal: Fully implement Clean Architecture with layers: Presentation, Domain, Data.!*