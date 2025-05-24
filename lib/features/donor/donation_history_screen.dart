import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/widgets/hero_section.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/donation_model.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/theme/app_colors.dart';

class DonationHistoryScreen extends StatelessWidget {
  const DonationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Donation> donations = MockData.donations;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeroSection(
                title: 'Donation History',
                subtitle: 'Track your past donations',
              ),
              const SizedBox(height: 24),
              if (donations.isEmpty)
                const LoadingIndicator()
              else
                ...donations.map((donation) => _buildDonationCard(donation)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDonationCard(Donation donation) {
    final String formattedDate = DateFormat.yMMMd().format(donation.donatedAt);
    final request = donation.request;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: $formattedDate', style: AppTextStyles.subheading),
            const SizedBox(height: 6),
            Text('Hospital: ${request.hospital}', style: AppTextStyles.body),
            Text('Blood Type: ${request.requester.bloodType}', style: AppTextStyles.body),
            Text('Quantity: ${request.quantity} pint(s)', style: AppTextStyles.body),
            const SizedBox(height: 6),
            Text(
              'Status: ${request.status}',
              style: AppTextStyles.body.copyWith(
                color: request.status == 'Fulfilled' ? AppColors.primaryRed : AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
