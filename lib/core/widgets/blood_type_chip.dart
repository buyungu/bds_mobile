import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class BloodTypeChip extends StatelessWidget {
  final String type;
  final bool isSelected;
  final VoidCallback onTap;

  const BloodTypeChip({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRed : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
