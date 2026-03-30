import 'package:flutter/material.dart';
import 'package:moto_manage/core/constants/app_colors.dart';

class WideElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backGroundColor;
  final Color textColor;

  const WideElevatedButton({super.key,required this.text,required this.onPressed,this.backGroundColor=AppColors.b, this.textColor=AppColors.tGrey});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backGroundColor,
            foregroundColor: textColor,
          ),
          child: Text(text),
      ),
    );
  }
}
