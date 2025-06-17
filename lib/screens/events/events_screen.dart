import 'package:bds/controllers/event_controller.dart';
import 'package:bds/models/events_model.dart';
import 'package:bds/routes/route_helper.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import 'package:bds/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../../widgets/hero_section.dart';
import 'package:get/get.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late EventController _eventController;

  @override
  void initState() {
    super.initState();
    _eventController = Get.find<EventController>();
    _eventController.getEventsList(); // Call API here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<EventController>(
        builder: (eventController) {
          if (!eventController.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          if (eventController.eventList.isEmpty) {
            return const Center(child: Text("No events found."));
          }

          return RefreshIndicator(
            onRefresh: () async {
              // This function is called when the user pulls down to refresh.
              // It should typically trigger your data fetching logic.
              await eventController.getEventsList();
            },
            child: CustomScrollView(
              slivers: [
                const HeroSection(
                  title: 'Upcoming Events',
                  subtitle: 'Available events for blood donation drives',
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upcoming Events',
                            style: AppTextStyles.subheading,
                          ),
                          const SizedBox(height: 24),
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: eventController.eventList.length,
                            itemBuilder: (context, index) {
                              return _buildDonorCard(eventController.eventList[index], index);
                            },
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDonorCard(EventModel event, int index) {
    return Card(
      elevation: 4,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title ?? 'Unknown',
              style: AppTextStyles.subheading.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.phone,
                    text: event.user?.phone ?? 'Unknown',
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    icon: Icons.location_on,
                    text: event.location?.name ?? 'Unknown',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Event Date: ${event.eventDate ?? 'N/A'}',
              style: AppTextStyles.body.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: "View Details",
                    onPressed: () {
                      Get.toNamed(RouteHelper.getEventDetails(index));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(icon, color: AppColors.primaryRed, size: 16),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.body,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}