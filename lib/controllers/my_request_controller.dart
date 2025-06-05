import 'package:bds/data/repository/my_request_repo.dart';
import 'package:bds/models/my_request_model.dart';
import 'package:get/get.dart';


class MyRequestController extends GetxController {
  final MyRequestRepo myRequestRepo;  

  MyRequestController({required this.myRequestRepo});

  List<dynamic> _myRequestList = [];
  List<dynamic> get myRequestList => _myRequestList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> getMyRequestsList() async {
    Response response = await myRequestRepo.getMyRequestsList(); // FIXED
    if (response.statusCode == 200) {
      print("Got Requests");
      _myRequestList = [];
      _myRequestList.addAll(MyRequest.fromJson(response.body).myRequests ?? []);
      _isLoaded = true;
      update(); // Notify listeners about the change
    }
    else {
      print("Error fetching Requests: ${response.statusText}");
      // Handle error accordingly, maybe show a message to the user
    }
  }
}