import 'package:bds/controllers/event_controller.dart';
import 'package:bds/routes/route_helper.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import 'package:bds/widgets/custom_button.dart';
import 'package:flutter/material.dart'; // Always needed for Flutter widgets
import 'package:url_launcher/url_launcher.dart';
import 'package:bds/widgets/hero_section.dart';
import 'package:get/get.dart'; // GetX import
import 'package:bds/models/events_model.dart'; // Assuming EventModel is used

class EventDetailsScreen extends StatefulWidget {
  final int pageId;

  const EventDetailsScreen({Key? key, required this.pageId}) : super(key: key);

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late final EventController _eventController;
  EventModel? _event;
  bool _isLoading = true;
  int? _actualEventId;

  @override
  void initState() {
    super.initState();
    _eventController = Get.find<EventController>();

    // Determine the event ID from the initial pageId.
    // This logic relies on _eventController.eventList being pre-populated before
    // EventDetailsScreen is pushed. If you navigate using event.id directly,
    // this part can be simplified greatly.
    if (widget.pageId >= 0 && widget.pageId < _eventController.eventList.length) {
      _actualEventId = _eventController.eventList[widget.pageId].id;
    }

    _loadEventData();
  }

  Future<void> _loadEventData() async {
    // Only set loading to true if it's not already true.
    // This prevents unnecessary setState calls if already in a loading state.
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      // Refresh the main list of events from the backend.
      // This is crucial for reflecting enrollment/unenrollment changes.
      await _eventController.getEventsList();

      // After refreshing, find the specific event by its ID.
      if (_actualEventId != null) {
        setState(() {
          _event = _eventController.eventList.firstWhereOrNull((e) => e.id == _actualEventId);
        });

        if (_event == null) {
          // Event not found after refresh (e.g., deleted from backend)
          Get.snackbar(
            'Info',
            'The event you were viewing is no longer available.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blueAccent,
            colorText: Colors.white,
          );
        }
      } else {
        // This case indicates an initial problem getting the event ID.
        Get.snackbar(
          'Error',
          'Event ID could not be determined.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        setState(() {
          _event = null; // Clear event if ID is invalid
        });
      }
    } catch (e) {
      // Handle any errors during data loading (e.g., network issues)
      Get.snackbar(
        'Error',
        'Failed to load event details. Please try again. (${e.toString()})',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      setState(() {
        _event = null; // Clear event on error
      });
    } finally {
      // Ensure loading state is always false when operations complete or fail.
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a full-screen loading indicator if data is being fetched.
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.lightGrey,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryRed),
        ),
      );
    }

    // If _event is null after loading, show an error message with refresh option.
    if (_event == null) {
      return Scaffold(
        backgroundColor: AppColors.lightGrey,
        body: RefreshIndicator(
          onRefresh: _loadEventData,
          color: AppColors.primaryRed,
          backgroundColor: AppColors.lightGrey,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const HeroSection(
                title: 'Event Details',
                subtitle: 'See all details for this blood event',
              ),
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.grey[600], size: 50),
                      const SizedBox(height: 10),
                      Text(
                        'Event not found or invalid. Pull down to refresh.',
                        style: AppTextStyles.body.copyWith(color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        label: 'Go Back',
                        onPressed: () => Get.offNamed(RouteHelper.getEvents()),
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

    // If _event is available, display its details.
    final event = _event!; // Use non-nullable event now that we've handled null case

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _loadEventData,
        color: AppColors.primaryRed,
        backgroundColor: AppColors.lightGrey,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const HeroSection(
              title: 'Event Details',
              subtitle: 'Enroll to Event to Donate blood',
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Display enrollment status if enrolled
                  if (event.isEnrolled == true)
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "You are already enrolled in this event.",
                              style: TextStyle(color: Color(0xFF1B5E20)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Event details card
                  Container(
                    padding: const EdgeInsets.all(20),
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
                        Text(event.title ?? 'N/A', style: AppTextStyles.subheading),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.description ?? 'No description available.',
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Event Date: ${event.eventDate ?? 'N/A'}",
                                style: AppTextStyles.bodyBold,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Location: ${event.location?.address ?? 'N/A'}",
                                style: AppTextStyles.bodyBold,
                              ),
                              const SizedBox(height: 8),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.phone, color: AppColors.primaryRed, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            event.user?.phone ?? 'N/A',
                                            style: AppTextStyles.body,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.location_on, color: AppColors.primaryRed, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            event.location?.name ?? 'N/A',
                                            style: AppTextStyles.body,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Conditional button for enroll/unenroll
                              CustomButton(
                                label: event.isEnrolled == true ? "Unenroll from event" : "Enroll to event",
                                onPressed: () async {
                                  

                                  try {
                                    if (event.isEnrolled == true) {
                                      await _eventController.unenrollFromEvent(event.enrollmentId!);
                                    } else {
                                      await _eventController.enrollToEvent(event.id!);
                                    }
                                    // After success, refresh the UI data
                                    await _loadEventData();
                                  } catch (e) {
                                    // Handle errors and show a snackbar
                                    Get.snackbar(
                                      'Error',
                                      'Operation failed: ${e.toString()}',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  } finally {
                                    // Always dismiss the loading dialog
                                    if (Get.isDialogOpen ?? false) {
                                      Get.back();
                                    }
                                  }
                                },
                                isPrimary: !(event.isEnrolled == true),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Donation center details card
                  Container(
                    padding: const EdgeInsets.all(20),
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
                        Text("Donation center", style: AppTextStyles.subheading),
                        const SizedBox(height: 12),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.local_hospital, color: AppColors.primaryRed, size: 32),
                          title: Text(event.location?.name ?? 'N/A', style: AppTextStyles.bodyBold),
                          subtitle: Text(event.location?.address ?? 'N/A', style: AppTextStyles.body),
                        ),
                        const SizedBox(height: 12),
                        CustomButton(
                          label: "View in Google Maps",
                          onPressed: () async {
                            final String? mapsUrl = event.location?.url;
                            if (mapsUrl != null && mapsUrl.isNotEmpty) {
                              final Uri url = Uri.parse(mapsUrl);
                              try {
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  // Use Get.snackbar for consistency with GetX
                                  Get.snackbar(
                                    'Error',
                                    'Could not launch Google Maps. Invalid URL?',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              } catch (e) {
                                Get.snackbar(
                                  'Error',
                                  'Error launching maps: ${e.toString()}',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            } else {
                              Get.snackbar(
                                'Info',
                                'Map URL not available.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.orange,
                                colorText: Colors.white,
                              );
                            }
                          },
                          isPrimary: true,
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}