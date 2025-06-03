import 'package:bds/data/api/api_client.dart';
import 'package:bds/utils/app_constants.dart';
import 'package:get/get.dart';

class RequestRepo extends GetxService {
  final ApiClient apiClient;

  RequestRepo({required this.apiClient});

  Future<Response> getRequestsList() async {
    return await apiClient.getData(AppConstants.REQUEST_URL);
  }
}