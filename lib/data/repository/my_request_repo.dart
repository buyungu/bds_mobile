import 'package:bds/data/api/api_client.dart';
import 'package:bds/utils/app_constants.dart';
import 'package:get/get.dart';

class MyRequestRepo extends GetxService {
  final ApiClient apiClient;

  MyRequestRepo({required this.apiClient});

  Future<Response> getMyRequestsList() async {
    return await apiClient.getData(AppConstants.MY_REQUEST_URL);
  }
}