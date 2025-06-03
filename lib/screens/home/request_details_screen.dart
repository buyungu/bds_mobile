import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import 'package:bds/widgets/custom_button.dart';
import 'package:bds/widgets/hero_section.dart';

class RequestDetailsScreen extends StatelessWidget {
  const RequestDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- Example static data based on your model ---
    final bloodType = 'A+';
    final urgency = 'High';
    final status = 'Pending';
    final quantity = 4;
    final confirmedDonors = 2;
    final remaining = quantity - confirmedDonors;
    final createdAt = '2024-06-03T10:00:00Z';

    final recipient = {
      'name': 'Jane Doe',
      'phone': '+255 123 456 789',
      'address': 'Mikocheni, Dar es Salaam',
    };

    final hospital = {
      'name': 'City Hospital',
      'address': 'Ali Hassan Mwinyi Rd, Dar es Salaam',
      'lat': -6.777076,
      'lng': 39.242235,
    };

    final notes = 'Patient in critical condition. Immediate help required.';

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryRed,
        icon: Icon(Icons.phone, color: Colors.white),
        label: Text('Call Recipient', style: TextStyle(color: Colors.white)),
        onPressed: () async {
          final Uri url = Uri.parse('tel:${recipient['phone']}');
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          }
        },
      ),
      body: CustomScrollView(
        slivers: [
          const HeroSection(
            title: 'Request Details',
            subtitle: 'See all details for this blood request',
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildHeader(bloodType, urgency, status),
                const SizedBox(height: 18),
                _buildProgressBar(quantity, confirmedDonors, remaining),
                const SizedBox(height: 24),
                _buildCardSection(
                  child: _buildRecipientCard(recipient),
                ),
                const SizedBox(height: 18),
                _buildCardSection(
                  child: _buildHospitalCard(context, hospital),
                ),
                const SizedBox(height: 18),
                _buildTimeline(createdAt, confirmedDonors, status),
                const SizedBox(height: 18),
                _buildCardSection(
                  child: _buildNotes(notes),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  label: remaining > 0 ? 'Donate Now' : 'All Pints Collected!',
                  isPrimary: remaining > 0,
                  onPressed: remaining > 0
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Thank you! You’ve responded to the request.')),
                          );
                        }
                      : () {},
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String bloodType, String urgency, String status) {
    Color urgencyColor = urgency.toLowerCase() == 'high' ? Colors.orange : Colors.green;
    Color statusColor = status.toLowerCase() == 'completed'
        ? Colors.green
        : status.toLowerCase() == 'pending'
            ? Colors.orange
            : AppColors.primaryRed;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryRed.withOpacity(0.9), Colors.redAccent.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: Text(
              bloodType,
              style: AppTextStyles.heading.copyWith(
                color: AppColors.primaryRed,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: urgencyColor,
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
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: AppTextStyles.bodyBold.copyWith(color: statusColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int required, int confirmed, int remaining) {
    double progress = required == 0 ? 0 : confirmed / required;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress.clamp(0, 1),
          minHeight: 14,
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

  Widget _buildCardSection({required Widget child}) {
    return Container(
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
      child: child,
    );
  }

  Widget _buildRecipientCard(Map recipient) {
    return Padding(
      padding: const EdgeInsets.all(18),
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
                Text(recipient['name'], style: AppTextStyles.bodyBold.copyWith(fontSize: 18)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.phone, color: AppColors.primaryRed, size: 18),
                    const SizedBox(width: 4),
                    Text(recipient['phone'], style: AppTextStyles.body),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blue, size: 18),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        recipient['address'],
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

  Widget _buildHospitalCard(BuildContext context, Map hospital) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Hospital for Donation", style: AppTextStyles.subheading),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.local_hospital, color: AppColors.primaryRed, size: 32),
            title: Text(hospital['name'], style: AppTextStyles.bodyBold),
            subtitle: Text(hospital['address'], style: AppTextStyles.body),
          ),
          const SizedBox(height: 12),
          CustomButton(
            label: "View in Google Maps",
            onPressed: () async {
              final Uri url = Uri.parse(
                "https://www.google.com/maps/search/?api=1&query=${hospital['lat']},${hospital['lng']}",
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

  Widget _buildTimeline(String createdAt, int confirmedDonors, String status) {
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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
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
          Text("Progress Timeline", style: AppTextStyles.subheading),
          const SizedBox(height: 10),
          ...timeline.map((step) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: (step['color'] as Color).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(step['icon'], color: step['color'], size: 22),
                ),
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
      ),
    );
  }

  Widget _buildNotes(String notes) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
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
      ),
    );
  }
}