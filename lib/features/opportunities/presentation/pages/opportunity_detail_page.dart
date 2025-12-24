import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';
import 'package:opulent_prime_properties/features/admin/opportunities/data/repositories/opportunities_repository_impl.dart';
import 'package:opulent_prime_properties/features/admin/opportunities/data/repositories/areas_repository_impl.dart';
import 'package:opulent_prime_properties/shared/models/opportunity_model.dart';

class OpportunityDetailPage extends StatelessWidget {
  final String opportunityId;
  
  const OpportunityDetailPage({super.key, required this.opportunityId});

  @override
  Widget build(BuildContext context) {
    final opportunitiesRepo = OpportunitiesRepository();
    final areasRepo = AreasRepository();
    final priceFormat = NumberFormat.currency(
      symbol: 'AED ',
      decimalDigits: 0,
    );
    
    return FutureBuilder<OpportunityModel?>(
      future: opportunitiesRepo.getOpportunity(opportunityId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text('Error loading opportunity: ${snapshot.error ?? "Not found"}'),
            ),
          );
        }
        
        final opportunity = snapshot.data!;
        
        return FutureBuilder(
          future: areasRepo.getArea(opportunity.areaId),
          builder: (context, areaSnapshot) {
            final areaName = areaSnapshot.data?.name ?? 'Unknown Area';
            
            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: opportunity.images.isNotEmpty
                          ? Image.network(
                              opportunity.images.first,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade300,
                                  child: const Center(
                                    child: Icon(Icons.home, size: 100, color: Colors.grey),
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey.shade300,
                              child: const Center(
                                child: Icon(Icons.home, size: 100, color: Colors.grey),
                              ),
                            ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            opportunity.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            areaName,
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            priceFormat.format(opportunity.price),
                            style: TextStyle(
                              color: AppTheme.secondaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            opportunity.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          if (opportunity.images.length > 1) ...[
                            const SizedBox(height: 24),
                            const Text(
                              'Gallery',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: opportunity.images.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        opportunity.images[index],
                                        fit: BoxFit.cover,
                                        width: 200,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 200,
                                            color: Colors.grey.shade300,
                                            child: const Icon(Icons.image, size: 50),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                          if (opportunity.features.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            const Text(
                              'Features',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: opportunity.features
                                  .map((feature) => _FeatureChip(feature))
                                  .toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Add to shortlist
                          },
                          icon: const Icon(Icons.favorite_border),
                          label: const Text('Shortlist'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            context.push('${RouteNames.bookConsultation}?opportunityId=$opportunityId');
                          },
                          child: const Text('Book Consultation'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String label;

  const _FeatureChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: AppTheme.backgroundColor,
    );
  }
}

