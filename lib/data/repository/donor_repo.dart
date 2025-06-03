import 'package:bds/data/api/api_client.dart';
import 'package:bds/utils/app_constants.dart';
import 'package:get/get.dart';

class DonorRepo extends GetxService {
  final ApiClient apiClient;

  DonorRepo({required this.apiClient});

  Future<Response> getDonorsList() async {
    return await apiClient.getData(AppConstants.DONOR_URL);
  }
}