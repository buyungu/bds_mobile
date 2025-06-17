import 'package:bds/routes/route_helper.dart';
import 'package:get/get.dart';
import 'package:bds/data/repository/profile_repo.dart';
import 'package:bds/models/profile_model.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  final ProfileRepo profileRepo;

  ProfileController({required this.profileRepo});

  ProfileModel? _profile;
  ProfileModel? get profile => _profile;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getProfile() async {
    Response response = await profileRepo.getProfile();
    if (response.statusCode == 200) {
      _profile = ProfileModel.fromJson(response.body);
      _isLoaded = true;
      update();
    } else {
      print("Error fetching profile: ${response.statusText}");
      // Optionally handle error state here
    }
  }

  Future<void> editProfile(User user) async {
    _isLoading = true;
    update();
    print('Update profile with: ${user.toJson()}');
    Response response = await profileRepo.editProfile(user);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Edit Profile response: ${response.body}');
      // Optionally update _profile directly if response contains updated user
      await getProfile(); // Refresh profile after edit
    } else {
      print('Edit Profile failed: ${response.statusText}');
    }
    _isLoading = false;
    update();
  }

   Future<void> deleteUserAccount() async {
    _isLoading = true;
    Response response = await profileRepo.deleteUserAccount();
    if (response.statusCode == 200) {
      print('Delete account response: ${response.body}');
      Get.toNamed(RouteHelper.getInitial());
      Get.snackbar('Success', 'Account deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      print('Delete account failed: ${response.statusText}');
    }
  _isLoading = false;
  update();
}


}