import 'package:bds/data/repository/request_repo.dart';
import 'package:get/get.dart';

import '../models/requests_model.dart';

class RequestController extends GetxController {
  final RequestRepo requestRepo;  

  RequestController({required this.requestRepo});

  List<dynamic> _requestList = [];
  List<dynamic> get requestList => _requestList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

 
  Future<void> getRequestsList() async {
    Response response = await requestRepo.getRequestsList(); 
    if (response.statusCode == 200) {
      print("Got Requests");
      _requestList = [];
      _requestList.addAll(Request.fromJson(response.body).requests ?? []);
      _isLoaded = true;
      update(); // Notify listeners about the change
    }
    else {
      print("Error fetching Requests: ${response.statusText}");
      // Handle error accordingly, maybe show a message to the user
    }
  }
}