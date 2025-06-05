import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bds/controllers/profile_controller.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_constants.dart';
import 'package:bds/widgets/custom_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late ProfileController _profileController;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profileController = Get.find<ProfileController>();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    await _profileController.getProfile();

    if (_profileController.profile != null) {
      final profile = _profileController.profile!;
      _nameController.text = profile.user?.name ?? '';
      _emailController.text = profile.user?.email ?? '';
      _phoneController.text = profile.user?.phone ?? '';
      _bloodTypeController.text = profile.user?.bloodType ?? '';
      _locationController.text = profile.user?.location?.address ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bloodTypeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        if (!controller.isLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Edit Profile')),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            physics: const BouncingScrollPhysics(),
            children: [
              // Profile Image
              Center(
                child: Stack(
                  children: [
                    ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: Ink.image(
                          image: NetworkImage(
                            AppConstants.BASE_URL + 'storage/' + controller.profile!.user!.avatar! ?? AppConstants.BASE_URL + 'images/wana/chiefton.jpg',
                          ),
                          fit: BoxFit.cover,
                          width: 128,
                          height: 128,
                          child: InkWell(onTap: () {
                            // Optional: implement image picker
                          }),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: ClipOval(
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          color: Colors.white,
                          child: ClipOval(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: AppColors.primaryRed,
                              child: const Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                                size: 20,
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

              _buildTextField("Full Name", Icons.person, _nameController),
              const SizedBox(height: 20),
              _buildTextField("Email", Icons.email, _emailController),
              const SizedBox(height: 20),
              _buildTextField("Phone", Icons.phone, _phoneController),
              const SizedBox(height: 20),
              _buildTextField("Blood Type", Icons.bloodtype, _bloodTypeController),
              const SizedBox(height: 20),
              _buildTextField("Location", Icons.location_on, _locationController,
                  suffixIcon: Icons.my_location),
              const SizedBox(height: 20),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: CustomButton(
              label: "Update Info",
              onPressed: () {
                // TODO: Send updated data to backend
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon,
    TextEditingController controller, {
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primaryRed),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: AppColors.primaryRed)
                : null,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryRed, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
