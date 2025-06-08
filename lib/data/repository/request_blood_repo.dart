import 'package:bds/data/api/api_client.dart';
import 'package:bds/models/request_blood_model.dart';
import 'package:bds/utils/app_constants.dart';
import 'package:get/get.dart';

class RequestBloodRepo {
  final ApiClient apiClient;

  RequestBloodRepo({
    required this.apiClient,
  });

  Future<Response> requestBlood(RequestBloodModel requestBloodModel) async {
    return await apiClient.postData(AppConstants.REQUEST_BLOOD_URL, requestBloodModel.toJson());
  }
}