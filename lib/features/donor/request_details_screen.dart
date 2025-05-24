import 'package:flutter/material.dart';
import '../../core/widgets/hero_section.dart';
import '../../data/models/blood_request_model.dart';
// import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class RequestDetailsScreen extends StatelessWidget {
  final BloodRequest request;

  const RequestDetailsScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeroSection(
                title: 'Request Details',
                subtitle: 'Information about your request',
              ),
              const SizedBox(height: 24),
              _buildDetailRow('Hospital:', request.hospital),
              _buildDetailRow('Location:', request.requester.location),
              _buildDetailRow('Blood Type:', request.requester.bloodType),
              _buildDetailRow('Quantity:', '${request.quantity} pint(s)'),
              _buildDetailRow('Urgency:', request.urgency),
              _buildDetailRow('Status:', request.status),
              const SizedBox(height: 16),
              // if (request.notes != null && request.notes!.isNotEmpty)
              //   _buildDetailRow('Notes:', request.notes!),
              // const SizedBox(height: 24),
              // const Text(
              //   'Donor Contributions',
              //   style: AppTextStyles.subheading,
              // ),
              // const SizedBox(height: 8),
              // ...request.donors.map(
              //   (donor) => Card(
              //     margin: const EdgeInsets.only(bottom: 12),
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              //     child: ListTile(
              //       leading: const Icon(Icons.person, color: AppColors.primaryRed),
              //       title: Text(donor.name),
              //       subtitle: Text('Pints: ${donor.pintsDonated}'),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title ', style: AppTextStyles.bodyBold),
          Expanded(child: Text(value, style: AppTextStyles.body)),
        ],
      ),
    );
  }
}
