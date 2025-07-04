import 'package:bds/screens/auth/login_screen.dart';
import 'package:bds/screens/auth/register_screen.dart';
import 'package:bds/screens/auth/welcome_screen.dart';
import 'package:bds/screens/home/all_requests_screen.dart';
import 'package:bds/screens/home/create_request_screen.dart';
import 'package:bds/screens/home/donation_centers_screen.dart';
import 'package:bds/screens/home/donation_history_screen.dart';
import 'package:bds/screens/home/donation_progress_screen.dart';
import 'package:bds/screens/home/find_donors_screen.dart';
import 'package:bds/screens/home/home_screen.dart';
import 'package:bds/screens/home/my_requests_screen.dart';
import 'package:bds/screens/home/notifications.dart';
import 'package:bds/screens/home/respond_to_request_screen.dart';
import 'package:bds/screens/profile/profile_screen.dart';
import 'package:bds/screens/profile/edit_profile_screen.dart';
import 'package:bds/screens/events/events_screen.dart';
import 'package:bds/screens/events/event_details_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Import Material for SnackBar and Center

class RouteHelper {
  static const String initial = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const String home = "/home";
  static const String profile = "/profile";
  static const String editProfile = "/edit-profile";
  static const String createRequest = "/create-request";
  static const String myRequests = "/my-requests";
  static const String viewRequests = "/view-requests";
  static const String donationHistory = "/donation-history";
  static const String find = "/find";
  static const String centers = "/centers";
  static const String notifications = "/notifications";
  static const String respond = "/respond";
  static const String donationProgress = "/donation-progress";
  static const String events = "/events";
  static const String eventDetails = "/event-details";

  static String getInitial() => '$initial';
  static String getLogin() => '$login';
  static String getRegister() => '$register';
  static String getHome() => '$home';
  static String getProfile() => '$profile';
  static String getEditProfile() => '$editProfile';
  static String getCreateRequest() => '$createRequest';
  static String getMyRequests() => '$myRequests';
  static String getViewRequests() => '$viewRequests';
  static String getDonationHistory() => '$donationHistory';
  static String getFind() => '$find';
  static String getCenters() => '$centers';
  static String getNotifications() => '$notifications';
  static String getRespond(int pageId) => '$respond?pageId=$pageId';
  static String getDonationProgress(int requestId) => '$donationProgress?id=$requestId';
  static String getEvents() => '$events';
  // It's recommended to change 'pageId' to 'eventId' here for consistency with EventDetailsScreen
  static String getEventDetails(int eventId) => '$eventDetails?eventId=$eventId';

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => WelcomeScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: register, page: () => RegisterScreen()),
    GetPage(name: profile, page: () => ProfileScreen()),
    GetPage(name: editProfile, page: () => EditProfileScreen()),
    GetPage(name: createRequest, page: () => const CreateRequestScreen()),
    GetPage(name: myRequests, page: () => const MyRequestsScreen()),
    GetPage(name: viewRequests, page: () => const AllRequestsScreen()),
    GetPage(name: donationHistory, page: () => const DonationHistoryScreen()),
    GetPage(name: find, page: () => const FindDonors()),
    GetPage(name: centers, page: () => const DonationCentersScreen()),
    GetPage(name: notifications, page: () => const NotificationsScreen()),
    GetPage(
      name: respond,
      page: () {
        // This 'pageId' parameter in 'respond' route still exists as per your original code.
        // If 'RespondToRequestScreen' expects a 'requestId', you should change the parameter name in the URL and the screen.
        var pageId = Get.parameters['pageId'];
        return RespondToRequestScreen(); // Assuming RespondToRequestScreen handles null pageId or fetches data differently
      },
      transition: Transition.fadeIn,
    ),
    GetPage(name: donationProgress, page: () => DonationProgressScreen()),
    GetPage(name: events, page: () => EventsScreen()),

    // FIX START: EventDetails GetPage definition
    GetPage(
      name: eventDetails,
      page: () {
        // Correctly retrieve 'eventId' from Get.parameters, as specified by getEventDetails.
        var eventIdString = Get.parameters['eventId'];

        // Handle the case where 'eventId' might be missing or not a valid integer.
        if (eventIdString != null) {
          final int? eventId = int.tryParse(eventIdString);
          if (eventId != null) {
            return EventDetailsScreen(eventId: eventId);
          } else {
            // Handle invalid eventId format
            Get.snackbar(
              'Error',
              'Invalid Event ID format.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            return const Center(child: Text('Error: Invalid Event ID.')); // Fallback
          }
        } else {
          // Handle missing eventId
          Get.snackbar(
            'Error',
            'Event ID is missing!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return const Center(child: Text('Error: Event ID not provided.')); // Fallback
        }
      },
      transition: Transition.fadeIn,
    ),
    // FIX END: EventDetails GetPage definition
  ];
}