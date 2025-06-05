import 'package:bds/data/api/api_client.dart';
import 'package:bds/utils/app_constants.dart';
import 'package:get/get.dart';

class HospitalRepo extends GetConnect implements GetxService {
  final ApiClient apiClient;

  HospitalRepo({required this.apiClient});

  Future<Response> getHospitals() async {
    return await apiClient.getData(AppConstants.HOSPITAL_URL);
  }
}