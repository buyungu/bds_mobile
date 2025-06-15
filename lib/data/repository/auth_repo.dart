import 'package:bds/data/api/api_client.dart';
import 'package:bds/models/login_body_model.dart';
import 'package:bds/models/register_boby_model.dart';
import 'package:bds/utils/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> register(RegisterBody registerBody) async {
    // Ensure location is serialized using the shared Location model's toJson()
    final data = registerBody.toJson();
    if (registerBody.location != null) {
      data['location'] = registerBody.location!.toJson();
    }
    return await apiClient.postData(AppConstants.REGISTER_URL, data);
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

  Future<Response> updateToken() async {
    String? _deviceToken;
    if (GetPlatform.isIOS && !GetPlatform.isWeb) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true, announcement: false, badge: true,carPlay: false,
        criticalAlert: false, provisional: false, sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        _deviceToken = await _saveDeviceToken();
        print("My token is 1 ${_deviceToken ?? 'null'} ");
      }
    } else {
      _deviceToken = await _saveDeviceToken();
      print("My token is 2 ${_deviceToken ?? 'null'}");
    }
    if (!GetPlatform.isWeb) {
      // FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
    }
  return await apiClient.putData(AppConstants.TOKEN_URL, {"fcm_token": _deviceToken});
  }

  Future<String?> _saveDeviceToken() async {
    String? _deviceToken = '';  
    if (!GetPlatform.isWeb) {
      try {
        FirebaseMessaging.instance.requestPermission();
        _deviceToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        print("Could not get the token");
        print(e.toString());
      }
    }
    if (_deviceToken != null) {
      print("--------------Device Token-------------- ${_deviceToken}");
    }
    return _deviceToken;
  }

}