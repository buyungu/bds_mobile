import 'dart:convert';
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
    print("Event API status: ${response.statusCode}");
    print("Event API body: ${response.body}");

    _eventList = [];

    if (response.statusCode == 200) {
      try {
        final dynamic body = response.body;

        final data = body is String ? jsonDecode(body) : body;

        if (data is Map<String, dynamic>) {
          _eventList.addAll(Event.fromJson(data).events ?? []);
          _isLoaded = true;
        } else {
          print("Error: Decoded response is not a JSON object.");
        }
      } catch (e) {
        print("Event parsing error: $e");
      }
    } else {
      print("Error: Status code ${response.statusCode}. Possibly unauthorized or invalid response.");
    }

    update();
  }
}
