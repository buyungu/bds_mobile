import 'package:bds/routes/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import '../../widgets/hero_section.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:bds/controllers/notification_controller.dart'; // Import your controller
import 'package:bds/models/notification_model.dart'; // Import your model

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Find the controller instance. Make sure it's put into GetX beforehand (e.g., in main.dart)
    final NotificationController controller = Get.find<NotificationController>();

    return Scaffold(
      // Add a subtle gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F8FF), Color(0xFFFDECEA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () => controller.getNotificationList(),
          color: AppColors.primaryRed,
          child: CustomScrollView(
            slivers: [
              const HeroSection(
                title: 'Notifications',
                subtitle: 'Stay updated with your donation journey',
              ),
              // Use GetBuilder to listen for updates from NotificationController
              GetBuilder<NotificationController>(
                builder: (controller) {
                  if (!controller.isLoaded && controller.notificationList.isEmpty && controller.errorMessage == null) {
                    // Initial loading state or when refreshing
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (controller.errorMessage != null) {
                    // Display error message
                    return SliverFillRemaining(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Error: ${controller.errorMessage}',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryRed)),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => controller.getNotificationList(), // Call the method to retry
                                child: const Text('Try Again'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (controller.notificationList.isEmpty) {
                    // No notifications found after loading
                    return const SliverFillRemaining(
                      child: Center(
                        child: Text('No notifications found.', style: AppTextStyles.body),
                      ),
                    );
                  } else {
                    // Display the list of notifications
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final notification = controller.notificationList[index];
                            return _buildNotificationCard(context, notification, controller);
                          },
                          childCount: controller.notificationList.length,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationItem notification, NotificationController controller) {
    String type = notification.type;
    String buttonText = '';
    VoidCallback? onPressed;

    final bool isRead = notification.status?.toLowerCase() == 'read';

    switch (type) {
      case 'donation':
        buttonText = 'Respond Now';
        onPressed = isRead ? null : () {
          Get.snackbar('Action', 'Responding to emergency!');
          Get.toNamed(RouteHelper.getRespond(notification.bloodRequestId!));
          controller.markAsRead(notification.id);
        };
 
        break;
      case 'event':
        buttonText = 'vew Event';
        onPressed = isRead ? null : () {
          Get.snackbar('Action', 'Viewing event details!');
          if (notification.eventId != null) {
            Get.toNamed(RouteHelper.getEventDetails(notification.eventId!));
          } else {
            Get.snackbar('Error', 'Event ID is missing.');
          }
          controller.markAsRead(notification.id);
        };
        break;
      default:
        buttonText = 'View Details';
        onPressed = isRead ? null : () {
          Get.snackbar('Action', 'Viewing details!');
          controller.markAsRead(notification.id);
        };
    }

    final Color accentColor = notification.important
        ? AppColors.primaryRed
        : AppColors.primaryRed.withOpacity(0.75);

    final Color cardBackgroundColor = isRead ? Colors.grey[100]! : Colors.white;
    final Color textColor = isRead ? Colors.grey[600]! : Colors.black87;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: accentColor,
          width: notification.important ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.13),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    notification.important ? Icons.warning_amber_rounded : Icons.notifications,
                    color: accentColor,
                    size: 32,
                  ),
                ),
                if (!isRead)
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: AppTextStyles.bodyBold.copyWith(fontSize: 18, color: textColor),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    notification.message,
                    style: AppTextStyles.body.copyWith(fontSize: 15, color: textColor),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        notification.timeAgo,
                        style: AppTextStyles.body.copyWith(color: Colors.grey[600], fontSize: 13),
                      ),
                      if (isRead)
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Chip(
                            label: const Text('Read', style: TextStyle(color: Colors.white, fontSize: 11)),
                            backgroundColor: Colors.green[400],
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRead ? Colors.grey : accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(buttonText, style: AppTextStyles.whiteBody.copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}