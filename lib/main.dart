import 'package:bds/controllers/donation_controller.dart';
import 'package:bds/controllers/donor_controller.dart';
import 'package:bds/controllers/event_controller.dart';
import 'package:bds/controllers/hospital_controller.dart';
import 'package:bds/controllers/location_controller.dart';
import 'package:bds/controllers/my_request_controller.dart';
import 'package:bds/controllers/notification_controller.dart';
import 'package:bds/controllers/profile_controller.dart';
import 'package:bds/controllers/request_blood_controller.dart';
import 'package:bds/controllers/request_controller.dart';
import 'package:bds/helper/notification_helper.dart';
import 'package:bds/routes/route_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'helper/dependencies.dart' as dep;

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async{
  print("onBackground: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dep.init();

  try {
    if (GetPlatform.isMobile) {
      final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
  // Register your controller permanently
  Get.put(
    ProfileController(profileRepo: Get.find()), 
    permanent: true,
  );
  Get.put(
    RequestController(requestRepo: Get.find()), // Ensure requestRepo is registered in your dependencies
    permanent: true,
  );
  Get.put(
    MyRequestController(myRequestRepo: Get.find()), // Ensure requestRepo is registered in your dependencies
    permanent: true,
  );
  Get.put(
    DonorController(donorRepo: Get.find()),
    permanent: true,
  );
  Get.put(
    EventController(eventRepo: Get.find()),
    permanent: true,
  );
  Get.put(
    HospitalController(hospitalRepo: Get.find()),
    permanent: true,
  );
  Get.put(
    DonationController(donationRepo: Get.find()),
    permanent: true,
  );
  Get.put(
    RequestBloodController(requestBloodRepo: Get.find()),
    permanent: true,
  );
  Get.put(LocationController());
  Get.put(
    NotificationController(notificationRepo: Get.find()), // Pass the required notificationRepo
    permanent: true,
  );


  runApp(const BloodDonationApp());
}

class BloodDonationApp extends StatelessWidget {
  const BloodDonationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blood Donation App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Roboto',
      ),
      initialRoute: RouteHelper.initial,

      getPages: RouteHelper.routes,
      
    );
  }
}
