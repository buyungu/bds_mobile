import 'dart:convert';
import 'package:bds/data/repository/notification_repo.dart';
import 'package:get/get.dart'; // Still need GetX for GetxController and update()
import 'package:bds/models/notification_model.dart'; // Import your NotificationItem model
import 'package:flutter/material.dart'; // For Get.snackbar colors

class NotificationController extends GetxController {
  final NotificationRepo notificationRepo;
  NotificationController({required this.notificationRepo});

  // Non-reactive variables
  List<NotificationItem> _notificationList = []; // Changed from dynamic to NotificationItem
  List<NotificationItem> get notificationList => _notificationList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  String? _errorMessage; // Added for error messages to UI
  String? get errorMessage => _errorMessage;

  @override
  void onInit() {
    super.onInit();
    // Load notifications when the controller is initialized
    getNotificationList();
  }

  Future<void> getNotificationList() async {
    _isLoaded = false; // Set loading state
    _errorMessage = null; // Clear previous error
    _notificationList = []; // Clear existing list

    Response response = await notificationRepo.getNotification();
    print("Notification API status: ${response.statusCode}");
    print("Notification API body: ${response.bodyString}"); // Use bodyString for raw body

    if (response.statusCode == 200) {
      try {
        final dynamic body = response.body;
        final data = body is String ? jsonDecode(body) : body;

        if (data is Map<String, dynamic> && data.containsKey('data')) {
          final List<dynamic> rawNotifications = data['data'];
          // Convert dynamic items to NotificationItem objects
          _notificationList.addAll(
              rawNotifications.map((item) => NotificationItem.fromJson(item as Map<String, dynamic>)).toList());
          _isLoaded = true;
        } else {
          _errorMessage = "Error: Decoded response is not a JSON object or missing 'data' key.";
          print(_errorMessage);
        }
      } catch (e) {
        _errorMessage = "Notification parsing error: $e";
        print(_errorMessage);
      }
    } else {
      _errorMessage = "Error: Status code ${response.statusCode}. Possibly unauthorized or invalid response.";
      print(_errorMessage);
    }
    update(); // Notify GetBuilder listeners to rebuild
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      final response = await notificationRepo.markNotificationAsRead(notificationId);

      if (response.statusCode == 200) {
        // Find the index of the notification to update
        final index = _notificationList.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          // Update the status of the item in the list
          _notificationList[index] = _notificationList[index].copyWith(status: 'read');
        }
        Get.snackbar(
          'Success',
          'Notification marked as read.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        String errorMsg = 'Failed to mark notification as read: Status ${response.statusCode}';
        if (response.bodyString != null && response.bodyString!.isNotEmpty) {
          try {
            final errorBody = jsonDecode(response.bodyString!);
            errorMsg = errorBody['message'] ?? errorMsg;
          } catch (_) {
            // Not a JSON error body
          }
        }
        throw Exception(errorMsg);
      }
    } catch (e) {
      _errorMessage = e.toString(); // Set error message if markAsRead fails
      print('Error marking notification as read: $_errorMessage');
      Get.snackbar(
        'Error',
        'Failed to mark notification as read: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      update(); // Ensure UI updates after read attempt (for button state/status)
    }
  }

  
}




// // lib/controllers/notification_controller.dart
// import 'package:bds/data/repository/notification_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart'; // Import GetX
// import 'package:bds/models/notification_model.dart'; // Adjust path

// class NotificationController extends GetxController {
//   // Get.find() will locate the repository instance that was put into GetX
//   final NotificationRepository _repository = Get.find<NotificationRepository>();

//   // Rx variables for reactive state
//   final RxList<NotificationItem> _notifications = <NotificationItem>[].obs;
//   final RxBool _isLoading = false.obs;
//   final RxString _errorMessage = RxString(''); // Use RxString for nullable string

//   // Getters for UI access
//   List<NotificationItem> get notifications => _notifications.value;
//   bool get isLoading => _isLoading.value;
//   String? get errorMessage => _errorMessage.value.isEmpty ? null : _errorMessage.value;

//   @override
//   void onInit() {
//     super.onInit();
//     loadNotifications(); // Load notifications when the controller is initialized
//   }

//   Future<void> loadNotifications() async {
//     _isLoading.value = true;
//     _errorMessage.value = ''; // Clear previous errors
//     try {
//       final fetchedNotifications = await _repository.fetchNotifications();
//       _notifications.assignAll(fetchedNotifications); // Assign all new notifications
//     } catch (e) {
//       _errorMessage.value = e.toString();
//       print('Error in NotificationController: $_errorMessage');
//     } finally {
//       _isLoading.value = false;
//     }
//   }

//   Future<void> markAsRead(int notificationId) async {
//     try {
//       await _repository.markNotificationAsRead(notificationId);
//       // Update the status in the local list reactively
//       final index = _notifications.indexWhere((n) => n.id == notificationId);
//       if (index != -1) {
//         _notifications[index] = NotificationItem(
//           id: _notifications[index].id,
//           title: _notifications[index].title,
//           message: _notifications[index].message,
//           time: _notifications[index].time,
//           type: _notifications[index].type,
//           important: _notifications[index].important,
//           status: 'read', // Explicitly set to 'read'
//           errorMessage: _notifications[index].errorMessage,
//           userId: _notifications[index].userId,
//         );
//         _notifications.refresh(); // Notify listeners of the change within the list item
//       }
//     } catch (e) {
//       _errorMessage.value = e.toString();
//       print('Error marking notification as read: $_errorMessage');
//       // You might want to show a SnackBar or AlertDialog for the user here
//       Get.snackbar(
//         'Error',
//         'Failed to mark notification as read: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
// }