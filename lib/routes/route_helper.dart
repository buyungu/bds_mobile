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

class RouteHelper {
  static const String initial = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const String welcome = "/welcome";
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
  static String getWelcome() => '$welcome';
  static String getProfile() => '$profile';
  static String getEditProfile() => '$editProfile';
  static String getCreateRequest() => '$createRequest';
  static String getMyRequests() => '$myRequests';
  static String getViewRequests() => '$viewRequests';
  static String getDonationHistory() => '$donationHistory';
  static String getFind() => '$find';
  static String getCenters() => '$centers';
  static String getNotifications() => '$notifications';
  static String getRespond() => '$respond';
  static String getDonationProgress() => '$donationProgress';
  static String getEvents() => '$events';
  static String getEventDetails(int pageId) => '$eventDetails?pageId=$pageId';

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => HomeScreen()),
    GetPage(name: welcome, page: () => const WelcomeScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: register, page: () => const RegisterScreen()),
    GetPage(name: profile, page: () => ProfileScreen()),
    GetPage(name: editProfile, page: () => EditProfileScreen()),
    GetPage(name: createRequest, page: () => const CreateRequestScreen()),
    GetPage(name: myRequests, page: () => const MyRequestsScreen()),
    GetPage(name: viewRequests, page: () => const AllRequestsScreen()),
    GetPage(name: donationHistory, page: () => const DonationHistoryScreen()),
    GetPage(name: find, page: () => const FindDonors()),
    GetPage(name: centers, page: () => const DonationCentersScreen()),
    GetPage(name: notifications, page: () => const NotificationsScreen()),
    GetPage(name: respond, page: () => const RespondToRequestScreen()),
    GetPage(name: donationProgress, page: () => DonationProgressScreen()),
    GetPage(name: events, page: () => EventsScreen()),
    GetPage(
      name: eventDetails,
      page: () {
        var pageId = Get.parameters['pageId'];
        return EventDetailsScreen(pageId: int.parse(pageId!));
      },
      transition: Transition.fadeIn,
    ),
  ];
}