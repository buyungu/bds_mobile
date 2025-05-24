import 'package:flutter/material.dart';
import '../../core/widgets/hero_section.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeroSection(
              title: 'My Profile',
              subtitle: 'View and manage your profile information',
            ),
            const SizedBox(height: 24),
            _ProfileItem(label: 'Name', value: 'John Doe'),
            _ProfileItem(label: 'Email', value: 'john@example.com'),
            _ProfileItem(label: 'Blood Type', value: 'A+'),
            _ProfileItem(label: 'Location', value: 'Dar es Salaam'),
            const SizedBox(height: 24),
            CustomButton(
              label: 'Edit Profile',
              onPressed: () {
                Navigator.pushNamed(context, '/profile/edit');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body),
          Text(value, style: AppTextStyles.subheading),
        ],
      ),
    );
  }
}
