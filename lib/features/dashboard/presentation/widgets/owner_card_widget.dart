import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moto_manage/features/owner_management/domain/entities/owner.dart';

import '../../../../core/constants/app_colors.dart';
class OwnerCardWidget extends StatelessWidget {
  final OwnerEntity owner;
  const OwnerCardWidget({super.key, required this.owner});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.tGrey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              width:100,
              height: 100,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
              ),
              margin: EdgeInsets.all(10),
              child: ClipOval(
                child: SvgPicture.asset(
                    owner.gender=='male'?'assets/images/man.svg':'assets/images/woman.svg'),
              ),
            ),
            Text('${owner.fullName}',
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
