import 'package:bds/controllers/auth_controller.dart';
import 'package:bds/controllers/donor_controller.dart';
import 'package:bds/controllers/event_controller.dart';
import 'package:bds/controllers/hospital_controller.dart';
import 'package:bds/controllers/my_request_controller.dart';
import 'package:bds/controllers/profile_controller.dart';
import 'package:bds/controllers/request_controller.dart';
import 'package:bds/data/api/api_client.dart';
import 'package:bds/data/repository/Donor_repo.dart';
import 'package:bds/data/repository/auth_repo.dart';
import 'package:bds/data/repository/event_repo.dart';
import 'package:bds/data/repository/hospital_repo.dart';
import 'package:bds/data/repository/my_request_repo.dart';
import 'package:bds/data/repository/profile_repo.dart';
import 'package:bds/data/repository/request_repo.dart';
import 'package:bds/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(sharedPreferences); // <-- This line is required!

  // Api client
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BASE_URL));

  // Repos
  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => ProfileRepo(apiClient: Get.find()));
  Get.lazyPut(() => EventRepo(apiClient: Get.find()));
  Get.lazyPut(() => DonorRepo(apiClient: Get.find()));
  Get.lazyPut(() => RequestRepo(apiClient: Get.find()));
  Get.lazyPut(() => MyRequestRepo(apiClient: Get.find()));
  Get.lazyPut(() => HospitalRepo(apiClient: Get.find()));

  // Controllers
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => ProfileController(profileRepo: Get.find()));
  Get.lazyPut(() => EventController(eventRepo: Get.find()));
  Get.lazyPut(() => DonorController(donorRepo: Get.find()));
  Get.lazyPut(() => RequestController(requestRepo: Get.find()));
  Get.lazyPut(() => MyRequestController(myRequestRepo: Get.find()));
  Get.lazyPut(() => HospitalController(hospitalRepo: Get.find()));}