import 'package:flutter/material.dart';
import 'package:bds/utils/app_text_styles.dart';
import '../../widgets/hero_section.dart';

class DonationHistoryScreen extends StatelessWidget {
  const DonationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> donationHistory = [
      {
        'center': 'City Hospital',
        'date': 'May 10, 2025',
        'status': 'Completed',
      },
      {
        'center': 'Red Cross Clinic',
        'date': 'March 20, 2025',
        'status': 'Completed',
      },
      {
        'center': 'Hope Medical Center',
        'date': 'Upcoming: June 15, 2025',
        'status': 'Scheduled',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const HeroSection(
            title: 'Donation History',
            subtitle: 'Track your past and upcoming donations',
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildHistoryCard(donationHistory[index]),
                childCount: donationHistory.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> donation) {
    final isUpcoming = donation['status'] == 'Scheduled';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUpcoming ? Colors.blue.shade50 : Colors.white,
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
        children: [
          Icon(
            isUpcoming ? Icons.event : Icons.check_circle,
            color: isUpcoming ? Colors.blue : Colors.green,
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(donation['center'], style: AppTextStyles.bodyBold),
                const SizedBox(height: 4),
                Text(donation['date'], style: AppTextStyles.body),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isUpcoming ? Colors.blue : Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              donation['status'],
              style: AppTextStyles.whiteBody.copyWith(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
