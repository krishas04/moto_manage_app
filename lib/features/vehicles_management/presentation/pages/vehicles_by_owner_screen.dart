import 'package:flutter/material.dart';
import 'package:moto_manage/core/reusable_widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../authentication/presentation/statemanagement/auth_notifier.dart';
import '../../domain/entities/vehicle.dart';
import '../state_management/vehicles_notifier.dart';

class VehiclesByOwnerScreen extends StatefulWidget {
  final int ownerId;
  const VehiclesByOwnerScreen({super.key, required this.ownerId});

  @override
  State<VehiclesByOwnerScreen> createState() => _VehiclesByOwnerScreenState();
}

class _VehiclesByOwnerScreenState extends State<VehiclesByOwnerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVehiclesByOwner();
    });
  }

  void _loadVehiclesByOwner() {
    final token = context.read<AuthNotifier>().accessToken;
    final notifier = context.read<VehicleNotifier>();
    if (token != null) {
      notifier.loadVehiclesByOwner(widget.ownerId, token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<VehicleNotifier>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Modern light background
      appBar: const CustomAppBar(title: "Owner's vehicles"),
      body: RefreshIndicator(
        onRefresh: () async => _loadVehiclesByOwner(),
        child: _buildBody(notifier),
      ),
    );
  }

  Widget _buildBody(VehicleNotifier notifier) {
    if (notifier.isLoading && notifier.myVehicles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (notifier.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text("Error: ${notifier.errorMessage}", textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadVehiclesByOwner, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (notifier.myVehicles.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car_filled_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text("No vehicles registered for this owner.", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifier.myVehicles.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final vehicle = notifier.myVehicles[index];
        return _buildVehicleTile(vehicle);
      },
    );
  }

  Widget _buildVehicleTile(VehicleEntity vehicle) {
    // Dynamic icon selection
    IconData getIcon(String type) {
      if (type == 'four_wheeler') return Icons.directions_car_filled_rounded;
      if (type == 'heavy') return Icons.local_shipping_rounded;
      return Icons.two_wheeler_rounded;
    }

    return Container(
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
          // Icon Bubble (Matches inspiration)
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
                getIcon(vehicle.vehicleType),
                color: AppColors.primary,
                size: 26
            ),
          ),
          const SizedBox(width: 16),
          // Info Section
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
                  '${vehicle.year}  •  ${vehicle.fuelType.toUpperCase()}  •  ${vehicle.vehicleType.replaceAll('_', ' ')}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
          // Simple Action Icon
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}