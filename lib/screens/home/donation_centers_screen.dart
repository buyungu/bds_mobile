import 'package:flutter/material.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import '../../widgets/hero_section.dart';
import 'package:url_launcher/url_launcher.dart';

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
    'latitude': -6.7924,
    'longitude': 39.2083,
  },
  {
    'name': 'General Health Center',
    'address': '456 Central Ave',
    'distance': '3.8 km',
    'open': false,
    'latitude': -6.8000,
    'longitude': 39.2500,
  },
  {
    'name': 'Red Cross Clinic',
    'address': '789 Elm Road',
    'distance': '1.2 km',
    'open': true,
    'latitude': -6.7700,
    'longitude': 39.2200,
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
                (context, index) => _buildCenterCard(context, centers[index]),
                childCount: centers.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
  }

  Widget _buildCenterCard(BuildContext context, Map<String, dynamic> center) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.all(12),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primaryRed.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.local_hospital, // Updated icon as requested
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
      trailing: InkWell(
  onTap: () async {
    final lat = center['latitude'];
    final lng = center['longitude'];
    final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch map.')),
      );
    }
  },
  child: Container(
    decoration: BoxDecoration(
      color: AppColors.primaryRed.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.all(8),
    child: Icon(
      Icons.arrow_forward,
      color: AppColors.primaryRed,
    ),
  ),
),

    ),
  );
}
