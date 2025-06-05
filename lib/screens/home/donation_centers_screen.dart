import 'package:bds/models/hospitals_model.dart';
import 'package:flutter/material.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import '../../widgets/hero_section.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:bds/controllers/hospital_controller.dart';

class DonationCentersScreen extends StatefulWidget {
  const DonationCentersScreen({super.key});

  @override
  State<DonationCentersScreen> createState() => _DonationCentersScreenState();
}

class _DonationCentersScreenState extends State<DonationCentersScreen> {
  late HospitalController hospitalController;

  @override
  void initState() {
    super.initState();
    hospitalController = Get.find<HospitalController>();
    hospitalController.getHospitals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<HospitalController>(
        builder: (controller) {
          if (!controller.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<HospitalModel> centers = controller.hospitalList;

          return CustomScrollView(
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
          );
        },
      ),
    );
  }

  Widget _buildCenterCard(BuildContext context, HospitalModel center) {
    final location = center.location;
    final address = location?.address;
    final lat = location?.lat;
    final lng = location?.lng;
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
            Icons.local_hospital,
            color: AppColors.primaryRed,
          ),
        ),
        title: Text(
          center.name ?? 'Unknown',
          style: AppTextStyles.bodyBold,
        ),
        subtitle: Text(
          '${address ?? ''}',
          style: AppTextStyles.body,
        ),
        trailing: InkWell(
          onTap: () async {
            if (lat != null && lng != null) {
              final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not launch map.')),
                );
              }
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
}
