import 'package:flutter/material.dart';
import '../../core/widgets/hero_section.dart';
// import '../../core/widgets/loading_indicator.dart';
// import '../../core/widgets/custom_button.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers:  [
            HeroSection(
              title: 'Welcome Back!',
              subtitle: 'Your donation journey starts here',
            ),

            SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 24),
                    // DashboardOverview(),
                    // SizedBox(height: 16),
                    // UpcomingEvents(),
                    // SizedBox(height: 16),
                    // ActiveRequests(),
                  ],
                ),
              ]),
            ),
            ),  
          ],

        ),

    );
  }
}
