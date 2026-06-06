import 'package:flutter/material.dart';
import 'package:moto_manage/features/owner_management/domain/entities/owner.dart';
import '../../../../core/constants/app_colors.dart';

class OwnerCardWidget extends StatelessWidget {
  final OwnerEntity owner;
  const OwnerCardWidget({super.key, required this.owner});

  @override
  Widget build(BuildContext context) {
    // 1. Determine icon based on gender
    final IconData genderIcon = owner.gender.toLowerCase() == 'male'
        ? Icons.person_rounded
        : Icons.person_3_rounded;

    return Container(
      width: 140, // Fixed width for horizontal ListView
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dark, // Using your dark theme color
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 2. Icon Bubble instead of SVG
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15), // Semi-transparent white
            ),
            child: Icon(
              genderIcon,
              color: Colors.white,
              size: 32,
            ),
          ),

          const SizedBox(height: 12),

          // 3. Name Label
          Text(
            owner.fullName ?? owner.username,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 4),

          // 4. Sub-label (Username or Phone)
          Text(
            owner.mobileNumber,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}