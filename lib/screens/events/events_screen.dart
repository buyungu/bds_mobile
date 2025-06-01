import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import 'package:bds/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/hero_section.dart';
// import '../../app/theme/app_text_styles.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String? selectedBloodGroup;

  final List<Map<String, dynamic>> donors = [
    {
      'title': 'John Doe',
      'location': 'New York',
      'event_date': '2023-10-01',
      'contact': '+255 712 345 678' // replaced email with Tanzanian phone number
    },
    {
      'title': 'Jane Smith',
      'phone': 'B-',
      'location': 'Los Angeles',
      'event_date': '2023-09-15',
      'contact': '+255 713 456 789'
    },
    {
      'title': 'Alice Johnson',
      'phone': 'O+',
      'location': 'Chicago',
      'event_date': '2023-08-20',
      'contact': '+255 714 567 890'
    },
    {
      'title': 'Bob Brown',
      'phone': 'AB-',
      'location': 'Houston',
      'event_date': '2023-07-10',
      'contact': '+255 715 678 901'
    },
  ];


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
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: donors.length,
                      itemBuilder: (context, index) {
                        return _buildDonorCard(donors[index]);
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
  }
}

 

extension _EventsScreenStateDonorCard on _EventsScreenState {
  Widget _buildDonorCard(Map<String, dynamic> donor) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  donor['title'] ?? 'Unknown',
                  style: AppTextStyles.subheading.copyWith(fontSize: 18),
                ),
               
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip(
                  icon: Icons.phone,
                  text: donor['contact'] ?? 'Unknown',
                ),
                _buildInfoChip(
                  icon: Icons.location_on,
                  text: donor['location'] ?? 'Unknown',
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Event Date: ${donor['event_date'] ?? 'N/A'}',
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
                      Navigator.pushNamed(context, '/event-details'); 
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
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryRed, size: 16),
          SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }
}
