import 'dart:convert';
import 'package:bds/data/api/api_client.dart'; // Assuming you have an ApiClient
import 'package:bds/utils/app_constants.dart'; // Assuming you have AppConstants
import 'package:get/get.dart';

class NotificationRepo extends GetxService {
  final ApiClient apiClient;

  NotificationRepo({required this.apiClient});

  Future<Response> getNotification() async {
    return await apiClient.getData(AppConstants.NOTIFICATION_URL);
  }

  // CORRECTED: Make an actual API call to mark the notification as read
  Future<Response> markNotificationAsRead(int notificationId) async {
    return await apiClient.postData(AppConstants.markAsRead(notificationId), {},);
  }
}