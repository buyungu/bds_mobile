import 'package:bds/routes/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

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
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0), // Right margin
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade400,
                  child: IconButton(
                    icon: Icon(Icons.notifications, color: AppColors.primaryRed), 
                    onPressed: () { 
                      Get.toNamed(RouteHelper.getNotifications());
                    },
                  ),  
                ),  
              ),
            ],
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
