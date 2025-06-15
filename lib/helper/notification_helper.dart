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
          final payload = response.payload;
          if (payload != null && payload.isNotEmpty) {
            final parts = payload.split('|');
            final type = parts[0];
            final id = parts[1];

            if (type == 'donation') {
              Get.toNamed(RouteHelper.getRespond(int.parse(id)));
            } else if (type == 'event') {
              Get.toNamed(RouteHelper.getEventDetails(int.parse(id)));
            } else {
              Get.toNamed(RouteHelper.getNotifications());
            }
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
      print('📲 App opened via notification, data: ${message.data}');

      final type = message.data['type'];
      final id = message.data['blood_request_id'] ?? message.data['event_id'];

      if (type == 'donation') {
        Get.toNamed(RouteHelper.getRespond(id));
      } else if (type == 'event') {
        Get.toNamed(RouteHelper.getEventDetails(id));
      } else {
        Get.toNamed(RouteHelper.getNotifications());
      }
    });

  }

  static Future<void> showNotification(RemoteMessage msg, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      msg.notification!.body!, htmlFormatBigText: true,
      contentTitle: msg.notification!.title!, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'channel_id_4', 'bds', importance: Importance.high,
      styleInformation: bigTextStyleInformation, priority: Priority.high,
      playSound: true,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidNotificationDetails,
      iOS: const DarwinNotificationDetails(),
    );
    print('🚀 Showing notification with payload: ${msg.data}');
    await fln.show(0, msg.notification!.title!, msg.notification!.body!, platformChannelSpecifics,   payload: '${msg.data['type']}|${msg.data['blood_request_id'] ?? msg.data['event_id']}',);
  }
}
