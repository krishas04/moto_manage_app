import 'package:go_router/go_router.dart';
import '../../features/owner_management/presentation/pages/create_owner_screen.dart';
import '../../features/owner_management/presentation/pages/owner_screen.dart';
import '../../features/vehicles_management/presentation/pages/vehicles_by_owner_screen.dart';
import '../../features/vehicles_management/presentation/pages/vehicles_screen.dart';

final router= GoRouter(
    routes: [
      GoRoute(
          path: '/',
          builder: (context,state)=> OwnerScreen()
      ),
      GoRoute(
          path: '/vehicles',
          builder: (context,state)=> VehiclesScreen()
      ),
      GoRoute(
          path: '/users',
          builder: (context,state)=> CreateOwnerScreen()
      ),
      GoRoute(
          path: '/vehicles/:ownerId',
          builder: (context,state){
            final id=state.pathParameters['ownerId']!;
            return VehiclesByOwnerScreen(ownerId: id);
          }
      ),

]);