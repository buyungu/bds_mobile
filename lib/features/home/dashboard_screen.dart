import 'package:flutter/material.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/custom_button.dart';

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        _StatCard(label: 'Total Donations', count: '5'),
        _StatCard(label: 'Pending Requests', count: '2'),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String count;

  const _StatCard({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(count, style: AppTextStyles.heading),
            const SizedBox(height: 8),
            Text(label, style: AppTextStyles.body),
          ],
        ),
      ),
    );
  }
}

class UpcomingEvents extends StatelessWidget {
  const UpcomingEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Upcoming Events',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('• World Blood Donor Day - June 14'),
          Text('• Community Blood Drive - June 20'),
        ],
      ),
    );
  }
}

class ActiveRequests extends StatelessWidget {
  const ActiveRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Active Blood Requests',
      child: Column(
        children: [
          ListTile(
            title: const Text('A+ needed at Muhimbili'),
            subtitle: const Text('2 pints • Urgent'),
            trailing: CustomButton(
              label: 'Donate',
              onPressed: () {
                Navigator.pushNamed(context, '/requests');
              },
              height: 36,
              fontSize: 14,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('O- needed at Aga Khan'),
            subtitle: const Text('1 pint • Moderate'),
            trailing: CustomButton(
              label: 'Donate',
              onPressed: () {},
              height: 36,
              fontSize: 14,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.subheading),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
