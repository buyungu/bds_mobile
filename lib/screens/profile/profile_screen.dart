import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bds/controllers/auth_controller.dart';
import 'package:bds/controllers/profile_controller.dart';
import 'package:bds/routes/route_helper.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_constants.dart';
import 'package:bds/widgets/custom_button.dart';
import 'package:bds/widgets/hero_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileController profileController;

  @override
  void initState() {
    super.initState();
    profileController = Get.find<ProfileController>();
    profileController.getProfile();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: AppColors.white,
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          if (!controller.isLoaded || controller.profile?.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = controller.profile!.user!;
          final hasAvatar = user.avatar != null && user.avatar!.isNotEmpty;
          final imagePath = hasAvatar ? AppConstants.BASE_URL + 'storage/' + user.avatar! : null;

          return CustomScrollView(
            slivers: [
              HeroSection(
                title: "User Account",
                subtitle: "View and update profile information",
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Center(
                      child: Stack(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: hasAvatar ? NetworkImage(imagePath!) : null,
                              child: !hasAvatar
                                  ? Text(
                                      user.name?.isNotEmpty == true
                                          ? user.name![0].toUpperCase()
                                          : '',
                                      style: const TextStyle(fontSize: 32, color: Colors.black),
                                    )
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/edit-profile'),
                              child: CircleAvatar(
                                backgroundColor: AppColors.primaryRed,
                                radius: 18,
                                child: Icon(Icons.edit, size: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      shadowColor: Colors.black.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Profile Info',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryRed,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _profileInfoRow(Icons.person, "Full Name", user.name ?? '', AppColors.primaryRed,),
                            _divider(),
                            _profileInfoRow(Icons.email, "Email", user.email ?? '', AppColors.primaryRed,),
                            _divider(),
                            _profileInfoRow(Icons.phone, "Phone", user.phone ?? '', AppColors.primaryRed,),
                            _divider(),
                            _profileInfoRow(Icons.bloodtype, "Blood Type", user.bloodType ?? '', AppColors.primaryRed,),
                            _divider(),
                            _profileInfoRow(Icons.location_on, "Location", user.location?.address ?? '', AppColors.primaryRed,),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          label: "Logout",
          onPressed: () {
            Get.find<AuthController>().clearUserData();
            Get.offNamed(RouteHelper.getInitial());
          },

        ),
      ),
    );
  }

  Widget _profileInfoRow(IconData icon, String label, String value, Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600])),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Divider(thickness: 1, height: 1, color: Colors.grey),
      );
}
