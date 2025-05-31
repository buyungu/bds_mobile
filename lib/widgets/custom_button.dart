import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final double? height;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = true,

    this.fontSize,
    this.padding, this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5,
          backgroundColor: isPrimary ? AppColors.primaryRed : AppColors.white,
          foregroundColor: isPrimary ? AppColors.white : AppColors.primaryRed,
          side: BorderSide(color: AppColors.primaryRed),
          minimumSize: Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: padding ?? const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: TextStyle(fontSize: fontSize ?? 18, fontWeight: FontWeight.bold),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
