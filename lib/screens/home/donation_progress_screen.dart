import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import 'package:bds/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/hero_section.dart';

class DonationProgressScreen extends StatelessWidget {
  const DonationProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- Static Data ---
    final String bloodType = 'O+';
    final String urgency = 'High';
    final String status = 'Pending';
    final int requiredPints = 5;
    final int confirmedDonors = 3;
    final int remainingPints = (requiredPints - confirmedDonors).clamp(0, requiredPints);
    final String recipientName = 'Jane Doe';
    final String recipientPhone = '+255 123 456 789';
    final String recipientAddress = 'Mikocheni, Dar es Salaam';
    final String hospitalName = 'City Hospital';
    final String hospitalAddress = 'Ali Hassan Mwinyi Rd, Dar es Salaam';
    final double hospitalLat = -6.777076;
    final double hospitalLng = 39.242235;
    final String createdAt = '2024-06-03T10:00:00Z';
    final String notes = 'Patient in critical condition. Immediate help required.';

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
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
                _buildProgressBar(bloodType, urgency, status, requiredPints, confirmedDonors, remainingPints),
                const SizedBox(height: 24),
                _buildRecipientCard(recipientName, recipientPhone, recipientAddress),
                const SizedBox(height: 18),
                _buildHospitalCard(context, hospitalName, hospitalAddress, hospitalLat, hospitalLng),
                const SizedBox(height: 18),
                _buildStatusTimeline(createdAt, confirmedDonors, status),
                const SizedBox(height: 18),
                _buildNotes(notes),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          label: remainingPints > 0 ? 'Donate Now' : 'All Pints Collected!',
          isPrimary: remainingPints > 0,
          onPressed: remainingPints > 0
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thank you! You’ve responded to the request.')),
                  );
                }
              : () {},
        ),
      ),
    );
  }

  Widget _buildProgressBar(String bloodType, String urgency, String status, int required, int confirmed, int remaining) {
    double progress = required == 0 ? 0 : confirmed / required;
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
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primaryRed,
                child: Text(
                  bloodType,
                  style: AppTextStyles.heading.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: urgency.toLowerCase() == 'high'
                      ? Colors.orange
                      : Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  urgency,
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: status.toLowerCase() == 'completed'
                      ? Colors.green.withOpacity(0.15)
                      : status.toLowerCase() == 'pending'
                          ? Colors.orange.withOpacity(0.15)
                          : AppColors.primaryRed.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: AppTextStyles.bodyBold.copyWith(
                    color: status.toLowerCase() == 'completed'
                        ? Colors.green
                        : status.toLowerCase() == 'pending'
                            ? Colors.orange
                            : AppColors.primaryRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: 12,
            backgroundColor: AppColors.primaryRed.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryRow("Required", "$required"),
              _buildSummaryRow("Confirmed", "$confirmed"),
              _buildSummaryRow("Remaining", "$remaining", highlight: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool highlight = false}) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.body),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.bodyBold.copyWith(
            color: highlight ? AppColors.primaryRed : AppColors.textDark,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildRecipientCard(String name, String phone, String address) {
    return Container(
      padding: const EdgeInsets.all(18),
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primaryRed.withOpacity(0.15),
            child: Icon(Icons.person, color: AppColors.primaryRed, size: 32),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.bodyBold.copyWith(fontSize: 18)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.phone, color: AppColors.primaryRed, size: 18),
                    const SizedBox(width: 4),
                    Text(phone, style: AppTextStyles.body),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blue, size: 18),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        address,
                        style: AppTextStyles.body.copyWith(color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalCard(BuildContext context, String name, String address, double lat, double lng) {
    return Container(
      padding: const EdgeInsets.all(18),
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
            title: Text(name, style: AppTextStyles.bodyBold),
            subtitle: Text(address, style: AppTextStyles.body),
          ),
          const SizedBox(height: 12),
          CustomButton(
            label: "View in Google Maps",
            onPressed: () async {
              final Uri url = Uri.parse(
                "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
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

  Widget _buildStatusTimeline(String createdAt, int confirmedDonors, String status) {
    final List<Map<String, dynamic>> timeline = [
      {
        'icon': Icons.assignment_turned_in,
        'label': 'Request Created',
        'time': '10 min ago',
        'color': Colors.blue,
      },
      {
        'icon': Icons.people,
        'label': 'Donors Confirmed',
        'time': '$confirmedDonors donors confirmed',
        'color': Colors.green,
      },
      {
        'icon': Icons.check_circle,
        'label': 'Donation Complete',
        'time': status.toLowerCase() == 'completed' ? 'Completed' : 'Pending',
        'color': status.toLowerCase() == 'completed' ? Colors.green : Colors.grey,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Progress Timeline", style: AppTextStyles.subheading),
        const SizedBox(height: 10),
        ...timeline.map((step) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Icon(step['icon'], color: step['color'], size: 22),
              const SizedBox(width: 10),
              Text(step['label'], style: AppTextStyles.bodyBold),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  step['time'],
                  style: AppTextStyles.body.copyWith(color: Colors.grey[700]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildNotes(String notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notes', style: AppTextStyles.subheading),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryRed.withOpacity(0.07),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            notes,
            style: AppTextStyles.body.copyWith(color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
