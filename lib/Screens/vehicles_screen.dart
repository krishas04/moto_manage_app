import 'package:flutter/material.dart';
import 'package:moto_manage/Services/api_service.dart';

import '../Models/vehicles_model.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final ApiService apiService= ApiService();
  late Future<List<VehicleModel>> futureVehicles;

  void initState(){
    super.initState();
    futureVehicles=apiService.getVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicles owned'),
      ),
      body: FutureBuilder(
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
                itemCount: vehicles.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  return ListTile(
                    leading: Icon(Icons.bike_scooter),
                    title: Text(vehicle.vehicleType),
                    subtitle: Text('${vehicle.fuelType} | ${vehicle.make}'),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=>VehiclesScreen()));
                    },
                  );
                },
              );
            }

            // If nothing matches
            return const Center(child: Text("Something went wrong"));
          }
      ),
    );
  }
}
