import 'package:bds/controllers/donation_controller.dart';
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
class RespondToRequestScreen extends StatefulWidget {
  const RespondToRequestScreen({Key? key}) : super(key: key);

  @override
  State<RespondToRequestScreen> createState() => _RespondToRequestScreenState();
}

class _RespondToRequestScreenState extends State<RespondToRequestScreen> {
  // 1. Declare requestController and request as state variables
  final RequestController requestController = Get.find<RequestController>();
  RequestModel? _request; // Prefix with _ to denote private state variable
  bool _isLoading = true; // Added a loading state

  // Store requestId as state to avoid re-parsing on every build
  late int _requestId;

  @override
  void initState() {
    super.initState();
    final String? idParam = Get.parameters['pageId'];
    _requestId = idParam != null ? int.tryParse(idParam) ?? -1 : -1;
    // 2. Load data when the screen is initialized
    _loadRequestData();
  }

  // 3. Centralized method to load/refresh request data
  Future<void> _loadRequestData() async {
    // Set loading state to true to show a loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch the latest list of requests from the controller
      await requestController.getRequestsList();

      // Find the specific request from the potentially updated list
      // and update the state variable _request. This triggers a rebuild.
      setState(() {
        _request = requestController.requestList.firstWhereOrNull((r) => r.id == _requestId);
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load request details. Please try again. ($e)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      setState(() {
        _request = null; // Clear request on error
      });
    } finally {
      // Set loading state to false once data fetching is complete (or failed)
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 4. Handle loading state
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.lightGrey,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryRed),
        ),
      );
    }

    // 5. Handle case where request is not found after loading
    if (_request == null) {
      return Scaffold(
        backgroundColor: AppColors.lightGrey,
        body: RefreshIndicator(
          onRefresh: _loadRequestData, // Pull to refresh will re-attempt loading
          color: AppColors.primaryRed,
          backgroundColor: AppColors.lightGrey,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(), // Ensure scrollable for RefreshIndicator
            slivers: [
              const HeroSection(
                title: 'Request Details',
                subtitle: 'See all details for this blood request',
              ),
              SliverFillRemaining( // Centers content if list is short
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.grey[600], size: 50),
                      const SizedBox(height: 10),
                      Text(
                        'Request not found. Pull down to refresh.',
                        style: AppTextStyles.body.copyWith(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        label: 'Go Back',
                        onPressed: () => Get.back(),
                        isPrimary: false,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // --- Use the state variable _request throughout the rest of your build method ---
    // Ensure you handle potential nulls for nested properties with ?. or ?? ''
    final confirmedDonors = _request!.donors?.length ?? 0;
    // Assuming request.quantity is the total requested, not quantity + confirmedDonors
    final requestQuantity = (_request!.quantity ?? 0) + confirmedDonors; // Corrected calculation
    final remaining = requestQuantity - confirmedDonors;
    const notes = 'Patient in critical condition. Immediate help required.';

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      floatingActionButton: (_request!.recipient?.phone != null && _request!.recipient!.phone!.isNotEmpty)
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.primaryRed,
              icon: const Icon(Icons.phone, color: Colors.white),
              label: const Text('Call Recipient', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                final Uri url = Uri.parse('tel:${_request!.recipient?.phone}');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  Get.snackbar(
                    'Error',
                    'Could not launch call. Please check if a calling app is available.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
            )
          : null, // Hide FAB if no valid phone number
      body: RefreshIndicator(
        onRefresh: _loadRequestData, // This correctly triggers the refresh logic
        color: AppColors.primaryRed,
        backgroundColor: AppColors.lightGrey,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const HeroSection(
              title: 'Request Details',
              subtitle: 'See all details for this blood request',
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildHeader(_request!.bloodType, _request!.urgency, _request!.status),
                  const SizedBox(height: 18),
                  _buildProgressBar(requestQuantity, confirmedDonors, remaining),
                  const SizedBox(height: 24),
                  _buildCardSection(
                    child: _buildRecipientCard(_request!.recipient),
                  ),
                  const SizedBox(height: 18),
                  _buildCardSection(
                    child: _buildHospitalCard(context, _request!.hospital),
                  ),
                  const SizedBox(height: 18),
                  _buildTimeline(_request!.createdAt, confirmedDonors, _request!.status),
                  const SizedBox(height: 18),
                  _buildCardSection(
                    child: _buildNotes(notes),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    label: (_request!.hasDonated == true) // Explicit check for bool
                        ? 'Already Donated'
                        : remaining > 0
                            ? 'Donate Now'
                            : 'All Pints Collected!',
                    isPrimary: remaining > 0 && !(_request!.hasDonated == true),
                    onPressed: (remaining > 0 && !(_request!.hasDonated == true))
                        ? () async {
                            final donationController = Get.find<DonationController>();

                            Get.dialog(
                              const Center(child: CircularProgressIndicator()),
                              barrierDismissible: false,
                            );

                            try {
                              final response = await donationController.donate(_request!.id!);
                              Get.back();

                              if (response.success) {
                                Get.snackbar(
                                  'Success',
                                  'Thank you! You’ve responded to the request.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                                // IMPORTANT: Refresh the screen's data after a successful donation
                                await _loadRequestData();
                              } else {
                                Get.snackbar(
                                  'Failed',
                                  response.message ?? 'Donation failed.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            } catch (e) {
                              Get.back();
                              Get.snackbar(
                                'Error',
                                'Something went wrong. Try again later. ($e)',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          }
                        : null,
                  ),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets (Updated for null safety and using state variables) ---

  Widget _buildHeader(String? bloodType, String? urgency, String? status) {
    bloodType ??= 'N/A';
    urgency ??= 'Unknown';
    status ??= 'Unknown';

    Color urgencyColor = (urgency.toLowerCase() == 'high' || urgency.toLowerCase() == 'emergency')
        ? AppColors.primaryRed
        : Colors.green;
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'matched':
        statusColor = const Color(0xFFA4FFA7);
        break;
      case 'partially matched':
        statusColor = const Color(0xFFFFD390);
        break;
      case 'fulfilled':
        statusColor = Colors.lightBlueAccent;
        break;
      default:
        statusColor = const Color(0xFFFF9997);
    }

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
                  blurRadius: 8,
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
                  shadows: const [
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
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Chip(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  label: Text(
                    urgency,
                    style: AppTextStyles.bodyBold.copyWith(color: urgencyColor, fontSize: 14),
                  ),
                  backgroundColor: urgencyColor.withOpacity(0.13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                const SizedBox(width: 4),
                Chip(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
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
    double progress = required == 0 ? 0.0 : confirmed / required;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          minHeight: 14,
          backgroundColor: AppColors.primaryRed.withOpacity(0.15),
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
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
        boxShadow: const [
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
            child: const Icon(Icons.person, color: AppColors.primaryRed, size: 32),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipient?.name ?? 'Unknown',
                    style: AppTextStyles.bodyBold.copyWith(fontSize: 18)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.phone, color: AppColors.primaryRed, size: 18),
                    const SizedBox(width: 4),
                    Text(recipient?.phone ?? 'N/A', style: AppTextStyles.body),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.blue, size: 18),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        recipient?.location?.address ?? 'N/A',
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
            leading: const Icon(Icons.local_hospital, color: AppColors.primaryRed, size: 32),
            title: Text(hospital?.name ?? 'Unknown Hospital', style: AppTextStyles.bodyBold),
            subtitle: Text(hospital?.location?.address ?? 'N/A', style: AppTextStyles.body),
          ),
          const SizedBox(height: 12),
          CustomButton(
            label: "View in Google Maps",
            onPressed: () async {
              final String? mapsUrl = hospital?.location?.url;
              if (mapsUrl != null && mapsUrl.isNotEmpty) {
                final Uri url = Uri.parse(mapsUrl);
                try {
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not launch Google Maps. Invalid URL?')),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error launching maps: $e')),
                    );
                  }
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Map URL not available.')),
                  );
                }
              }
            },
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(String? createdAt, int confirmedDonors, String? status) {
    createdAt ??= DateTime.now().toIso8601String();
    status ??= 'Unknown';

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
        'color': confirmedDonors > 0 ? Colors.green : Colors.grey,
      },
      {
        'icon': Icons.check_circle,
        'label': 'Donation Status',
        'time': status.capitalizeFirst ?? 'Pending',
        'color': status.toLowerCase() == 'fulfilled'
            ? Colors.green
            : status.toLowerCase() == 'canceled'
                ? Colors.red
                : Colors.orange,
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
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
                    Expanded(
                      flex: 2,
                      child: Text(
                        step['label'],
                        style: AppTextStyles.bodyBold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: Text(
                        step['time'],
                        style: AppTextStyles.body.copyWith(color: Colors.grey[700]),
                        textAlign: TextAlign.end,
                        maxLines: 1,
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