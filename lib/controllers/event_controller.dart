import 'dart:convert';
import 'package:flutter/material.dart';
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

  Future<void> enrollToEvent(int eventId) async {
  final response = await eventRepo.enrollToEvent(eventId);

  if (response.statusCode == 201 || response.statusCode == 200) {
    Get.snackbar(
      "Success",
       "You have been enrolled",
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
      duration: Duration(seconds: 10),
      margin: EdgeInsets.all(10),
      borderRadius: 8,
    );
  } else {
    Get.snackbar(
       "Error",
       response.body['message'] ?? "Could not enroll",
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
      duration: Duration(seconds: 10),
      margin: EdgeInsets.all(10),
      borderRadius: 8,
    );
  }
}

Future<void> unenrollFromEvent(int enrollmentId) async {
  final response = await eventRepo.unenrollFromEvent(enrollmentId);

  if (response.statusCode == 200 || response.statusCode == 201) {
    Get.snackbar(
      "Success",
      "You have been unenrolled",
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
      duration: Duration(seconds: 10),
      margin: EdgeInsets.all(10),
      borderRadius: 8,
    );
  } else {
    Get.snackbar(
      "Error",
      response.body['message'] ?? "Could not unenroll",
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
      duration: Duration(seconds: 10),
      margin: EdgeInsets.all(10),
      borderRadius: 8,
    );
  }
}


}
