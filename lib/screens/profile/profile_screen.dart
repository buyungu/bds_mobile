import 'package:bds/controllers/auth_controller.dart';
import 'package:bds/controllers/profile_controller.dart';
import 'package:bds/routes/route_helper.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_constants.dart';
import 'package:bds/widgets/custom_button.dart';
import 'package:bds/widgets/hero_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    final color = AppColors.primaryRed;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          if (!controller.isLoaded || controller.profile == null || controller.profile!.user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = controller.profile!.user!;
          final imagePath = user.avatar != null && user.avatar!.isNotEmpty
              ? AppConstants.BASE_URL + 'storage/' + user.avatar!
              : AppConstants.BASE_URL + 'images/wana/chiefton.jpg';

          return CustomScrollView(
            slivers: [
              HeroSection(title: "User Account", subtitle: "View and update profile information"),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Center(
                      child: Stack(
                        children: [
                          ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: Ink.image(
                                image: NetworkImage(imagePath),
                                fit: BoxFit.cover,
                                width: 128,
                                height: 128,
                                child: InkWell(onTap: () {}),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/edit-profile');
                              },
                              child: ClipOval(
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  color: Colors.white,
                                  child: ClipOval(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      color: color,
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
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
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                                color: color,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _profileInfoRow(Icons.person, "Full Name", user.name ?? '', color),
                            _divider(),
                            _profileInfoRow(Icons.email, "Email", user.email ?? '', color),
                            _divider(),
                            _profileInfoRow(Icons.phone, "Phone", user.phone ?? '', color),
                            _divider(),
                            _profileInfoRow(Icons.bloodtype, "Blood Type", user.bloodType ?? '', color),
                            _divider(),
                            _profileInfoRow(Icons.location_on, "Location", user.location?.address ?? '', color),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: accent, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  )),
              const SizedBox(height: 4),
              Text(value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Divider(
      thickness: 1,
      height: 1,
      color: Colors.grey.shade300,
    ),
  );
}

