import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/custom_button.dart';



class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryRed, AppColors.secondaryRed],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              'Save Lives',
              style: AppTextStyles.heading,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Donate Blood, Share Love',
              style: AppTextStyles.subheading,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register'); // Navigate to Register
                },
                child: const Text(
                  "Get Started",
                  style: AppTextStyles.action,
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login'); // Navigate to Login
              },
              child: const Text(
                "Already have an account? Sign In",
                style: TextStyle(color: AppColors.white),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
