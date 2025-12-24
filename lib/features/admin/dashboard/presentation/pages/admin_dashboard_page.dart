import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _DashboardCard(
            title: 'Opportunities',
            count: '24',
            icon: Icons.home,
            color: AppTheme.primaryColor,
            onTap: () => context.push(RouteNames.adminOpportunities),
          ),
          _DashboardCard(
            title: 'Leads',
            count: '12',
            icon: Icons.people,
            color: AppTheme.successColor,
            onTap: () => context.push(RouteNames.adminLeads),
          ),
          _DashboardCard(
            title: 'Categories',
            count: '8',
            icon: Icons.category,
            color: AppTheme.secondaryColor,
            onTap: () => context.push(RouteNames.adminCategories),
          ),
          _DashboardCard(
            title: 'Consultants',
            count: '5',
            icon: Icons.person,
            color: AppTheme.accentColor,
            onTap: () => context.push(RouteNames.adminConsultants),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 16),
              Text(
                count,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

