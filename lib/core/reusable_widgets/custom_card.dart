import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const CustomCard({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color:AppColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary)),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }
}