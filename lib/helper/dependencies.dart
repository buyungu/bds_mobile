import 'package:bds/controllers/event_controller.dart';
import 'package:bds/data/api/api_client.dart';
import 'package:bds/data/repository/event_repo.dart';
import 'package:get/get.dart';

Future<void> init() async{
  // Api client
  Get.lazyPut(() => ApiClient(appBaseUrl: "http://10.0.2.2:8000/api", token: "your_token_here"));

  // Repos
  Get.lazyPut(()=>EventRepo(apiClient: Get.find()));

  // Controllers
  Get.lazyPut(()=>EventController(eventRepo: Get.find()));

}