import 'package:bds/controllers/donor_controller.dart';
import 'package:bds/controllers/event_controller.dart';
import 'package:bds/controllers/hospital_controller.dart';
import 'package:bds/controllers/my_request_controller.dart';
import 'package:bds/controllers/profile_controller.dart';
import 'package:bds/controllers/request_controller.dart';
import 'package:bds/routes/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'helper/dependencies.dart' as dep;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init();

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
