import 'package:go_router/go_router.dart';
import 'package:moto_manage/Screens/owner_screen.dart';
import 'package:moto_manage/Screens/vehicles_by_owner_screen.dart';
import 'package:moto_manage/Screens/vehicles_screen.dart';

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
          path: '/vehicles/:ownerId',
          builder: (context,state){
            final id=state.pathParameters['ownerId']!;
            return VehiclesByOwnerScreen(ownerId: id);
          }
      ),

]);