import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
class VehicleListTile extends StatelessWidget {
  final dynamic vehicle; // Uses your VehicleEntity
  final VoidCallback onTap;

  const VehicleListTile({required this.vehicle, required this.onTap});

  IconData _getIcon(String type) {
    if (type == 'four_wheeler') return Icons.directions_car_filled_rounded;
    if (type == 'heavy') return Icons.local_shipping_rounded;
    return Icons.two_wheeler_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            // Vehicle Icon Bubble
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_getIcon(vehicle.vehicleType), color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vehicle.make} ${vehicle.model}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${vehicle.year}  •  ${vehicle.fuelType.toUpperCase()}  •  ${vehicle.ownerUsername}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}