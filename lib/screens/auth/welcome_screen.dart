import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';



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
            Text(
              'Save Lives',
              style: AppTextStyles.heroTitle.copyWith(
                fontSize: 36,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Donate Blood, Share Love',
              style: AppTextStyles.heroSubtitle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700
              ),
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
