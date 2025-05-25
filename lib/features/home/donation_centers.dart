import 'package:flutter/material.dart';
import 'package:bds/app/theme/app_colors.dart';
import 'package:bds/app/theme/app_text_styles.dart';
import '../../core/widgets/hero_section.dart';

class DonationCentersScreen extends StatelessWidget {
  const DonationCentersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> centers = [
      {
        'name': 'City Hospital',
        'address': '123 Main Street',
        'distance': '2.5 km',
        'open': true,
      },
      {
        'name': 'General Health Center',
        'address': '456 Central Ave',
        'distance': '3.8 km',
        'open': false,
      },
      {
        'name': 'Red Cross Clinic',
        'address': '789 Elm Road',
        'distance': '1.2 km',
        'open': true,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          HeroSection(
            title: 'Donation Centers',
            subtitle: 'Find nearby centers and book a visit',
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search centers...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildCenterCard(centers[index]),
                childCount: centers.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterCard(Map<String, dynamic> center) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.location_on,
            color: AppColors.primaryRed,
          ),
        ),
        title: Text(
          center['name'],
          style: AppTextStyles.bodyBold,
        ),
        subtitle: Text(
          '${center['address']} - ${center['distance']}',
          style: AppTextStyles.body,
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: center['open']
                ? Colors.green.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            center['open'] ? 'Open' : 'Closed',
            style: AppTextStyles.bodyBold.copyWith(
              color: center['open'] ? Colors.green : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
