import 'package:flutter/material.dart';
import 'package:bds/app/theme/app_colors.dart';
import 'package:bds/app/theme/app_text_styles.dart';
import '../../core/widgets/hero_section.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Urgent Blood Request',
        'message': 'O+ blood needed at City Hospital.',
        'time': '2 mins ago',
        'type': 'emergency',
        'important': true,
      },
      {
        'title': 'Donation Reminder',
        'message': 'You can donate again this week.',
        'time': '1 day ago',
        'type': 'reminder',
        'important': false,
      },
      {
        'title': 'Center Update',
        'message': 'Red Cross Clinic now open 24/7.',
        'time': '3 days ago',
        'type': 'center_update',
        'important': false,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const HeroSection(
            title: 'Notifications',
            subtitle: 'Stay updated with your donation journey',
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildNotificationCard(notifications[index]),
                childCount: notifications.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    String type = notification['type'];
    String buttonText = '';
    VoidCallback? onPressed;

    switch (type) {
      case 'emergency':
        buttonText = 'Respond Now';
        onPressed = () {
          // Navigator.pushNamed(context, '/emergency');
        };
        break;
      case 'reminder':
        buttonText = 'Book Donation';
        onPressed = () {
          // Navigator.pushNamed(context, '/donate');
        };
        break;
      case 'center_update':
        buttonText = 'View Center';
        onPressed = () {
          // Navigator.pushNamed(context, '/centers');
        };
        break;
      default:
        buttonText = 'View Details';
        onPressed = () {};
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: notification['important']
            ? AppColors.primaryRed.withOpacity(0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            notification['important'] ? Icons.warning : Icons.notifications,
            color: notification['important']
                ? AppColors.primaryRed
                : Colors.grey,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification['title'], style: AppTextStyles.bodyBold),
                const SizedBox(height: 4),
                Text(notification['message'], style: AppTextStyles.body),
                const SizedBox(height: 6),
                Text(
                  notification['time'],
                  style: AppTextStyles.body.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(buttonText, style: AppTextStyles.whiteBody),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
