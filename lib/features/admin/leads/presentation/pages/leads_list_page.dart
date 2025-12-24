import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';

class LeadsListPage extends StatelessWidget {
  const LeadsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads & Bookings'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.successColor.withOpacity(0.1),
                child: const Icon(Icons.person, color: AppTheme.successColor),
              ),
              title: const Text('John Doe'),
              subtitle: const Text('New Lead'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push('${RouteNames.adminLeadDetail}/lead_$index');
              },
            ),
          );
        },
      ),
    );
  }
}

