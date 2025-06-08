import 'package:bds/data/repository/request_blood_repo.dart';
import 'package:bds/models/request_blood_model.dart';
import 'package:get/get.dart';

class RequestBloodController extends GetxController implements GetxService {
  final RequestBloodRepo requestBloodRepo;

  RequestBloodController({
    required this.requestBloodRepo
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future <bool> requestBlood(RequestBloodModel requestBloodModel) async {
    _isLoading = true;
    Response response = await requestBloodRepo.requestBlood(requestBloodModel);
    _isLoading = false;
    update();
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Blood Request success: ${response.body}');
      return true;
    } else {
      print('Blood Request failed: ${response.statusText}');
      return false;
    }
    
  }
}