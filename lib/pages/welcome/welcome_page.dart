import 'package:flutter/material.dart';
import '../../responsive.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to MyLab',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Corporate Medical Report System',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 32),
          ResponsiveLayout(
            mobile: _buildCards(context, crossAxisCount: 1),
            tablet: _buildCards(context, crossAxisCount: 2),
            desktop: _buildCards(context, crossAxisCount: 3),
          ),
        ],
      ),
    );
  }

  Widget _buildCards(BuildContext context, {required int crossAxisCount}) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildDashboardCard(
          context,
          icon: Icons.people,
          title: 'Patients',
          count: '1,234',
          color: Colors.blue,
        ),
        _buildDashboardCard(
          context,
          icon: Icons.assignment,
          title: 'Reports',
          count: '567',
          color: Colors.green,
        ),
        _buildDashboardCard(
          context,
          icon: Icons.pending_actions,
          title: 'Pending',
          count: '23',
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String count,
    required Color color,
  }) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                count,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
