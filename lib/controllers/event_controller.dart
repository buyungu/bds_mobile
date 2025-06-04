import 'dart:convert'; // Add this import
import 'package:bds/data/repository/event_repo.dart';
import 'package:bds/models/events_model.dart';
import 'package:get/get.dart';

class EventController extends GetxController {
  final EventRepo eventRepo;  

  EventController({required this.eventRepo});

  List<dynamic> _eventList = [];
  List<dynamic> get eventList => _eventList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

 
  Future<void> getEventsList() async {
    Response response = await eventRepo.getEventsList(); 
    if (response.statusCode == 200) {
      print("Got Events");
      _eventList = [];
      final data = jsonDecode(response.body); // Decode the JSON string
      _eventList.addAll(Event.fromJson(data).events);
      _isLoaded = true;
      update(); // Notify listeners about the change
    }
    else {
      print("Error fetching events: ${response.statusText}");
      // Handle error accordingly, maybe show a message to the user
    }
  }
}