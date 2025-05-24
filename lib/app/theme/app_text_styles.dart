import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 255, 255, 255),
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Color.fromARGB(255, 255, 255, 255),
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.textDark,
  );

  static const TextStyle whiteBody = TextStyle(
    fontSize: 16,
    color: AppColors.white,
  );

  // 🔥 ADD THESE ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
  static const TextStyle heroTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 255, 255, 255),
  );

  static const TextStyle heroSubtitle = TextStyle(
    fontSize: 16,
    color: AppColors.lightGrey,
  );

  static const TextStyle bodyBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
  static const TextStyle action = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryRed,
  );
}
