import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/hero_section.dart';

class RespondToRequestScreen extends StatelessWidget {
  const RespondToRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final donationRequest = {
      'bloodType': 'O+',
      'hospital': 'City Hospital',
      'location': 'Downtown, Zone 5',
      'notes': 'Patient in critical condition. Immediate help required.',
      'distance': '2.5 km away',
      'requestedAt': '5 minutes ago',
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const HeroSection(
            title: 'Donation Request',
            subtitle: 'Details of the blood request',
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow('Blood Type', donationRequest['bloodType']!, highlight: true),
                      const SizedBox(height: 12),
                      _infoRow('Hospital', donationRequest['hospital']!),
                      const SizedBox(height: 12),
                      _infoRow('Location', donationRequest['location']!),
                      const SizedBox(height: 12),
                      _infoRow('Distance', donationRequest['distance']!),
                      const SizedBox(height: 12),
                      _infoRow('Requested', donationRequest['requestedAt']!),
                      const SizedBox(height: 16),
                      Text(
                        'Notes',
                        style: AppTextStyles.subheading,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        donationRequest['notes']!,
                        style: AppTextStyles.body.copyWith(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          label: 'Donate Now',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Thank you! You’ve responded to the request.')),
            );
            // Navigate or trigger further action
            Navigator.pushNamed(context, '/donation-progress');

          },
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.body),
        Text(
          value,
          style: highlight
              ? AppTextStyles.bodyBold.copyWith(color: AppColors.primaryRed)
              : AppTextStyles.bodyBold,
        ),
      ],
    );
  }
}
