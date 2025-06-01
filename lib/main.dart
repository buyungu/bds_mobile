import 'package:bds/screens/auth/login_screen.dart';
import 'package:bds/screens/auth/register_screen.dart';
import 'package:bds/screens/auth/welcome_screen.dart';
import 'package:bds/screens/events/events_screen.dart';
import 'package:bds/screens/home/all_requests_screen.dart';
import 'package:bds/screens/home/donation_history_screen.dart';
import 'package:bds/screens/home/donation_progress_screen.dart';
import 'package:bds/screens/home/home_screen.dart';
import 'package:bds/screens/home/respond_to_request_screen.dart';
import 'package:bds/screens/home/donation_centers_screen.dart';
import 'package:bds/screens/home/notifications.dart';
import 'package:bds/screens/profile/edit_profile_screen.dart';
import 'package:bds/screens/profile/profile_screen.dart';
import 'package:bds/screens/home/create_request_screen.dart';
import 'package:bds/screens/home/find_donors_screen.dart';
import 'package:bds/screens/home/my_requests_screen.dart';
import 'package:bds/screens/events/event_details_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const BloodDonationApp());
}

class BloodDonationApp extends StatelessWidget {
  const BloodDonationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blood Donation App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/edit-profile': (context) => EditProfileScreen(),
        '/create-request': (context) => const CreateRequestScreen(),
        '/my-requests': (context) => const MyRequestsScreen(),
        '/view-requests': (context) => const AllRequestsScreen(),
        '/donation-history': (context) => const DonationHistoryScreen(),
        '/find': (context) => const FindDonors(),
        '/centers': (context) => const DonationCentersScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/respond': (context) => const RespondToRequestScreen(),
        '/donation-progress': (context) => DonationProgressScreen(),
        '/events': (context) => EventsScreen(),
        '/event-details': (context) => EventDetailsScreen(),


      },
    );
  }
}
