import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_manage/Screens/vehicles_screen.dart';

import '../Models/owner_model.dart';
import '../Services/api_service.dart';
class OwnerScreen extends StatefulWidget {
  const OwnerScreen({super.key});

  @override
  State<OwnerScreen> createState() => _OwnerScreenState();
}

class _OwnerScreenState extends State<OwnerScreen> {
  final ApiService apiService = ApiService();
  late Future<List<OwnerModel>> futureOwners;

  void initState() {
    super.initState();
    futureOwners = apiService.getOwners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Owners'),
        centerTitle: true,
      ),
      body: FutureBuilder<
          List<OwnerModel>>(
        future: futureOwners,
        builder: (context, snapshot) {
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
              itemCount: owners.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final owner = owners[index];
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(owner.fullName),
                  subtitle: Text(owner.mobileNumber),
                  onTap: (){
                    context.push('/vehicles/${owner.id}');
                  },
                );
              },
            );
          }

          // If nothing matches
          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }
}