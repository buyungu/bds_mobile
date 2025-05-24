import '../../data/models/user_model.dart';

class AuthController {
  static User? currentUser;

  static bool login(String email, String password) {
    // Fake login
    currentUser = User(
      id: '1',
      name: 'John Doe',
      bloodType: 'O+',
      location: 'Dar es Salaam',
      latitude: -6.7924,
      longitude: 39.2083,
    );
    return true;
  }


  static void logout() {
    currentUser = null;
  }

  static bool isLoggedIn() {
    return currentUser != null;
  }
}
