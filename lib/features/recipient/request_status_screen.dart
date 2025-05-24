import 'package:flutter/material.dart';
import '../../core/widgets/hero_section.dart';
// import '../../core/widgets/loading_indicator.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/theme/app_colors.dart';
import '../../data/models/blood_request_model.dart';
import '../../data/mock/mock_data.dart'; // Replace with actual data source

class RequestStatusScreen extends StatelessWidget {
  final String requestId;

  const RequestStatusScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    // Simulate fetching the request based on the ID
    final BloodRequest request = MockData.bloodRequests.firstWhere(
      (r) => r.id == requestId,
      orElse: () => BloodRequest.empty(), // Replace with error handling or null check
    );

    if (request.id == '') {
      return const Scaffold(
        body: Center(child: Text('Request not found')),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HeroSection(
              title: 'Request Status',
              subtitle: 'Check donor contributions and status',
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Blood Type:', request.requester.bloodType),
                    _buildDetailRow('Hospital:', request.hospital),
                    _buildDetailRow('Urgency:', request.urgency),
                    _buildDetailRow('Quantity:', '${request.quantity} pints'),
                    _buildDetailRow('Status:', request.status,
                        valueColor: _getStatusColor(request.status)),
                    const SizedBox(height: 24),
                    Text('Donor Contributions:', style: AppTextStyles.subheading),
                    const SizedBox(height: 12),
                    // ...request.contributions.map((donor) {
                    //   return Container(
                    //     margin: const EdgeInsets.only(bottom: 10),
                    //     padding: const EdgeInsets.all(12),
                    //     decoration: BoxDecoration(
                    //       color: AppColors.white,
                    //       borderRadius: BorderRadius.circular(12),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.black12,
                    //           blurRadius: 5,
                    //           offset: Offset(0, 3),
                    //         )
                    //       ],
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text(donor.name, style: AppTextStyles.body),
                    //         Text('${donor.pintsDonated} pints', style: AppTextStyles.body),
                    //       ],
                    //     ),
                    //   );
                    // }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body.copyWith(color: valueColor ?? AppColors.black),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'fulfilled':
        return Colors.green;
      case 'partially':
        return Colors.orange;
      default:
        return AppColors.primaryRed;
    }
  }
}
