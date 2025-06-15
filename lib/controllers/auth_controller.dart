import 'package:bds/data/repository/auth_repo.dart';
import 'package:bds/models/register_boby_model.dart';
import 'package:bds/models/response_model.dart';
import 'package:bds/screens/home/home_screen.dart';
import 'package:bds/utils/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:bds/models/login_body_model.dart';
import 'package:bds/data/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController implements GetxService{
  final AuthRepo authRepo;
  AuthController({
    required this.authRepo
  });
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> login(LoginBody loginBody) async {
    _isLoading=true;
    Response response = await authRepo.login(loginBody);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      print('Login response: ${response.body}');
      final token = response.body["token"];
      if (token != null) {
        await authRepo.saveUserToken(token);
        Get.find<ApiClient>().updateHeader(token); // <-- Add this line
        print('Saved token: $token');
        // After saving token
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.TOKEN, token);
        Get.offAll(() => const HomeScreen());
        responseModel = ResponseModel(true, token);
      } else {
        print('No token found in response!');
        responseModel = ResponseModel(false, 'No token in response');
      }
    } else {
      print('Login failed: ${response.statusText}');
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading=false;
    update();
    return responseModel;
  }


  Future<ResponseModel> register(RegisterBody registerBody) async {
    _isLoading=true;
    print('Registering with body: ${registerBody.toJson()}');
    Response response = await authRepo.register(registerBody);
    late ResponseModel responseModel;
    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Register response: ${response.body}');
      final token = response.body["token"];
      if (token != null) {
        await authRepo.saveUserToken(token);
        Get.find<ApiClient>().updateHeader(token); // <-- Add this line
        print('Saved token: $token');
        // After saving token
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.TOKEN, token);
        Get.offAll(() => const HomeScreen());
        responseModel = ResponseModel(true, token);
      } else {
        print('No token found in response!');
        responseModel = ResponseModel(false, 'No token in response');
      }
    } else {
      print('Register failed: ${response.statusText}');
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading=false;
    update();
    return responseModel;
  }

  bool clearUserData(){
    return authRepo.clearUserData();
  }

  Future<void> updateToken() async {
    await authRepo.updateToken();
  }

}