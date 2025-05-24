import 'package:flutter/material.dart';
import '../../core/widgets/hero_section.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/blood_request_model.dart';
import '../../app/theme/app_text_styles.dart';

class DonateScreen extends StatelessWidget {
  const DonateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BloodRequest> requests = MockData.bloodRequests;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeroSection(
              title: 'Donate Blood',
              subtitle: 'Choose a request to donate to',
            ),
            const SizedBox(height: 24),
            ...requests.map((request) => _buildRequestCard(context, request)),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, BloodRequest request) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hospital: ${request.hospital}', style: AppTextStyles.subheading),
            const SizedBox(height: 8),
            Text('Blood Type Needed: ${request.requester.bloodType}', style: AppTextStyles.body),
            Text('Urgency: ${request.urgency}', style: AppTextStyles.body),
            Text('Quantity: ${request.quantity} pint(s)', style: AppTextStyles.body),
            Text('Location: ${request.requester.location}', style: AppTextStyles.body),
            const SizedBox(height: 12),
            CustomButton(
              label: 'Donate 1 Pint',
              onPressed: () {
                // Handle donation action
              },
            )
          ],
        ),
      ),
    );
  }
}
