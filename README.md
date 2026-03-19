# Moto Manage 🏍️

Moto Manage is a Flutter application designed to help manage and display vehicle owners and their respective vehicles. The app communicates with a backend API to fetch real-time data about users and their motorbikes/cars.

## 🚀 Recent Updates & Progress

I have refactored the project to follow a **Clean Architecture** pattern, separating the UI from the logic and data models.

### 📂 Project Structure Improvements
To make the code scalable and readable, I organized the `lib/` directory into the following folders:
- **`Models/`**: Contains Dart classes that represent the data structure (e.g., `OwnerModel`, `VehicleModel`). Handles JSON-to-Object conversion.
- **`Services/`**: Contains the API logic. This is where the networking code lives, keeping it separate from the UI.
- **`Screens/`**: Contains the different pages of the app (e.g., `OwnerScreen`, `VehicleScreen`).

### 🛠️ Dependencies Added
- **`http`**: Added to `pubspec.yaml` to enable the app to make GET requests to the backend server.

### 🌐 Backend Integration
- **Local API Hosting**: The app is successfully connected to a Django(DRF) backend hosted on a local network.
- **Connection**: Instead of `localhost`, I am using the developer's specific IP address (`http://192.168.xxx.xxx:8000`) to allow a physical mobile device or emulator to communicate with the server.

## 📱 Features Implemented
- **Owner List**: A `ListView.separated` screen displaying all registered owners.
- **Dynamic Fetching**: Uses `FutureBuilder` to handle loading, error, and data states.
- **Vehicle Details**: (In Progress) Filtering vehicles based on the selected owner.

---