import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';

class OpportunitiesListPage extends StatelessWidget {
  const OpportunitiesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push(RouteNames.adminOpportunityNew);
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return _OpportunityListItem(
            onTap: () {
              context.push('${RouteNames.adminOpportunityEdit}/opp_$index');
            },
          );
        },
      ),
    );
  }
}

class _OpportunityListItem extends StatelessWidget {
  final VoidCallback onTap;

  const _OpportunityListItem({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.home, color: Colors.grey),
        ),
        title: const Text('Premium Property'),
        subtitle: Text('AED 2,500,000'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

