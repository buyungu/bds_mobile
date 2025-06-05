import 'dart:convert'; // Add this import
import 'package:bds/data/repository/event_repo.dart';
import 'package:bds/models/events_model.dart';
import 'package:get/get.dart';

class EventController extends GetxController {
  final EventRepo eventRepo;  

  EventController({required this.eventRepo});

  @override
  void onInit() {
    super.onInit();
    getEventsList();
  }

  List<dynamic> _eventList = [];
  List<dynamic> get eventList => _eventList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

 
  Future<void> getEventsList() async {
    Response response = await eventRepo.getEventsList();
    print("Event API status: ${response.statusCode}");
    print("Event API body: ${response.body}");

    _eventList = [];
    _isLoaded = true;

    // Check if the response is a Map (JSON) or a String (HTML/error)
    if (response.statusCode == 200 && response.body is Map) {
      try {
        _eventList.addAll(Event.fromJson(response.body).events ?? []);
      } catch (e) {
        print("Event parsing error: $e");
      }
    } else {
      print("Error: Expected JSON but got something else (maybe HTML). Check your API endpoint and backend.");
    }
    update();
  }
}