import 'dart:ui';
import 'package:timeago/timeago.dart' as timeago;

import 'package:bds/controllers/my_request_controller.dart';
import 'package:bds/routes/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import 'package:get/get.dart';
import '../../widgets/hero_section.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  late MyRequestController myRequestController;

  @override
  void initState() {
    super.initState();
    myRequestController = Get.find<MyRequestController>();
    myRequestController.getMyRequestsList();
  }

  final List<String> bloodTypes = [
    'All', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];
  String selectedBloodType = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: GetBuilder<MyRequestController>(
        builder: (controller) {
          if (!controller.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final requests = controller.myRequestList;

          final filteredRequests = selectedBloodType == 'All'
              ? requests
              : requests.where((req) => req.bloodType == selectedBloodType).toList();

          return RefreshIndicator(
            onRefresh: () async {
              // This function will be called when the user pulls down to refresh.
              // It triggers the fetching of the latest requests.
              await controller.getMyRequestsList();
            },
            child: CustomScrollView(
              physics:
                  const AlwaysScrollableScrollPhysics(), // Ensure scroll physics are always active for RefreshIndicator
              slivers: [
                const HeroSection(
                  title: 'My Requests',
                  subtitle: 'Track and manage your donation requests',
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      itemCount: bloodTypes.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final type = bloodTypes[index];
                        final isSelected = selectedBloodType == type;
                        return ChoiceChip(
                          label: Text(
                            type,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.primaryRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.primaryRed,
                          backgroundColor: Colors.white,
                          onSelected: (_) {
                            setState(() {
                              selectedBloodType = type;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildRequestCard(context, filteredRequests[index]),
                      childCount: filteredRequests.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, dynamic request) {
    final hospital = request.hospital?.name ?? 'Unknown Hospital';
    final bloodType = request.bloodType ?? 'N/A';
    final createdAt = request.createdAt;
    String date = '';
    if (createdAt != null && createdAt is String && createdAt.isNotEmpty) {
      try {
        final parsedDate = DateTime.parse(createdAt);
        date = timeago.format(parsedDate);
      } catch (e) {
        date = createdAt;
      }
    }
    final status = request.status ?? 'Pending';

    Color statusColor;
    IconData statusIcon;
    switch (status.toLowerCase()) {
      case 'matched':
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
                        hospital,
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
                            status,
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
                      bloodType,
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
                      'Requested on $date',
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
                      Get.toNamed(RouteHelper.getDonationProgress(request.id));
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