import 'package:flutter/material.dart';
import '../../core/widgets/hero_section.dart';
// import '../../core/widgets/loading_indicator.dart';
import '../../data/mock/mock_data.dart'; // Sample data for now
import '../../data/models/blood_request_model.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/theme/app_colors.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BloodRequest> myRequests = MockData.bloodRequests
        .where((request) => request.requester.id == 'user_1') // Replace with actual user ID logic
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HeroSection(
              title: 'My Requests',
              subtitle: 'Track your blood request status',
            ),
            const SizedBox(height: 16),
            Expanded(
              child: myRequests.isEmpty
                  ? const Center(child: Text('No requests yet.'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: myRequests.length,
                      itemBuilder: (context, index) {
                        final request = myRequests[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Blood Type: ${request.requester.bloodType}', style: AppTextStyles.subheading),
                              const SizedBox(height: 6),
                              Text('Hospital: ${request.hospital}', style: AppTextStyles.body),
                              Text('Urgency: ${request.urgency}', style: AppTextStyles.body),
                              Text('Quantity: ${request.quantity} pints', style: AppTextStyles.body),
                              const SizedBox(height: 6),
                              Text('Status: ${request.status}', style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getStatusColor(request.status),
                              )),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
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
