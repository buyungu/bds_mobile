import 'package:bds/controllers/request_controller.dart';
import 'package:bds/models/requests_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import 'package:bds/widgets/custom_button.dart';
import 'package:bds/widgets/hero_section.dart';
import 'package:timeago/timeago.dart' as timeago;

class RespondToRequestScreen extends StatelessWidget {
  const RespondToRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RequestController requestController = Get.find<RequestController>();
    final String? idParam = Get.parameters['pageId'];
    final int requestId = idParam != null ? int.tryParse(idParam) ?? -1 : -1;
    final request = requestController.requestList.firstWhereOrNull((r) => r.id == requestId);

    if (request == null) {
      return Center(child: Text('Request not found'));
    }

    print("Request Title is " + request.id.toString());
    // --- Example static data based on your model ---
    final confirmedDonors = request.donors?.length ?? 0;
    final requestQuantity = (request.quantity ?? 0) + confirmedDonors;
    final remaining = requestQuantity  - confirmedDonors;
    final notes = 'Patient in critical condition. Immediate help required.';

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryRed,
        icon: Icon(Icons.phone, color: Colors.white),
        label: Text('Call Recipient', style: TextStyle(color: Colors.white)),
        onPressed: () async {
          final Uri url = Uri.parse('tel: '+request.recipient?.phone);
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
                _buildHeader(request.bloodType, request.urgency, request.status),
                const SizedBox(height: 18),
                _buildProgressBar(requestQuantity, confirmedDonors, remaining),
                const SizedBox(height: 24),
                _buildCardSection(
                  child: _buildRecipientCard(request.recipient),
                ),
                const SizedBox(height: 18),
                _buildCardSection(
                  child: _buildHospitalCard(context, request.hospital),
                ),
                const SizedBox(height: 18),
                _buildTimeline(request.createdAt, confirmedDonors, request.status),
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
    Color urgencyColor = (urgency.toLowerCase() == 'high' || urgency.toLowerCase() == 'emergence')
        ? AppColors.primaryRed
        : Colors.green;
    Color statusColor = status.toLowerCase() == 'matched'
        ? const Color(0xFFA4FFA7)
        : status.toLowerCase() == 'partially matched'
            ? const Color(0xFFFFD390)
            : const Color(0xFFFF9997);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryRed,
            AppColors.secondaryRed,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Blood type badge
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryRed.withOpacity(0.25),
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Center(
              child: Text(
                bloodType,
                style: AppTextStyles.heading.copyWith(
                  color: AppColors.primaryRed,
                  fontWeight: FontWeight.w900,
                  fontSize: 32,
                  shadows: [
                    Shadow(
                      color: Colors.white,
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Info column with chips stacked vertically
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Chip(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  label: Text(
                    urgency,
                    style: AppTextStyles.bodyBold.copyWith(color: urgencyColor, fontSize: 14),
                  ),
                  backgroundColor: urgencyColor.withOpacity(0.13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                const SizedBox(width: 4),
                Chip(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  label: Text(
                    status,
                    style: AppTextStyles.bodyBold.copyWith(color: statusColor, fontSize: 14),
                  ),
                  backgroundColor: statusColor.withOpacity(0.18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
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

  Widget _buildRecipientCard(Recipient? recipient) {
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
                Text(recipient?.name ?? 'Unknown', style: AppTextStyles.bodyBold.copyWith(fontSize: 18)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.phone, color: AppColors.primaryRed, size: 18),
                    const SizedBox(width: 4),
                    Text(recipient?.phone ?? '', style: AppTextStyles.body),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blue, size: 18),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        recipient?.location?.address ?? '',
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

  Widget _buildHospitalCard(BuildContext context, Hospital? hospital) {
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
            title: Text(hospital?.name ?? 'Unknown', style: AppTextStyles.bodyBold),
            subtitle: Text(hospital?.location?.address ?? '', style: AppTextStyles.body),
          ),
          const SizedBox(height: 12),
          CustomButton(
            label: "View in Google Maps",
           onPressed: () async {
              final String? mapsUrl = hospital?.location?.url;
              final Uri url = Uri.parse(mapsUrl ?? '');
              if (mapsUrl != null && await canLaunchUrl(url)) {
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

  Widget _buildTimeline(String createdAt, int confirmedDonors, String status) {
    final List<Map<String, dynamic>> timeline = [
      {
        'icon': Icons.assignment_turned_in,
        'label': 'Request Created',
        'time': timeago.format(DateTime.parse(createdAt)),
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
        'time': status.toLowerCase() == 'fulfilled'
            ? 'Fulfilled'
            : status.toLowerCase() == 'canceled'
                ? 'Canceled'
                : 'Pending',
        'color': status.toLowerCase() == 'fulfilled'
            ? Colors.green
            : status.toLowerCase() == 'canceled'
                ? Colors.red
                : Colors.grey,
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
                Flexible(
                  child: Text(
                    step['label'],
                    style: AppTextStyles.bodyBold,                    
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    step['time'],
                    style: AppTextStyles.body.copyWith(color: Colors.grey[700]),                    maxLines: 1,
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