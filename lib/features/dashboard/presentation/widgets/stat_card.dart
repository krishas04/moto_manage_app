import 'package:flutter/material.dart';

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
      width: 180,
      height: 180,
      decoration: BoxDecoration(
          color: AppColors.tWhite,
          borderRadius: BorderRadius.circular(30)
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Icon(widget.icon,size: 30,),
          Text(
            '${widget.count}',
            style: TextStyle(
                fontSize: 70
            ),
          ),
          Text(widget.label)
        ],
      ),
    );
  }
}
