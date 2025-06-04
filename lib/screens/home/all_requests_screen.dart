import 'dart:ui'; // For ImageFilter.blur

import 'package:bds/models/requests_model.dart';
import 'package:bds/routes/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import 'package:get/get.dart';
import '../../widgets/hero_section.dart';
import '../../widgets/custom_button.dart';
import 'package:bds/controllers/request_controller.dart';

class AllRequestsScreen extends StatefulWidget {
  const AllRequestsScreen({super.key});

  @override
  State<AllRequestsScreen> createState() => _AllRequestsScreenState();
}

class _AllRequestsScreenState extends State<AllRequestsScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<RequestController>().getRequestsList();
  }

  String timeAgo(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    final date = DateTime.tryParse(dateString);
    if (date == null) return '';
    final diff = DateTime.now().difference(date);

    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    if (diff.inDays < 7) return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: CustomScrollView(
        slivers: [
          const HeroSection(
            title: 'All Blood Requests',
            subtitle: 'Find requests near you',
          ),
          GetBuilder<RequestController>(
            builder: (requestController) {
              if (!requestController.isLoaded) {
                return SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final requests = requestController.requestList;

              if (requests.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No requests found',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildRequestCard(context, requests[index], index),
                    childCount: requests.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, RequestModel request, int index) {
    Color statusColor;
    IconData statusIcon;
    switch (request.status?.toLowerCase()) {
      case 'approved':
        statusColor = Colors.orange;
        statusIcon = Icons.check_circle_outline;
        break;
      case 'fulfilled':
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
                        '${request.bloodType ?? ''} needed at ${request.hospital?.name ?? ''}',
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
                            request.status ?? '',
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
                    Icon(Icons.location_on, color: Colors.blueGrey, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        request.hospital?.location?.address ?? '',
                        style: AppTextStyles.body.copyWith(color: Colors.black87),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                      timeAgo(request.createdAt),
                      style: AppTextStyles.body.copyWith(color: Colors.blueGrey.shade700),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.info_outline, color: Colors.white),
                    label: Text(
                      'View Details',
                      style: AppTextStyles.whiteBody.copyWith(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      final requestController = Get.find<RequestController>();
                      if (requestController.isLoaded && requestController.requestList.isNotEmpty) {
                        // Now you can safely navigate
                        Get.toNamed(RouteHelper.getRespond(request.id!));
                      }
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
