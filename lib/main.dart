import 'package:bds/features/auth/login_screen.dart';
import 'package:bds/features/auth/register_screen.dart';
import 'package:bds/features/auth/welcome_screen.dart';
import 'package:bds/features/donor/all_requests_screen.dart';
import 'package:bds/features/donor/donation_history_screen.dart';
import 'package:bds/features/donor/donate_screen.dart';
import 'package:bds/features/donor/respond_to_request_screen.dart';
import 'package:bds/features/home/donation_centers.dart';
import 'package:bds/features/home/home_screen.dart';
import 'package:bds/features/home/notifications.dart';
import 'package:bds/features/profile/profile_screen.dart';
import 'package:bds/features/recipient/create_request_screen.dart';
import 'package:bds/features/recipient/find_donors.dart';
import 'package:bds/features/recipient/my_requests_screen.dart';
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
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/create-request': (context) => const CreateRequestScreen(),
        '/my-requests': (context) => const MyRequestsScreen(),
        '/view-requests': (context) => const AllRequestsScreen(),
        '/donation-history': (context) => const DonationHistoryScreen(),
        '/donate': (context) => const DonateScreen(),
        '/find': (context) => const FindDonors(),
        '/centers': (context) => const DonationCentersScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/respond': (context) => const RespondToRequestScreen(),

      },
    );
  }
}
