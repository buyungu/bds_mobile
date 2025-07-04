// lib/repositories/notification_repository.dart
import 'dart:convert';
import 'package:get/get.dart'; // Import GetX
import 'package:bds/models/notification_model.dart'; // Adjust path
import 'package:shared_preferences/shared_preferences.dart'; // To store/retrieve token

class NotificationRepository extends GetConnect {
  // Set your Laravel API base URL
  @override
  void onInit() {
    httpClient.baseUrl = 'http://10.0.2.2:8000/api'; // Change to your Laravel API URL
    // Add request interceptor to include the token
    httpClient.addRequestModifier<void>((request) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('api_token'); // Assuming you save the token here after login
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      return request;
    });

    // Optional: Add response interceptor for logging or error handling
    httpClient.addResponseModifier((request, response) {
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.bodyString}');
      return response;
    });
  }

  Future<List<NotificationItem>> fetchNotifications() async {
    final response = await get('/notifications');

    if (response.statusCode == 200) {
      // Laravel API Resource returns 'data' key for collections
      final List<dynamic> notificationJson = response.body['data'];
      return notificationJson.map((json) => NotificationItem.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      // Handle unauthenticated state, e.g., redirect to login
      throw Exception('Unauthorized to fetch notifications: ${response.statusText}');
    } else {
      throw Exception('Failed to load notifications: ${response.statusCode} - ${response.statusText}');
    }
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    final response = await post('/notifications/$notificationId/read', {});

    if (response.statusCode == 200) {
      print('Notification $notificationId marked as read.');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized to mark notification as read: ${response.statusText}');
    } else {
      throw Exception('Failed to mark notification as read: ${response.statusCode} - ${response.statusText}');
    }
  }
}