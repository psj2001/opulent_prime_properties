import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';

class OpportunityDetailPage extends StatelessWidget {
  final String opportunityId;
  
  const OpportunityDetailPage({super.key, required this.opportunityId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
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
                  const Text(
                    'Premium Property',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dubai Marina',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'AED 2,500,000',
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
                  const Text(
                    'This premium property offers luxury living in the heart of Dubai Marina. Features include spacious rooms, modern amenities, and stunning views.',
                  ),
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
                    children: [
                      _FeatureChip('3 Bedrooms'),
                      _FeatureChip('2 Bathrooms'),
                      _FeatureChip('Parking'),
                      _FeatureChip('Balcony'),
                    ],
                  ),
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

