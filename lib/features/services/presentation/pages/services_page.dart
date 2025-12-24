import 'package:flutter/material.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Services'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ServiceCard(
            icon: Icons.search,
            title: 'Property Search',
            description: 'Find the perfect investment property',
          ),
          _ServiceCard(
            icon: Icons.people,
            title: 'Expert Consultation',
            description: 'Get advice from our real estate experts',
          ),
          _ServiceCard(
            icon: Icons.assessment,
            title: 'Market Analysis',
            description: 'Comprehensive market insights and trends',
          ),
          _ServiceCard(
            icon: Icons.handshake,
            title: 'Investment Planning',
            description: 'Strategic investment planning and guidance',
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

