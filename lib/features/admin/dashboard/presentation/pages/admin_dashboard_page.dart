import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';
import 'package:opulent_prime_properties/features/admin/opportunities/data/repositories/opportunities_repository_impl.dart';
import 'package:opulent_prime_properties/features/admin/leads/data/repositories/leads_repository_impl.dart';
import 'package:opulent_prime_properties/features/admin/categories/data/repositories/categories_repository_impl.dart';
import 'package:opulent_prime_properties/features/admin/consultants/data/repositories/consultants_repository_impl.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final OpportunitiesRepository _opportunitiesRepo = OpportunitiesRepository();
  final LeadsRepository _leadsRepo = LeadsRepository();
  final CategoriesRepository _categoriesRepo = CategoriesRepository();
  final ConsultantsRepository _consultantsRepo = ConsultantsRepository();

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
            key: const ValueKey('opportunities'),
            title: 'Opportunities',
            repository: _opportunitiesRepo,
            getCount: (repo) => repo.getOpportunities().map((list) => list.length.toString()),
            icon: Icons.home,
            color: AppTheme.primaryColor,
            onTap: () => context.push(RouteNames.adminOpportunities),
          ),
          _DashboardCard(
            key: const ValueKey('leads'),
            title: 'Leads',
            repository: _leadsRepo,
            getCount: (repo) => repo.getLeads().map((list) => list.length.toString()),
            icon: Icons.people,
            color: AppTheme.successColor,
            onTap: () => context.push(RouteNames.adminLeads),
          ),
          _DashboardCard(
            key: const ValueKey('categories'),
            title: 'Categories',
            repository: _categoriesRepo,
            getCount: (repo) => repo.getCategories().map((list) => list.length.toString()),
            icon: Icons.category,
            color: AppTheme.secondaryColor,
            onTap: () => context.push(RouteNames.adminCategories),
          ),
          _DashboardCard(
            key: const ValueKey('consultants'),
            title: 'Consultants',
            repository: _consultantsRepo,
            getCount: (repo) => repo.getConsultants().map((list) => list.length.toString()),
            icon: Icons.person,
            color: AppTheme.accentColor,
            onTap: () => context.push(RouteNames.adminConsultants),
          ),
          _SettingsCard(
            key: const ValueKey('settings'),
            title: 'Settings',
            icon: Icons.settings,
            color: Colors.grey,
            onTap: () => context.push(RouteNames.adminSettings),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard<T> extends StatefulWidget {
  final String title;
  final T repository;
  final Stream<String> Function(T) getCount;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    super.key,
    required this.title,
    required this.repository,
    required this.getCount,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_DashboardCard<T>> createState() => _DashboardCardState<T>();
}

class _DashboardCardState<T> extends State<_DashboardCard<T>> {
  late final Stream<String> _countStream;

  @override
  void initState() {
    super.initState();
    // Create the stream once in initState and convert to broadcast
    _countStream = widget.getCount(widget.repository).asBroadcastStream();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 48, color: widget.color),
              StreamBuilder<String>(
                stream: _countStream,
                builder: (context, snapshot) {
                  final count = snapshot.data ?? '0';
                  if (count.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        count,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: widget.color,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(
                widget.title,
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

class _SettingsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SettingsCard({
    super.key,
    required this.title,
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

