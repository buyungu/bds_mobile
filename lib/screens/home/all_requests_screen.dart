import 'package:flutter/material.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import '../../widgets/hero_section.dart';
import '../../widgets/custom_button.dart';

class AllRequestsScreen extends StatelessWidget {
  const AllRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> requests = [
      {
        'bloodType': 'A+',
        'hospital': 'St. Mary Hospital',
        'location': 'Eastside, Zone 3',
        'time': '10 minutes ago',
        'notes': 'Accident emergency case.',
      },
      {
        'bloodType': 'O-',
        'hospital': 'Unity Medical Center',
        'location': 'West Avenue, Zone 1',
        'time': '30 minutes ago',
        'notes': 'Child surgery requiring rare blood.',
      },
      {
        'bloodType': 'B+',
        'hospital': 'Red Cross Clinic',
        'location': 'Downtown',
        'time': '1 hour ago',
        'notes': 'Scheduled operation tomorrow.',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const HeroSection(
            title: 'All Blood Requests',
            subtitle: 'Find requests near you',
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
  }

  Widget _buildRequestCard(BuildContext context, Map<String, String> request) {
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
            '${request['bloodType']} needed at ${request['hospital']}',
            style: AppTextStyles.bodyBold.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            request['location']!,
            style: AppTextStyles.body.copyWith(color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            request['time']!,
            style: AppTextStyles.body.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Notes: ${request['notes']}',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 12),
          CustomButton(
            label: 'View Details',
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => RespondToRequestScreen()));
              Navigator.pushNamed(context, '/respond');
            },
          ),
        ],
      ),
    ),
  );
}
