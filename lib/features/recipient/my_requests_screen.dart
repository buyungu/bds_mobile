import 'package:flutter/material.dart';
import 'package:bds/app/theme/app_colors.dart';
import 'package:bds/app/theme/app_text_styles.dart';
import '../../core/widgets/hero_section.dart';

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
      backgroundColor: Colors.white,
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
                (context, index) => _buildRequestCard(requests[index]),
                childCount: requests.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    Color statusColor;
    switch (request['status']) {
      case 'Approved':
        statusColor = Colors.orange;
        break;
      case 'Fulfilled':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            request['hospital'],
            style: AppTextStyles.bodyBold,
          ),
          const SizedBox(height: 4),
          Text(
            'Blood Type: ${request['bloodType']}',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 4),
          Text(
            'Requested on ${request['date']}',
            style: AppTextStyles.body.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              request['status'],
              style: AppTextStyles.bodyBold.copyWith(color: statusColor),
            ),
          ),
        ],
      ),
    );
  }
}
