import 'dart:convert'; // Add this at the top
import 'package:bds/data/repository/Donor_repo.dart';
import 'package:bds/models/donors_model.dart';
import 'package:get/get.dart';

class DonorController extends GetxController {
  final DonorRepo donorRepo;  

  DonorController({required this.donorRepo});

  List<dynamic> _donorList = [];
  List<dynamic> get donorList => _donorList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  String? selectedBloodGroup;
  String? selectedLocation;

  void setSelectedBloodGroup(String? bloodGroup) {
    selectedBloodGroup = bloodGroup;
    update(); // Notify listeners about the change
  }
  void setSelectedLocation(String? location) {
    selectedLocation = location;
    update(); // Notify listeners about the change
  }

 
  Future<void> getDonorsList() async {
    Response response = await donorRepo.getDonorsList(); 
    if (response.statusCode == 200) {
      print("Got Donors");
      _donorList = [];
      dynamic data = response.body;
      if (data is String) {
        if (data.trim().startsWith('<!DOCTYPE html>')) {
          print("Received HTML instead of JSON! Possible auth or endpoint error.");
          _isLoaded = true;
          update();
          return;
        }
        data = jsonDecode(data);
      }
      _donorList.addAll(Donor.fromJson(data).donors ?? []);
      _isLoaded = true;
      update(); // Notify listeners about the change
    } else {
      print("Error fetching Donors: ${response.statusText}");
      // Handle error accordingly, maybe show a message to the user
      _isLoaded = true;
      update();
    }
  }
}