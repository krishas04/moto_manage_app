import 'package:go_router/go_router.dart';
import 'package:moto_manage/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:moto_manage/features/owner_management/presentation/pages/update_owner_screen.dart';
import '../../features/owner_management/presentation/pages/create_owner_screen.dart';
import '../../features/owner_management/presentation/pages/owner_screen.dart';
import '../../features/vehicles_management/presentation/pages/vehicles_by_owner_screen.dart';
import '../../features/vehicles_management/presentation/pages/vehicles_screen.dart';

final router= GoRouter(
    routes: [
      GoRoute(
          path: '/',
          builder: (context,state)=> DashboardScreen()
      ),
      GoRoute(
          path: '/owners',
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
          path: '/user/edit/:ownerId',
          builder: (context,state) {
            final id= state.pathParameters['ownerId']!;
            return UpdateOwnerScreen(ownerId: id);
          }
      ),
      GoRoute(
          path: '/vehicles/:ownerId',
          builder: (context,state){
            final id=state.pathParameters['ownerId']!;
            return VehiclesByOwnerScreen(ownerId: id);
          }
      ),

]);