# Moto Manage 🏍️
Moto Manage is a Flutter application designed to help manage and display vehicle owners and their respective vehicles. The app communicates with a backend API to fetch real-time data about users and their motorbikes/cars.

🚀 Recent Updates & Progress
The app has evolved from a simple list to a robust, routed application using Clean Architecture and Declarative Navigation.

🛠️ Tech Stack & Key Dependencies
`Framework`: Flutter
`Navigation`: go_router (Declarative routing with path parameters)
`Backend`: Django Rest Framework (DRF) hosted on local IP.
`Networking`: http for RESTful API communication.

🏗️ Architecture & Routing
I have implemented a Feature-First Clean Architecture:
`Models/`: Contains Dart classes that represent the data structure (e.g., OwnerModel, VehicleModel). Handles JSON-to-Object conversion.
`Services/`: Contains the API logic. This is where the networking code lives, keeping it separate from the UI.
`Screens/`: Contains the different pages of the app (e.g., OwnerScreen, VehicleScreen).
`Router/`:Centralized route configuration using GoRouter.

🛣️ Advanced Navigation Features
Named Routes: Replaced string-based navigation with named routes to prevent hardcoding errors.
Path Parameters: Implemented dynamic routing for vehicle details (e.g., /owner/:ownerId). This allows the app to deep-link directly to a specific user's garage.

📱 Features Implemented
✅ Dynamic Owner Dashboard: Fetching and displaying owners via a Django API.
✅ Deep Linking with GoRouter: Click an owner to view their specific "Garage" using ownerId.
✅ State-Aware UI: FutureBuilder implementation to handle Loading, Empty, and Error states.
✅ Local Network Sync: Seamless communication between physical hardware and a local development server.