import 'package:bds/data/api/api_client.dart';
import 'package:get/get.dart';

class EventRepo extends GetxService {
  final ApiClient apiClient;

  EventRepo({required this.apiClient});

  Future<Response> getEventsList() async {
    return await apiClient.getData('/events');
  }
}