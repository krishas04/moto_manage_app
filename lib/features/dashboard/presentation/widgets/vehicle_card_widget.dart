import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moto_manage/features/vehicles_management/domain/entities/vehicle.dart';

import '../../../../core/constants/app_colors.dart';
class VehicleCardWidget extends StatelessWidget {
  final VehicleEntity vehicle;
  const VehicleCardWidget({super.key,required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.dark,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              width:150,
              height: 150,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              margin: EdgeInsets.all(10),
              child: SvgPicture.asset(
                  vehicle.vehicleType=='four_wheeler'?'assets/images/car.svg':'assets/images/motorcycle.svg',
                  fit: BoxFit.contain,
              ),
            ),
            Text(
              'Type: ${vehicle.vehicleType.replaceAll('_', ' ')}',
              style: TextStyle(
                  color: AppColors.tWhite
              ),
            ),
            Text(
              'Fuel: ${vehicle.fuelType} | Owner: ${vehicle.ownerUsername} ',
              style: TextStyle(
                  color: AppColors.tWhite
              ),
            ),
          ],
        ),
      ),
    );
  }
}
