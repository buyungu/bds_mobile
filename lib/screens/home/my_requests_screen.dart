import 'dart:ui';

import 'package:bds/routes/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import 'package:get/get.dart';
import '../../widgets/hero_section.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> requests = [
      {
        'hospital': 'City Hospital',
        'bloodType': 'O+',
        'date': 'May 15, 2025',
        'status': 'Pending',
      },
      {
        'hospital': 'General Health Center',
        'bloodType': 'A-',
        'date': 'May 5, 2025',
        'status': 'Approved',
      },
      {
        'hospital': 'Red Cross Clinic',
        'bloodType': 'B+',
        'date': 'Apr 28, 2025',
        'status': 'Fulfilled',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: CustomScrollView(
        slivers: [
          HeroSection(
            title: 'My Requests',
            subtitle: 'Track and manage your donation requests',
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildRequestCard(context, requests[index]),
                childCount: requests.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, Map<String, dynamic> request) {
    Color statusColor;
    IconData statusIcon;
    switch (request['status']) {
      case 'Approved':
        statusColor = Colors.orange;
        statusIcon = Icons.check_circle_outline;
        break;
      case 'Fulfilled':
        statusColor = Colors.green;
        statusIcon = Icons.verified;
        break;
      default:
        statusColor = Colors.red;
        statusIcon = Icons.hourglass_bottom;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.85),
            Colors.blueGrey.withOpacity(0.07),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primaryRed.withOpacity(0.12),
                      child: Icon(
                        Icons.local_hospital,
                        color: AppColors.primaryRed,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        request['hospital'],
                        style: AppTextStyles.bodyBold.copyWith(fontSize: 18),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.13),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Icon(statusIcon, color: statusColor, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            request['status'],
                            style: AppTextStyles.bodyBold.copyWith(
                              color: statusColor,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Icon(Icons.bloodtype, color: AppColors.primaryRed, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Blood Type: ',
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      request['bloodType'],
                      style: AppTextStyles.bodyBold.copyWith(
                        color: AppColors.primaryRed,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blueGrey, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Requested on ${request['date']}',
                      style: AppTextStyles.body.copyWith(color: Colors.blueGrey.shade700),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.timeline, color: Colors.white),
                    label: Text(
                      'View Progress',
                      style: AppTextStyles.whiteBody.copyWith(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Get.toNamed(RouteHelper.getDonationProgress());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
