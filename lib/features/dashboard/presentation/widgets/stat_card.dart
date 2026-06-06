import 'package:flutter/material.dart';
import 'package:moto_manage/core/constants/app_text_styles.dart';

import '../../../../core/constants/app_colors.dart';
class StatCard extends StatefulWidget {
  final int count;
  final String label;
  final IconData icon;
  const StatCard({super.key,required this.count,required this.label,required this.icon});

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      decoration: BoxDecoration(
          color: AppColors.tWhite,
          borderRadius: BorderRadius.circular(30)
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Icon(widget.icon,size: 25,),
          Text(
            '${widget.count}',
            style: AppTextStyles.bigNum
          ),
          Text(widget.label)
        ],
      ),
    );
  }
}
