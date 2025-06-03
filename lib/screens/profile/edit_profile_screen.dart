import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_constants.dart';
import 'package:bds/widgets/custom_button.dart';
import 'package:flutter/material.dart';

// Simple User Model
class User {
  String imagePath;
  String name;
  String email;
  String phone;
  String bloodType;
  String location;

  User({
    required this.imagePath,
    required this.name,
    required this.email,
    required this.phone,
    required this.bloodType,
    required this.location,
  });
}

// Dummy user (could replace with shared preferences logic)
User dummyUser = User(
  imagePath: AppConstants.BASE_URL+'images/wana/toto.jpg',
  name: 'John Doe',
  email: 'john.doe@example.com',
  phone: '0757405770',
  bloodType: 'A+',
  location: 'Mataa shungashunga, Dar es Salaam 16103, Tanzania',
);

// Edit Profile Screen
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = dummyUser;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Edit Profile')),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          physics: BouncingScrollPhysics(),
          children: [
            // Profile Image
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
                        child: InkWell(
                          onTap: () async {
                            // Handle image tap or edit here
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: ClipOval(
                      child: Container(
                        padding: EdgeInsets.all(3),
                        color: Colors.white,
                        child: ClipOval(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            color: AppColors.primaryRed,
                            child: Icon(
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

            // Full Name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Full Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  controller: TextEditingController(text: user.name),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person, color: AppColors.primaryRed),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.primaryRed.withOpacity(0.5), width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (name) => setState(() => user.name = name),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Email
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  controller: TextEditingController(text: user.email),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: AppColors.primaryRed),
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
                  onChanged: (email) => setState(() => user.email = email),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Phone
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Phone', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  controller: TextEditingController(text: user.phone),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone, color: AppColors.primaryRed),
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
                  onChanged: (phone) => setState(() => user.phone = phone),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Blood Type
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Blood Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  controller: TextEditingController(text: user.bloodType),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.bloodtype, color: AppColors.primaryRed),
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
                  onChanged: (bloodType) => setState(() => user.bloodType = bloodType),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Location
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  controller: TextEditingController(text: user.location),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_on, color: AppColors.primaryRed),
                    suffixIcon: Icon(Icons.my_location, color: AppColors.primaryRed),
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
                  onChanged: (location) => setState(() => user.location = location),
                ),
              ],
            ),
            const SizedBox(height: 20),

            
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: CustomButton(
          label: "Update Info",
          onPressed: () {
          },
        ),
      ),
      );
}
