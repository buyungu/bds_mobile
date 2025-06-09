import 'package:bds/data/api/api_client.dart';
import 'package:bds/models/login_body_model.dart';
import 'package:bds/models/register_boby_model.dart';
import 'package:bds/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> register(RegisterBoby registerBody) async {
    return await apiClient.postData(AppConstants.REGISTER_URL, registerBody.toJson());
  }
  Future<Response> login(LoginBody loginBody) async {
    return await apiClient.postData(AppConstants.LOGIN_URL, loginBody.toJson());
  }

  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  String? getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN);
  }

  bool clearUserData() {
    sharedPreferences.remove(AppConstants.TOKEN);
    apiClient.token = '';
    apiClient.updateHeader('');
    return true;
  }
}