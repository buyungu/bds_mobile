import 'package:get/get.dart';
import 'package:bds/data/repository/profile_repo.dart';
import 'package:bds/models/profile_model.dart';

class ProfileController extends GetxController {
  final ProfileRepo profileRepo;

  ProfileController({required this.profileRepo});

  ProfileModel? _profile;
  ProfileModel? get profile => _profile;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

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
}