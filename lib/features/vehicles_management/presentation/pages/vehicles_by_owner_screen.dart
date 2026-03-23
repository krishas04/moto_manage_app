import 'package:flutter/material.dart';
import 'package:moto_manage/core/di/service_locator.dart';
import 'package:moto_manage/features/vehicles_management/domain/usecases/get_vehicle_by_owner_usecase.dart';

import '../../domain/entities/vehicle.dart';

class VehiclesByOwnerScreen extends StatefulWidget {
  final String ownerId;
  const VehiclesByOwnerScreen({super.key, required this.ownerId});

  @override
  State<VehiclesByOwnerScreen> createState() => _VehiclesByOwnerScreenState();
}

class _VehiclesByOwnerScreenState extends State<VehiclesByOwnerScreen> {
  late final GetVehiclesByOwnerUseCase getVehiclesByOwnerUseCase= getIt<GetVehiclesByOwnerUseCase>();
  late Future<List<VehicleEntity>> futureVehicles;

  @override
  void initState(){
    super.initState();
    futureVehicles= getVehiclesByOwnerUseCase.call(widget.ownerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Owner's Vehicles")),
      body: FutureBuilder(
        future: futureVehicles,
        builder: (context, snapshot) {

          // Waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error occurred
          else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.hasData) {
            final vehicles = snapshot.data!;

            // Handle empty list case
            if (vehicles.isEmpty) {
              return const Center(child: Text("No vehicles found."));
            }

            return ListView.separated(
                itemBuilder: (context,index){
                  final vehicle=vehicles[index];
                  return ListTile(
                    leading: Icon(Icons.bike_scooter),
                    title: Text(vehicle.vehicleType),
                    subtitle: Text('${vehicle.fuelType} | ${vehicle.make}'),
                    onTap: (){},
                  );
                },
                separatorBuilder: (context,index)=> const SizedBox(height: 10,),
                itemCount: vehicles.length
            );
          }
          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }
}
