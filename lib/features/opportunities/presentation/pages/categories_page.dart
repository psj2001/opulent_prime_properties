import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';
import 'package:opulent_prime_properties/features/admin/categories/data/repositories/categories_repository_impl.dart';
import 'package:opulent_prime_properties/shared/models/category_model.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = CategoriesRepository();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: StreamBuilder<List<CategoryModel>>(
        stream: repository.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          
          final categories = snapshot.data ?? [];
          
          if (categories.isEmpty) {
            return const Center(
              child: Text('No categories available'),
            );
          }
          
          // Filter only active categories
          final activeCategories = categories.where((c) => c.isActive).toList();
          
          if (activeCategories.isEmpty) {
            return const Center(
              child: Text('No active categories available'),
            );
          }
          
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: activeCategories.length,
            itemBuilder: (context, index) {
              final category = activeCategories[index];
              return _CategoryCard(
                category: category,
                onTap: () {
                  context.push('${RouteNames.category}/${category.categoryId}');
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  IconData _getIconFromString(String iconString) {
    // Map common icon strings to IconData
    switch (iconString.toLowerCase()) {
      case 'home':
      case 'house':
        return Icons.home;
      case 'apartment':
        return Icons.apartment;
      case 'villa':
        return Icons.villa;
      case 'building':
        return Icons.business;
      case 'land':
        return Icons.landscape;
      case 'office':
        return Icons.work;
      case 'shop':
      case 'store':
        return Icons.store;
      default:
        return Icons.category;
    }
  }

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
              Icon(
                _getIconFromString(category.icon),
                size: 48,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 12),
              Text(
                category.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

