import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/features/admin/opportunities/data/repositories/opportunities_repository_impl.dart';
import 'package:opulent_prime_properties/shared/models/opportunity_model.dart';

class OpportunitiesListPage extends StatelessWidget {
  const OpportunitiesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = OpportunitiesRepository();
    
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
      body: StreamBuilder<List<OpportunityModel>>(
        stream: repository.getOpportunities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          
          final opportunities = snapshot.data ?? [];
          
          if (opportunities.isEmpty) {
            return const Center(
              child: Text('No opportunities found'),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: opportunities.length,
            itemBuilder: (context, index) {
              final opportunity = opportunities[index];
              return _OpportunityListItem(
                opportunity: opportunity,
                onTap: () {
                  context.push('${RouteNames.adminOpportunityEdit}/${opportunity.opportunityId}');
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _OpportunityListItem extends StatelessWidget {
  final OpportunityModel opportunity;
  final VoidCallback onTap;

  const _OpportunityListItem({
    required this.opportunity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat.currency(symbol: 'AED ', decimalDigits: 0);
    
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
          child: opportunity.images.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    opportunity.images.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.home, color: Colors.grey),
                  ),
                )
              : const Icon(Icons.home, color: Colors.grey),
        ),
        title: Text(opportunity.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(priceFormat.format(opportunity.price)),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: opportunity.status == 'active'
                        ? Colors.green.shade100
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    opportunity.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: opportunity.status == 'active'
                          ? Colors.green.shade700
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

