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
    if (response.statusCode == 200) {
      _eventList = [];
      try {
        final data = response.body; // <-- FIXED: no jsonDecode
        _eventList.addAll(Event.fromJson(data).events ?? []);
        _isLoaded = true;
      } catch (e) {
        print("Event parsing error: $e");
        _isLoaded = true;
      }
      update();
    } else {
      print("Error fetching events: ${response.statusText}");
      _isLoaded = true;
      update();
    }
  }
}