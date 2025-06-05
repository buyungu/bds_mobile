import 'package:bds/models/hospitals_model.dart';
import 'package:get/get.dart';
import 'package:bds/data/repository/hospital_repo.dart';

class HospitalController extends GetxController {
  final HospitalRepo hospitalRepo;

  HospitalController({required this.hospitalRepo});

  List<HospitalModel> _hospitalList = [];
  List<HospitalModel> get hospitalList => _hospitalList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> getHospitals() async {
    Response response = await hospitalRepo.getHospitals();
    print("Hospital API status: ${response.statusCode}");
    print("Hospital API body: ${response.body}");
    if (response.statusCode == 200) {
      _hospitalList = [];
      final data = HospitalsResponse.fromJson(response.body).hospitals;
      print("Parsed hospitals: $data");
      _hospitalList.addAll(data);
      _isLoaded = true;
      update();
    } else {
      print("Error fetching hospitals: ${response.statusText}");
    }
  }
}