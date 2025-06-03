import 'package:bds/controllers/donor_controller.dart';
import 'package:bds/controllers/event_controller.dart';
import 'package:bds/controllers/request_controller.dart';
import 'package:bds/data/api/api_client.dart';
import 'package:bds/data/repository/Donor_repo.dart';
import 'package:bds/data/repository/event_repo.dart';
import 'package:bds/data/repository/request_repo.dart';
import 'package:bds/utils/app_constants.dart';
import 'package:get/get.dart';

Future<void> init() async{
  // Api client
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BASE_URL));

  // Repos
  Get.lazyPut(()=>EventRepo(apiClient: Get.find()));
  Get.lazyPut(()=>DonorRepo(apiClient: Get.find()));
  Get.lazyPut(()=>RequestRepo(apiClient: Get.find()));

  // Controllers
  Get.lazyPut(()=>EventController(eventRepo: Get.find()));
  Get.lazyPut(()=>DonorController(donorRepo: Get.find()));
  Get.lazyPut(()=>RequestController(requestRepo: Get.find()));

}