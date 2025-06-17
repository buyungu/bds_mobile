import 'package:bds/data/api/api_client.dart';
import 'package:bds/models/profile_model.dart';
import 'package:bds/utils/app_constants.dart';
import 'package:get/get.dart';

class ProfileRepo extends GetConnect implements GetxService {
  final ApiClient apiClient;

  ProfileRepo({required this.apiClient});

  Future<Response> getProfile() async {
    return await apiClient.getData(AppConstants.USER_URL);
  }

  Future<Response> editProfile(User user) async {
    return  await apiClient.putData(AppConstants.EDIT_USER_URL, user.toJson());
  }

    Future<Response> deleteUserAccount() async {
    return await apiClient.deleteData(AppConstants.DELETE_USER_URL);
  }
}