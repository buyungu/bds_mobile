class AppConstants {
  // App-wide constants
  static const String appName = "Blood Donation App";

  // Shared Preferences keys
  static const String userTokenKey = "USER_TOKEN";
  static const String userIdKey = "USER_ID";

  // Blood Types
  static const List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  // API Endpoints (optional usage)
  static const String baseUrl = "http://your-laravel-backend.test/api"; // Example
}
