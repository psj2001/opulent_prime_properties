import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';
import 'package:opulent_prime_properties/features/admin/opportunities/data/repositories/opportunities_repository_impl.dart';
import 'package:opulent_prime_properties/shared/models/opportunity_model.dart';

class CategoryListingPage extends StatelessWidget {
  final String categoryId;
  
  const CategoryListingPage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final repository = OpportunitiesRepository();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Properties'),
      ),
      body: StreamBuilder<List<OpportunityModel>>(
        stream: repository.getOpportunitiesByCategory(categoryId),
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
              child: Text('No properties found in this category'),
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
                  context.push('${RouteNames.opportunity}/${opportunity.opportunityId}');
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
    final priceFormat = NumberFormat.currency(
      symbol: 'AED ',
      decimalDigits: 0,
    );
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
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
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.home, size: 40, color: Colors.grey);
                          },
                        ),
                      )
                    : const Icon(Icons.home, size: 40, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      opportunity.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      opportunity.description,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      priceFormat.format(opportunity.price),
                      style: TextStyle(
                        color: AppTheme.secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

