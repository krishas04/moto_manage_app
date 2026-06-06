class ApiConstants{
  // static const String baseUrl='http://10.0.2.2:8000/api';
  static const String baseUrl='http://192.168.1.66:8000/api';


  // Auth
  static const String register = '/register/';
  static const String login = '/login/';
  static const String tokenRefresh = '/token/refresh/';

  // Admin - Users
  static const String users = '/users/';
  static String userById(int id) => '/users/$id/';
  static String vehiclesByUser(int userId) => '/users/$userId/vehicles/';

  // Admin - Vehicles
  static const String vehicles = '/vehicles/';
  static String vehicleById(int id) => '/vehicles/$id/';
  static String vehicleInsurance(int vehicleId) => '/vehicles/$vehicleId/insurance/';

  // Admin - Insurances
  static const String insurances = '/insurances/';
  static String insuranceById(int id) => '/insurances/$id/';

  // Mobile (regular user)
  static const String mobileProfile = '/mobile/profile/';
  static const String mobileVehicles = '/mobile/vehicles/';
  static String mobileVehicleById(int id) => '/mobile/vehicles/$id/';
  static String mobileVehicleInsurance(int id) => '/mobile/vehicles/$id/insurance/';

}

