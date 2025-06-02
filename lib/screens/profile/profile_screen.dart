import 'package:bds/utils/app_colors.dart';
import 'package:bds/widgets/custom_button.dart';
import 'package:bds/widgets/hero_section.dart';
import 'package:flutter/material.dart';

// Dummy user (copied from edit_profile_screen.dart)
class User {
  final String imagePath;
  final String name;
  final String email;
  final String phone;
  final String bloodType;
  final String location;

  const User({
    required this.imagePath,
    required this.name,
    required this.email,
    required this.phone,
    required this.bloodType,
    required this.location,
  });
}

const User dummyUser = User(
  imagePath: 'http://10.0.2.2:8000/images/wana/toto.jpg',

  name: 'John Doe',
  email: 'john.doe@example.com',
  phone: '0757405770',
  bloodType: 'A+',
  location: 'Mataa shungashunga, Dar es Salaam 16103, Tanzania',
);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = AppColors.primaryRed;
    final user = dummyUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          HeroSection(title: "User Accout", subtitle: "View and update profile Iformation"),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Center(
                  child: Stack(
                    children: [
                      ClipOval(
                        child: Material(
                          color: Colors.transparent,
                          child: Ink.image(
                            image: NetworkImage(user.imagePath),
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
                              padding: EdgeInsets.all(3),
                              color: Colors.white,
                              child: ClipOval(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  color: color,
                                  child: Icon(
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

                // Static user info
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
                      _profileInfoRow(Icons.person, "Full Name", user.name, color),
                      _divider(),
                      _profileInfoRow(Icons.email, "Email", user.email, color),
                      _divider(),
                      _profileInfoRow(Icons.phone, "Phone", user.phone, color),
                      _divider(),
                      _profileInfoRow(Icons.bloodtype, "Blood Type", user.bloodType, color),
                      _divider(),
                      _profileInfoRow(Icons.location_on, "Location", user.location, color),
                    ],
                  ),
                ),
              ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          label: "Logout",
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
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
                style: TextStyle(
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

