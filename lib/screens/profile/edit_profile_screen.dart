import 'dart:io';

import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bds/controllers/profile_controller.dart';
import 'package:bds/models/profile_model.dart';
import 'package:bds/controllers/location_controller.dart';
import 'package:bds/models/location.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _selectedBloodType;
  Location? _selectedLocation;

  final List<String> bloodTypes = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];

  // File? _pickedImage;
  // final ImagePicker _picker = ImagePicker();

  // Future<void> _pickImageFromGallery() async {
  //   final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() => _pickedImage = File(pickedFile.path));
  //   }
  // }

  // Future<void> _pickImage() async {
  //   final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
  //   if (pickedFile != null) {
  //     setState(() => _pickedImage = File(pickedFile.path));
  //   }
  // }



  @override
  void initState() {
    super.initState();
    final user = Get.find<ProfileController>().profile?.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _selectedBloodType = user?.bloodType;
    _selectedLocation = user?.location;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<ProfileController>();
      final user = User(
        id: controller.profile?.user?.id,
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        bloodType: _selectedBloodType,
        location: _selectedLocation,
        // avatar: _pickedImage?.path ?? controller.profile?.user?.avatar,
      );
      await controller.editProfile(user);
      if (controller.isLoaded) {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!controller.isLoaded || controller.profile == null || controller.profile!.user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                            child: GestureDetector(
                              onTap: () {},
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: controller.profile!.user!.avatar != null &&
                                            controller.profile!.user!.avatar!.isNotEmpty
                                        ? NetworkImage(AppConstants.BASE_URL + 'storage/' + controller.profile!.user!.avatar!)
                                        : null,
                                child: (controller.profile!.user!.avatar == null || controller.profile!.user!.avatar!.isEmpty)
                                    ? Text(
                                        controller.profile!.user!.name?.isNotEmpty == true
                                            ? controller.profile!.user!.name![0].toUpperCase()
                                            : '',
                                        style: const TextStyle(fontSize: 32, color: Colors.black),
                                      )
                                    : null,
                              ),

                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: (){},
                              child: CircleAvatar(
                                backgroundColor: AppColors.primaryRed,
                                radius: 18,
                                child: Icon(Icons.camera_alt, size: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Enter your name' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: const Icon(Icons.email),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Enter your email' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: const Icon(Icons.phone),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Enter your phone' : null,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedBloodType,
                          decoration: InputDecoration(
                            labelText: 'Blood Type',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: const Icon(Icons.bloodtype),
                          ),
                          items: bloodTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedBloodType = value;
                            });
                          },
                          validator: (value) => value == null || value.isEmpty ? 'Select blood type' : null,
                        ),
                        const SizedBox(height: 16),
                        TypeAheadField<Map<String, dynamic>>(
                          suggestionsCallback: (pattern) async {
                            return await Get.find<LocationController>().getPlaceSuggestions(pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion['description']),
                            );
                          },
                          onSelected: (suggestion) async {
                            await Get.find<LocationController>().selectPlace(suggestion['place_id']);
                            setState(() {
                              _selectedLocation = Get.find<LocationController>().selectedLocation.value; // or whatever property holds the location
                            });
                          },
                          builder: (context, controller, focusNode) {
                            controller.text = _selectedLocation?.address ??
                                Get.find<LocationController>().locationTextController.text;
                            controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: controller.text.length),
                            );
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                labelText: 'Location',
                                prefixIcon: Icon(Icons.location_on, color: AppColors.primaryRed),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColors.primaryRed),
                                ),
                              ),
                              onChanged: (value) {
                                Get.find<LocationController>().locationTextController.text = value;
                              },
                            );
                          },
                        ),
                        if (_selectedLocation != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _selectedLocation!.address ?? '',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                        const SizedBox(height: 32),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: AppColors.primaryRed,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.save),
                          label: const Text('Save Changes', style: TextStyle(fontSize: 16)),
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
