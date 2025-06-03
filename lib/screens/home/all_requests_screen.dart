import 'package:bds/models/requests_model.dart';
import 'package:bds/routes/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import 'package:get/get.dart';
import '../../widgets/hero_section.dart';
import '../../widgets/custom_button.dart';
import 'package:bds/controllers/request_controller.dart';

class AllRequestsScreen extends StatelessWidget {
  const AllRequestsScreen({super.key});

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
      backgroundColor: Colors.white,
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

              final requests = requestController.requestList; // List<RequestModel>

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
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.lightGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${request.bloodType ?? ''} needed at ${request.hospital?.name ?? ''}',
              style: AppTextStyles.bodyBold.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              request.hospital?.location?.address ?? '',
              style: AppTextStyles.body.copyWith(color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              timeAgo(request.createdAt),
              style: AppTextStyles.body.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${request.status ?? ''}',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'View Details',
              onPressed: () {
                Get.toNamed(RouteHelper.getRespond(index));
              },
            ),
          ],
        ),
      ),
    );
  }
}
