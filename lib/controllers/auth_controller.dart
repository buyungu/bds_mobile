import 'package:bds/data/repository/auth_repo.dart';
import 'package:bds/models/response_model.dart';
import 'package:get/get.dart';
import 'package:bds/models/login_body_model.dart';
import 'package:bds/data/api/api_client.dart';

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

  // bool isLoggedIn = false;

  // // Example login method
  // Future<bool> login(LoginBody loginBody) async {
  //   isLoading.value = true;
  //   try {
  //     // TODO: Replace with your API call
  //     await Future.delayed(const Duration(seconds: 2));
  //     // Simulate login success if email and password are not empty
  //     if (loginBody.email.isNotEmpty && loginBody.password.isNotEmpty) {
  //       isLoggedIn.value = true;
  //       return true;
  //     } else {
  //       isLoggedIn.value = false;
  //       return false;
  //     }
  //   } catch (e) {
  //     isLoggedIn.value = false;
  //     return false;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // void logout() {
  //   isLoggedIn.value = false;
  //   // TODO: Add any additional logout logic here
  // }
}