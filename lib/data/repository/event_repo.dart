import 'package:bds/data/api/api_client.dart';
import 'package:bds/utils/app_constants.dart';
import 'package:get/get.dart';

class EventRepo extends GetxService {
  final ApiClient apiClient;

  EventRepo({required this.apiClient});

  Future<Response> getEventsList() async {
    return await apiClient.getData(AppConstants.EVENT_URL);
  }

  Future<Response> enrollToEvent(int eventId) async {
    return await apiClient.postData(AppConstants.enrollUrl(eventId), {});
  }

  Future<Response> unenrollFromEvent(int enrollmentId) async {
    return await apiClient.deleteData(AppConstants.unenrollUrl(enrollmentId));
  }
}