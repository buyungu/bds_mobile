import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class HeroSection extends StatelessWidget {
  final String title;
  final String subtitle;

  const HeroSection({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
            expandedHeight: 150,
            floating: false,
            pinned: true,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  gradient: LinearGradient(
                    colors: [AppColors.primaryRed, AppColors.secondaryRed],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.heroTitle,
                        ),
                        SizedBox(height: 8,),
                        Text(
                          subtitle,
                          style: AppTextStyles.heroSubtitle,
                        ),
                      ],
                    ),)),
              ),
            ),
          );
  }
}
