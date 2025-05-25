import 'package:bds/app/theme/app_colors.dart';
import 'package:bds/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/hero_section.dart';
// import '../../core/widgets/loading_indicator.dart';
// import '../../core/widgets/custom_button.dart';
// import 'dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                        
                          Navigator.pushNamed(context, '/respond'); 
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
                    // SizedBox(height: 24),
                    // DashboardOverview(),
                    // SizedBox(height: 16),
                    // UpcomingEvents(),
                    // SizedBox(height: 16),
                    // ActiveRequests(),
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
                          Navigator.pushNamed(context, '/find'); 
                        }
                        
                      ),
                      _buildQuickActionCard(
                        context, 
                        label: "Book Request", 
                        color: Colors.green, 
                        icon: Icons.bloodtype, 
                        onTap: () {
                          Navigator.pushNamed(context, '/create-request'); // Navigate to Create Request
                        }
                        
                      ),
                      _buildQuickActionCard(
                        context, 
                        label: "My Requests", 
                        color: Colors.pink, 
                        icon: Icons.warning,
                        onTap: () {
                          Navigator.pushNamed(context, '/my-requests');
                        }
                        
                      ),
                      _buildQuickActionCard(
                        context, 
                        label: "Centers", 
                        color: Colors.purple, 
                        icon: Icons.location_on, 
                        onTap: () {
                          Navigator.pushNamed(context, '/centers');
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
                            onPressed: () { },
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
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 4), // changes position of shadow
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
                                'City Hospital ${index + 1}',
                                style: AppTextStyles.bodyBold,
                              ),
                              subtitle: Text(
                                ' ${2.1 * (index + 1)} km away - Open 24/7',
                                style: AppTextStyles.body,
                              ),
                              trailing: InkWell( 
                                onTap: () {},
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, '/donate'); // Navigate to Login after registration
          },
          backgroundColor: AppColors.primaryRed,
          label: Text(
            'Donate Now',
            style: AppTextStyles.whiteBody.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: Icon(Icons.add, color: Colors.white),
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
