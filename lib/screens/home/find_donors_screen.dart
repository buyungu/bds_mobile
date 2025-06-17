import 'package:bds/controllers/donor_controller.dart';
import 'package:bds/models/donors_model.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/hero_section.dart';

class FindDonors extends StatefulWidget {
  const FindDonors({super.key});

  @override
  State<FindDonors> createState() => _FindDonorsState();
}

class _FindDonorsState extends State<FindDonors> {
  @override
  void initState() {
    super.initState();
    // Make sure DonorController is registered with GetX
    Get.find<DonorController>().getDonorsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<DonorController>(
        builder: (donorController) {
          if (!donorController.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          // Get unique blood types and locations from the donor list
          final bloodTypes = donorController.donorList
              .map((d) => d.bloodType ?? '')
              .toSet()
              .where((e) => e.isNotEmpty)
              .toList();
          final locations = donorController.donorList
              .map((d) => d.location?.name ?? '')
              .toSet()
              .where((e) => e.isNotEmpty)
              .toList();

          // Filtering logic
          final filteredDonors = donorController.donorList.where((donor) {
            final matchesBloodType = donorController.selectedBloodGroup == null ||
                donor.bloodType == donorController.selectedBloodGroup;
            final matchesLocation = donorController.selectedLocation == null ||
                donor.location?.name == donorController.selectedLocation;
            return matchesBloodType && matchesLocation;
          }).toList();

          return RefreshIndicator(
            onRefresh: () async {
              // This function is called when the user pulls down to refresh.
              // It should typically trigger your data fetching logic.
              await donorController.getDonorsList();
            },
            child: CustomScrollView(
              slivers: [
                const HeroSection(
                    title: 'Find Donors',
                    subtitle: 'Search for blood donors in your area'),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Filter by Blood Type",
                            style: AppTextStyles.subheading,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: bloodTypes.map((type) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    checkmarkColor: donorController.selectedBloodGroup == type
                                        ? Colors.white
                                        : Colors.black,
                                    label: Text(type),
                                    selected: donorController.selectedBloodGroup == type,
                                    onSelected: (selected) {
                                      donorController.setSelectedBloodGroup(
                                          selected ? type : null);
                                    },
                                    selectedColor: AppColors.primaryRed,
                                    labelStyle: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: donorController.selectedBloodGroup == type
                                          ? Colors.white
                                          : AppColors.textDark,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: donorController.selectedLocation,
                            decoration: InputDecoration(
                              labelText: 'Select Location',
                              prefixIcon: Icon(
                                Icons.location_on,
                                color: AppColors.primaryRed,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppColors.primaryRed),
                              ),
                            ),
                            items: locations.map<DropdownMenuItem<String>>((location) {
                              return DropdownMenuItem<String>(
                                value: location,
                                child: Text(location),
                              );
                            }).toList(),
                            onChanged: (value) {
                              donorController.setSelectedLocation(value);
                            },
                          ),
                          const SizedBox(height: 16),
                          filteredDonors.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'No donors found',
                                        style: AppTextStyles.body.copyWith(
                                          color: Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Try adjusting your filters or location.',
                                        style: AppTextStyles.body.copyWith(
                                          color: Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: filteredDonors.length,
                                  itemBuilder: (context, index) {
                                    return _buildDonorCard(filteredDonors[index], context);
                                  },
                                ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _buildDonorCard(DonorModel donor, BuildContext context) {
  final isAvailable = true; // Replace with your logic if needed

  return Card(
    elevation: 4,
    color: Colors.white,
    margin: const EdgeInsets.only(bottom: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  donor.name ?? 'Unknown',
                  style: AppTextStyles.subheading.copyWith(fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isAvailable ? AppColors.primaryRed : Colors.grey[400],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isAvailable ? 'Available' : 'Unavailable',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _buildInfoChip(
                icon: Icons.bloodtype,
                text: donor.bloodType ?? 'Unknown',
              ),
              _buildInfoChip(
                icon: Icons.location_on,
                text: donor.location?.name ?? 'Unknown',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Last Donation: 30/1/2023', // Consider making this dynamic based on donor data
            style: AppTextStyles.body.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: isAvailable && donor.phone != null
                      ? () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: Text(
                                  'Contact Donor',
                                  style: AppTextStyles.subheading,
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Contact Number: ',
                                      style: AppTextStyles.bodyBold,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      donor.phone ?? 'Not available',
                                      style: AppTextStyles.body.copyWith(
                                          color: AppColors.primaryRed),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Do you want to call this donor?',
                                      style: AppTextStyles.body,
                                    )
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryRed,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextButton(
                                      onPressed: () async {
                                        final Uri phoneUri = Uri(
                                            scheme: 'tel', path: donor.phone);
                                        if (await canLaunchUrl(phoneUri)) {
                                          await launchUrl(phoneUri);
                                        } else {
                                          if (context.mounted) { // Check if widget is mounted before showing SnackBar
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Cannot make a phone call')),
                                            );
                                          }
                                        }
                                        if (context.mounted) { // Check if widget is mounted before popping
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        textStyle: AppTextStyles.action,
                                      ),
                                      child: const Text('Call'),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Contact Donor'),
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}

Widget _buildInfoChip({required IconData icon, required String text}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primaryRed, size: 16),
        const SizedBox(width: 4),
        Flexible( // <-- This prevents overflow
          child: Text(
            text,
            style: AppTextStyles.body,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}