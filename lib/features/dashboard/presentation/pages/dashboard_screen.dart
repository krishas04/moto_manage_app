import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_manage/features/dashboard/presentation/widgets/owner_card_widget.dart';
import 'package:moto_manage/features/dashboard/presentation/widgets/stat_card.dart';
import 'package:moto_manage/features/dashboard/presentation/widgets/vehicle_card_widget.dart';
import 'package:moto_manage/features/owner_management/domain/entities/owner.dart';

import '../../../../core/di/service_locator.dart';
import '../../../owner_management/domain/usecases/get_owners_usecase.dart';
import '../../../vehicles_management/domain/entities/vehicle.dart';
import '../../../vehicles_management/domain/usecases/get_vehicles_usecase.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Fetching ALL owners
  late final GetOwnersUseCase getOwnersUseCase = getIt<GetOwnersUseCase>();
  late Future<List<VehicleEntity>> futureVehicles;

// Fetching ALL vehicles (The general list)
  late final GetVehiclesUseCase getVehiclesUseCase = getIt<GetVehiclesUseCase>();
  late Future<List<OwnerEntity>> futureOwners;

  @override
  void initState(){
    super.initState();
    futureVehicles=getVehiclesUseCase.call() ;
    futureOwners=getOwnersUseCase.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      child: FutureBuilder(
                        future: futureVehicles,
                        builder: (context, snapshot) {
                          int count= snapshot.hasData?snapshot.data!.length : 0;
                          return StatCard(count: count, label: 'Total Vehicles', icon: Icons.directions_car);
                        },
                      ),
                      onTap: ()=>context.push('/vehicles'),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: GestureDetector(
                      child: FutureBuilder(
                        future: futureOwners,
                        builder: (context, snapshot) {
                          int count= snapshot.hasData?snapshot.data!.length : 0;
                          return StatCard(count: count, label: 'Total Owners', icon: Icons.person);
                        },
                      ),
                      onTap: ()=>context.push('/owners'),
                    ),
                  ),
                ],
              ),
          
              // owner section
              Row(
                children: [
                  Text('Owners'),
                  const SizedBox(width: 200,),
                  FilledButton(
                      onPressed: (){
                        context.push('/users');
                      },
                      child: Text('Create new user'))
                ],
              ),
              SizedBox(
                height: 200,
                child: FutureBuilder(
                    future: futureOwners,
                    builder: (context,snapshot){
                      // Waiting for data
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
          
                      // Error occurred
                      else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
          
                      // Data received successfully
                      else if (snapshot.hasData) {
                        final owners = snapshot.data!;
          
                        // Handle empty list case
                        if (owners.isEmpty) {
                          return const Center(child: Text("No owners found."));
                        }
          
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: owners.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final owner = owners[index];
                            return GestureDetector(
                                child: OwnerCardWidget(owner: owner),
                              onTap: (){
                                context.push('/vehicles/${owner.id}');
                              },
                            );
                          },
                        );
                      }
          
                      // If nothing matches
                      return const Center(child: Text("Something went wrong"));
                    }
                ),
              ),
          
              //vehicles section
              Row(
                children: [
                  Text('Vehicles'),
                  SizedBox(width: 280,),
                  Text('View all')
                ],
              ),
              SizedBox(
                height: 350,
                child: FutureBuilder(
                    future: futureVehicles,
                    builder: (context,snapshot){
                      // Waiting for data
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
          
                      // Error occurred
                      else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
          
                      // Data received successfully
                      else if (snapshot.hasData) {
                        final vehicles = snapshot.data!;
          
                        // Handle empty list case
                        if (vehicles.isEmpty) {
                          return const Center(child: Text("No vehicles owned."));
                        }
          
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: vehicles.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final vehicle = vehicles[index];
                            return VehicleCardWidget(vehicle: vehicle);
                          },
                        );
                      }
          
                      // If nothing matches
                      return const Center(child: Text("Something went wrong"));
                    }
                ),
              ),
          
          
            ],
          ),
        ),
      ),
    );
  }
}
