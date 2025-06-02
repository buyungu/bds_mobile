import 'package:bds/controllers/event_controller.dart';
import 'package:bds/models/events_model.dart';
import 'package:bds/routes/route_helper.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import 'package:bds/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/hero_section.dart';
import 'package:get/get.dart';
// import '../../app/theme/app_text_styles.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String? selectedBloodGroup;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const HeroSection(title: 'Upcoming Events', subtitle: 'Available events for blood donation drives'),

          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Events',
                      style: AppTextStyles.subheading,
                    ),
                   
                    SizedBox(height: 24),
                    GetBuilder<EventController>(builder:(events){
                      return events.isLoaded
                        ? ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: events.eventList.length,
                      itemBuilder: (context, index) {
                        return _buildDonorCard(events.eventList[index], index);
                      },
                    ) : CircularProgressIndicator(
                      color: AppColors.primaryRed,
                    );

                    }),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

 

extension _EventsScreenStateDonorCard on _EventsScreenState {
  Widget _buildDonorCard(EventModel event, int index) {
    return Card(
      elevation: 4,
      color: Colors.white, 
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

                Text(
                  event.title ?? 'Unknown',
                  style: AppTextStyles.subheading.copyWith(fontSize: 18),
                ),

            SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.phone,
                    text: event.user?.phone ?? 'Unknown',
                  ),
                  SizedBox(width: 8),
                  _buildInfoChip(
                    icon: Icons.location_on,
                    text: event.location?.name ?? 'Unknown',
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Event Date: ${event.eventDate ?? 'N/A'}',
              style: AppTextStyles.body.copyWith(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: "View Details", 
                    onPressed: () {
                      Get.toNamed(RouteHelper.getEventDetails(index)); 
                    })
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(icon, color: AppColors.primaryRed, size: 16),
          SizedBox(width: 4),
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
