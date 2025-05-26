import 'package:bds/app/theme/app_colors.dart';
import 'package:bds/app/theme/app_text_styles.dart';
import 'package:bds/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/widgets/hero_section.dart';

class DonationProgressScreen extends StatelessWidget {
  final int requiredPints = 5;
  final int confirmedDonors = 3;
  final String hospitalName = "City Blood Center";
  final String hospitalAddress = "123 Health Street, Dar es Salaam";
  final String hospitalLocationUrl = "https://maps.google.com/?q=-6.7924,39.2083"; // example location

  DonationProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int remainingPints = requiredPints - confirmedDonors;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const HeroSection(
            title: 'Donation Progress',
            subtitle: 'Track confirmed donors and donation status',
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildProgressCard(requiredPints, confirmedDonors, remainingPints),
                const SizedBox(height: 24),
                _buildHospitalCard(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(int required, int confirmed, int remaining) {
    return Container(
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
          Text("Request Summary", style: AppTextStyles.subheading),
          const SizedBox(height: 16),
          _buildSummaryRow("Required Pints:", "$required"),
          _buildSummaryRow("Confirmed Donors:", "$confirmed"),
          _buildSummaryRow("Remaining Pints:", "$remaining", highlight: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body),
          Text(
            value,
            style: AppTextStyles.bodyBold.copyWith(
              color: highlight ? AppColors.primaryRed : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalCard(BuildContext context) {
    return Container(
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
          Text("Hospital for Donation", style: AppTextStyles.subheading),
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
    );
  }
}
