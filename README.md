# Moto Manage 🏍️
Moto Manage is a Flutter application designed to help manage and display vehicle owners and their respective vehicles. The app communicates with a backend API to fetch real-time data about users and their motorbikes/cars.

🚀 Recent Updates & Progress
Added Create Owner feature with forms, validation, and API integration.

🛠️ Tech Stack & Key Dependencies
`Framework`: Flutter
`Navigation`: go_router (Declarative routing with path parameters)
`Backend`: Django Rest Framework (DRF) hosted on local IP.
`Networking`: http for RESTful API communication.

🏗️ Architecture & Routing
I have implemented a Feature-First Clean Architecture:
`Models/`: Dart classes representing data structures (OwnerModel, VehicleModel) with fromJson/toJson for serialization.
`Services/`: API logic (ApiService) separated from UI. Handles HTTP GET and POST requests with status code checking.
`Screens/`: Contains the different pages of the app (e.g., OwnerScreen, VehicleScreen,CreateOwnerScreen).
`Router/`:Centralized route configuration using GoRouter.

🛣️ Advanced Navigation Features
Named Routes: Replaced string-based navigation with named routes to prevent hardcoding errors.
Path Parameters: Implemented dynamic routing for vehicle details (e.g., /owner/:ownerId). This allows the app to deep-link directly to a specific user's garage.
FloatingActionButton Navigation: Easily add new owners from the dashboard.

📱 Features Implemented
✅ Form Handling – Create Owner form with validation for username, email, phone, name, age, and gender
✅ DropdownButtonFormField – Select gender dynamically
✅ POST Requests – Submit new owners to backend using http.post
✅ Status Code Handling – Success/failure SnackBars based on API response