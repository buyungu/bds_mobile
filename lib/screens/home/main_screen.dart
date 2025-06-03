import 'package:bds/routes/route_helper.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../../widgets/hero_section.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});


  final List<Map<String, dynamic>> nearbyCenters = [
  {
    'name': 'City Hospital 1',
    'distance': '2.1',
    'latitude': -6.7924,
    'longitude': 39.2083,
  },
  {
    'name': 'City Hospital 2',
    'distance': '4.2',
    'latitude': -6.8000,
    'longitude': 39.2500,
  },
  {
    'name': 'City Hospital 3',
    'distance': '6.3',
    'latitude': -6.7700,
    'longitude': 39.2200,
  },
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers:  [
            HeroSection(
              title: 'Welcome Back!',
              subtitle: 'Your donation journey starts here',
            ),

            SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, 4), // changes position of shadow
                      ),
                    ],
                  ),
           

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Emergeny Requests',
                          style: AppTextStyles.subheading
                        ),
                        Icon(
                          Icons.notifications, 
                          color: AppColors.primaryRed,
                          size: 30,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Urgent: Blood type O+ needed.", 
                      style: AppTextStyles.body,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed(RouteHelper.getDonationProgress());
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        "Respond to Request", 
                        style: AppTextStyles.whiteBody
                      ),
                    ),

                  ],
                ),
               ),
               SizedBox(height: 24),
               Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: AppTextStyles.subheading,
                  ),
                  SizedBox(height: 12),
                  GridView.count(
                    padding: EdgeInsets.all(5),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.4,
                    children: [
                      _buildQuickActionCard(
                        context, 
                        label: "Find Donors", 
                        color: Colors.blue, 
                        icon: Icons.local_hospital, 
                        onTap: () {
                          Get.toNamed(RouteHelper.getFind());
                        }
                        
                      ),
                      _buildQuickActionCard(
                        context, 
                        label: "Book Request", 
                        color: Colors.green, 
                        icon: Icons.bloodtype, 
                        onTap: () {
                          Get.toNamed(RouteHelper.getCreateRequest());
                        }
                        
                      ),
                      _buildQuickActionCard(
                        context, 
                        label: "My Requests", 
                        color: Colors.pink, 
                        icon: Icons.warning,
                        onTap: () {
                          Get.toNamed(RouteHelper.getMyRequests());
                        }
                        
                      ),
                      _buildQuickActionCard(
                        context, 
                        label: "Blood Requests", 
                        color: Colors.purple, 
                        icon: Icons.bloodtype_sharp, 
                        onTap: () {
                          Get.toNamed(RouteHelper.getViewRequests());
                        }
                        
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nearby  Centers',
                            style: AppTextStyles.subheading,
                          ),
                          TextButton(
                            onPressed: () { 
                              Get.toNamed(RouteHelper.getCenters());
                            },
                            child: Text(
                              'See All',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.primaryRed,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ListView.builder(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: nearbyCenters.length,
                      itemBuilder: (context, index) {
                        final center = nearbyCenters[index];

                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(12),
                            leading: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primaryRed.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.local_hospital,
                                color: AppColors.primaryRed,
                              ),
                            ),
                            title: Text(
                              center['name'],
                              style: AppTextStyles.bodyBold,
                            ),
                            subtitle: Text(
                              '${center['distance']} km away - Open 24/7',
                              style: AppTextStyles.body,
                            ),
                            trailing: InkWell(
                              onTap: () async {
                                final lat = center['latitude'];
                                final lng = center['longitude'];
                                final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");

                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url, mode: LaunchMode.externalApplication);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Could not open map.')),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryRed.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.primaryRed,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )

                    ],
                  )
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

Widget _buildQuickActionCard(
  BuildContext context, {
  required String label,
  required Color color,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Stack(
      children: [
        Container(
          width: 200,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 15,
                offset: Offset(5, 5), // changes position of shadow
              ),
              BoxShadow(
                color: Colors.white,
                blurRadius: 15,
                spreadRadius: 1,
                offset: Offset(-5, -5), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              SizedBox(height: 16),
              Text(
                label,
                style: AppTextStyles.bodyBold.copyWith(
                  color: AppColors.textDark,
                ),
                // textAlign: TextAlign.center,
              ),
            ],
          ),  
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            
          )
        ),
      ],
      
    ),
  );
 
}
