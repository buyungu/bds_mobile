import 'package:bds/routes/route_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationHelper {
  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);   
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings, 
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        try {
          final String? payload = response.payload;
          if (payload != null && payload.isNotEmpty) {
            // Navigate to specific screen using payload
            Get.toNamed(payload);
          } else {
            Get.toNamed(RouteHelper.getNotifications());
          }
        } catch (e) {
          if (kDebugMode) {
            print("Notification tapped error: $e");
          }
        }
      },
    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Firebase message received: ${message.notification?.title}/${message.notification?.body}");
      showNotification(message, flutterLocalNotificationsPlugin);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Firebase message tapped: ${message.notification?.title}/${message.notification?.body}");
      try {
        Get.toNamed(RouteHelper.getNotifications());
      } catch (e) {
        print("Error handling opened message: $e"); 
      }
    }); 
  }

  static Future<void> showNotification(RemoteMessage msg, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      msg.notification!.body!, htmlFormatBigText: true,
      contentTitle: msg.notification!.title!, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'channel_id_2', 'bds', importance: Importance.high,
      styleInformation: bigTextStyleInformation, priority: Priority.high,
      playSound: true,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidNotificationDetails,
      iOS: const DarwinNotificationDetails(),
    );
    await fln.show(0, msg.notification!.title!, msg.notification!.body!, platformChannelSpecifics);
  }
}
