import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import 'package:bds/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/hero_section.dart';

class EventDetailsScreen extends StatelessWidget {
  final int requiredPints = 5;
  final int confirmedDonors = 3;
  final String hospitalName = "City Blood Center";
  final String hospitalAddress = "123 Health Street, Dar es Salaam";
  final String hospitalLocationUrl = "https://maps.google.com/?q=-6.7924,39.2083"; // example location

  EventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const HeroSection(
            title: 'Event Details',
            subtitle: 'Enroll to Event to Donate blood',
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
              Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Title of an event goes here", style: AppTextStyles.subheading),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start, // <-- Add this line
                            children: [
                              Text(
                                "The common content of an ICT policy covers all the major aspects of how technology is to be used, managed, and protected within an organization. A clear and well-structured policy helps ensure consistency, reduces risks, and supports smooth ICT operations across all departments. It also builds accountability among users and promotes a culture of security and professionalism.",
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),

                              Text(
                                "Event Date: 30/7/2025",
                                style: AppTextStyles.bodyBold,
                              ),
                              
                              const SizedBox(height: 8),

                              Text(
                                "Location: Address goes here",
                                style: AppTextStyles.bodyBold,
                              ),
                              
                              SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.phone, color: AppColors.primaryRed, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        "071234567890",
                                        style: AppTextStyles.body,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on, color: AppColors.primaryRed, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        "mabibo mwisho",
                                        style: AppTextStyles.body,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8,),
                            CustomButton(label: "Enroll to an event", onPressed: (){})
                            ],
                          ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Donation Center", style: AppTextStyles.subheading),
                      const SizedBox(height: 12),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.local_hospital, color: AppColors.primaryRed, size: 32),
                        title: Text(hospitalName, style: AppTextStyles.bodyBold),
                        subtitle: Text(hospitalAddress, style: AppTextStyles.body),
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        label: "View in Google Maps",
                        onPressed: () async {
                          final Uri url = Uri.parse(hospitalLocationUrl);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Could not launch Google Maps')),
                            );
                          }
                        },
                        isPrimary: true,
                      ),
                    ],
                  ),
                ),
            ]),
            ),
          ),
        ],
      ),
    );
  }

  

}
