import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_manage/core/reusable_widgets/custom_appbar.dart';
import 'package:moto_manage/features/vehicles_management/domain/entities/vehicle.dart';
import 'package:moto_manage/features/vehicles_management/presentation/state_management/vehicles_notifier.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../authentication/presentation/statemanagement/auth_notifier.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVehicles();
    });
  }

  void _loadVehicles() {
    final token = context.read<AuthNotifier>().accessToken;
    if (token != null) {
      context.read<VehicleNotifier>().loadVehicles(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<VehicleNotifier>();
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Light background for contrast
      appBar: AppBar(
        title: const Text('List of Vehicles', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadVehicles,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadVehicles(),
        child: _buildBody(notifier),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/vehicles/create'),
        label: const Text('Add Vehicle'),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildBody(VehicleNotifier notifier) {
    if (notifier.isLoading && notifier.vehicles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (notifier.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text("Error: ${notifier.errorMessage}", textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _loadVehicles, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (notifier.vehicles.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car_filled_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text("No vehicles found in the fleet.", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // Extra bottom padding for FAB
      itemCount: notifier.vehicles.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final vehicle = notifier.vehicles[index];
        return _buildVehicleTile(vehicle);
      },
    );
  }

  Widget _buildVehicleTile(VehicleEntity vehicle) {
    // Logic to select icon based on vehicle type
    IconData getIcon() {
      if (vehicle.vehicleType == 'four_wheeler') return Icons.directions_car_filled_rounded;
      if (vehicle.vehicleType == 'heavy') return Icons.local_shipping_rounded;
      return Icons.two_wheeler_rounded;
    }

    return GestureDetector(
      onTap: () => context.push('/vehicles/${vehicle.ownerId}'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            // Icon Bubble
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(getIcon(), color: AppColors.primary, size: 26),
            ),
            const SizedBox(width: 16),
            // Info Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vehicle.make} ${vehicle.model}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${vehicle.year} • ${vehicle.fuelType.toUpperCase()} • ${vehicle.ownerUsername}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),
            // Action Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}