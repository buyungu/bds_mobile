import 'package:bds/controllers/event_controller.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import 'package:bds/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/hero_section.dart';
import 'package:get/get.dart';

class EventDetailsScreen extends StatelessWidget {
  final int pageId;

  EventDetailsScreen({Key? key, required this.pageId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var event = Get.find<EventController>().eventList[pageId];
    print("Page Id is "+pageId.toString());
    print("Event Title is "+event.title.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const HeroSection(
            title: 'Event Details',
            subtitle: 'Enroll to Event to Donate blood',
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
              Container(
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
                        Text(event.title, style: AppTextStyles.subheading),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start, // <-- Add this line
                            children: [
                              Text(
                                event.description,
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),

                              Text(
                                "Event Date: "+event.eventDate,
                                style: AppTextStyles.bodyBold,
                              ),
                              
                              const SizedBox(height: 8),

                              Text(
                                "Location: "+event.location.address,
                                style: AppTextStyles.bodyBold,
                              ),
                              
                              SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.phone, color: AppColors.primaryRed, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          event.user.phone,
                                          style: AppTextStyles.body,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.location_on, color: AppColors.primaryRed, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          event.location.name,
                                          style: AppTextStyles.body,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8,),
                            CustomButton(label: "Enroll to an event", onPressed: (){})
                            ],
                          ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
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
                      Text("Donation center", style: AppTextStyles.subheading),
                      const SizedBox(height: 12),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.local_hospital, color: AppColors.primaryRed, size: 32),
                        title: Text(event.location.name, style: AppTextStyles.bodyBold),
                        subtitle: Text(event.location.address, style: AppTextStyles.body),
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        label: "View in Google Maps",
                        onPressed: () async {
                          final Uri url = Uri.parse(event.location.url);
                          if (await canLaunchUrl(url)) {
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
                ),
            ]),
            ),
          ),
        ],
      ),
    );
  }

  

}
