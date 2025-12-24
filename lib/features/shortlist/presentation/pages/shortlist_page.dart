import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/firebase/firebase_config.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';
import 'package:opulent_prime_properties/features/admin/opportunities/data/repositories/opportunities_repository_impl.dart';
import 'package:opulent_prime_properties/features/admin/opportunities/data/repositories/areas_repository_impl.dart';
import 'package:opulent_prime_properties/features/shortlist/data/repositories/shortlist_repository_impl.dart';
import 'package:opulent_prime_properties/shared/models/opportunity_model.dart';

class ShortlistPage extends StatelessWidget {
  const ShortlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseConfig.auth.currentUser;
    final shortlistRepo = ShortlistRepository();
    final opportunitiesRepo = OpportunitiesRepository();
    final areasRepo = AreasRepository();

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Shortlist'),
        ),
        body: const Center(
          child: Text('Please sign in to view your shortlist'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shortlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              try {
                final shareLink = await shortlistRepo.shareShortlist(user.uid);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Shortlist shared! Link: $shareLink'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error sharing shortlist: ${e.toString()}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: shortlistRepo.getShortlistStream(user.uid),
        builder: (context, shortlistSnapshot) {
          if (shortlistSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (shortlistSnapshot.hasError) {
            return Center(
              child: Text('Error: ${shortlistSnapshot.error}'),
            );
          }

          final shortlist = shortlistSnapshot.data;
          if (shortlist == null || shortlist.opportunityIds.isEmpty) {
            return const Center(
              child: Text('Your shortlist is empty'),
            );
          }

          // Fetch opportunities for each ID
          return FutureBuilder<List<OpportunityModel>>(
            future: _fetchOpportunities(
              opportunitiesRepo,
              shortlist.opportunityIds,
            ),
            builder: (context, opportunitiesSnapshot) {
              if (opportunitiesSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (opportunitiesSnapshot.hasError) {
                return Center(
                  child: Text('Error: ${opportunitiesSnapshot.error}'),
                );
              }

              final opportunities = opportunitiesSnapshot.data ?? [];
              if (opportunities.isEmpty) {
                return const Center(
                  child: Text('No opportunities found in your shortlist'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: opportunities.length,
                itemBuilder: (context, index) {
                  final opportunity = opportunities[index];
                  return _ShortlistItem(
                    opportunity: opportunity,
                    areasRepo: areasRepo,
                    onTap: () {
                      context.push(
                        '${RouteNames.opportunity}/${opportunity.opportunityId}',
                      );
                    },
                    onRemove: () async {
                      try {
                        await shortlistRepo.removeFromShortlist(
                          user.uid,
                          opportunity.opportunityId,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Removed from shortlist'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${e.toString()}'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<OpportunityModel>> _fetchOpportunities(
    OpportunitiesRepository repo,
    List<String> opportunityIds,
  ) async {
    final List<OpportunityModel> opportunities = [];
    for (final id in opportunityIds) {
      try {
        final opportunity = await repo.getOpportunity(id);
        if (opportunity != null) {
          opportunities.add(opportunity);
        }
      } catch (e) {
        // Skip opportunities that don't exist or can't be fetched
        print('Error fetching opportunity $id: $e');
      }
    }
    return opportunities;
  }
}

class _ShortlistItem extends StatelessWidget {
  final OpportunityModel opportunity;
  final AreasRepository areasRepo;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _ShortlistItem({
    required this.opportunity,
    required this.areasRepo,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat.currency(
      symbol: 'AED ',
      decimalDigits: 0,
    );

    return FutureBuilder(
      future: areasRepo.getArea(opportunity.areaId),
      builder: (context, areaSnapshot) {
        final areaName = areaSnapshot.data?.name ?? 'Unknown Area';

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
                                return const Icon(
                                  Icons.home,
                                  size: 40,
                                  color: Colors.grey,
                                );
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
                          areaName,
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                          ),
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
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: onRemove,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
