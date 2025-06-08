import 'package:bds/data/api/api_client.dart';
import 'package:bds/utils/app_constants.dart';
import 'package:get/get.dart';

class DonationRepo extends GetxService {
  final ApiClient apiClient;

  DonationRepo({ required this.apiClient});

  Future<Response> donate(int bloodRequestId) async {
    return await apiClient.postData(AppConstants.donateUrl(bloodRequestId), {});
}

}
