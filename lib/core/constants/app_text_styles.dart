import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle heading=TextStyle(
      fontWeight: FontWeight.bold,
      color: AppColors.primary
  );
  static const TextStyle bigNum= TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w600,
      color: AppColors.dark
  );

  static const TextStyle body= TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w200,
      color: AppColors.secondary
  );

  static const TextStyle bodyBold= TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: AppColors.secondary
  );
  static const TextStyle normal= TextStyle(
      fontSize: 15,
  );
}