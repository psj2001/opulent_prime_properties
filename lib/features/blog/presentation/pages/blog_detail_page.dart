import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';
import 'package:opulent_prime_properties/shared/models/blog_model.dart';

class BlogDetailPage extends StatelessWidget {
  final String blogId;

  const BlogDetailPage({super.key, required this.blogId});

  @override
  Widget build(BuildContext context) {
    // In a real app, you would fetch the blog from Firestore
    // For now, using sample data based on the website
    final blog = _getBlogById(blogId);
    
    if (blog == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Blog Not Found')),
        body: const Center(child: Text('Blog post not found')),
      );
    }

    final dateFormat = DateFormat('dd MMM yyyy', 'en_US');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image
            if (blog.imageUrl != null)
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  image: blog.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(blog.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: blog.imageUrl == null
                    ? const Center(
                        child: Icon(
                          Icons.article,
                          size: 80,
                          color: Colors.grey,
                        ),
                      )
                    : null,
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.8),
                      AppTheme.accentColor.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.article,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      blog.category,
                      style: TextStyle(
                        color: AppTheme.secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title
                  Text(
                    blog.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Meta Information
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        dateFormat.format(blog.publishedDate),
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.person_outline,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        blog.author,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.comment_outlined,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '0 Comments',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Divider
                  const Divider(),
                  const SizedBox(height: 24),
                  // Content
                  Text(
                    blog.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Call to Action
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push(RouteNames.bookConsultation);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Book a Consultation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  BlogModel? _getBlogById(String id) {
    // Sample blog data - in real app, fetch from Firestore
    final blogs = [
      BlogModel(
        blogId: '1',
        title: 'Dubai Sets New Luxury Property Record with Dh550 Million Penthouse Sale',
        content:
            'Dubai continues to break records in the luxury real estate market with a landmark penthouse sale worth Dh550 million. This transaction represents one of the highest-value property sales in the emirate\'s history, highlighting the robust demand for premium real estate in Dubai.\n\nThere are many variations of but the majority have simply free text. The luxury property market in Dubai has been experiencing unprecedented growth, attracting high-net-worth individuals from around the globe. This record-breaking sale demonstrates the city\'s position as a premier destination for luxury real estate investments.\n\nThe penthouse features world-class amenities, breathtaking views, and exceptional design. This sale reinforces Dubai\'s status as a global real estate hub and reflects the strong confidence investors have in the market.',
        excerpt: 'There are many variations of but the majority have simply free text.',
        category: 'Luxury',
        author: 'admin',
        publishedDate: DateTime(2024, 12, 17),
        createdAt: DateTime(2024, 12, 17),
        updatedAt: DateTime(2024, 12, 17),
      ),
      BlogModel(
        blogId: '2',
        title: 'Azizi Developments Signs Second Long-Term Lease Deal with KEZAD',
        content:
            'Azizi Developments has signed its second long-term lease agreement with KEZAD, marking another significant milestone in the company\'s expansion strategy. This partnership strengthens Azizi\'s position in the commercial real estate sector.\n\nThere are many variations of but the majority have simply free text. The agreement demonstrates the growing confidence in Dubai\'s commercial real estate market and Azizi Developments\' commitment to providing world-class facilities for businesses.',
        excerpt: 'There are many variations of but the majority have simply free text.',
        category: 'Luxury',
        author: 'admin',
        publishedDate: DateTime(2024, 11, 4),
        createdAt: DateTime(2024, 11, 4),
        updatedAt: DateTime(2024, 11, 4),
      ),
      BlogModel(
        blogId: '3',
        title: 'Dubai Islands Emerging as the Global Buyers Seek Exclusive Waterfront Homes',
        content:
            'Dubai Islands are rapidly emerging as one of the most sought-after destinations for global buyers seeking exclusive waterfront properties. The development offers unparalleled luxury living with stunning views and world-class amenities.\n\nThere are many variations of but the majority have simply free text. The demand for waterfront homes in Dubai has been steadily increasing, driven by the unique lifestyle these properties offer. Dubai Islands represent the pinnacle of waterfront living in the region.',
        excerpt: 'There are many variations of but the majority have simply free text.',
        category: 'Luxury',
        author: 'admin',
        publishedDate: DateTime(2024, 11, 4),
        createdAt: DateTime(2024, 11, 4),
        updatedAt: DateTime(2024, 11, 4),
      ),
      BlogModel(
        blogId: '4',
        title: 'Mubadala and Aldar Announce \$16bn Expansion of Al Maryah Island',
        content:
            'Mubadala Investment Company and Aldar Properties have announced a massive \$16 billion expansion plan for Al Maryah Island. This ambitious project will further enhance the island\'s status as a premier business and residential destination.\n\nThere are many variations of but the majority have simply free text. The expansion represents one of the largest real estate developments in Abu Dhabi and underscores the strong growth trajectory of the UAE\'s real estate sector.',
        excerpt: 'There are many variations of but the majority have simply free text.',
        category: 'Luxury',
        author: 'admin',
        publishedDate: DateTime(2024, 11, 4),
        createdAt: DateTime(2024, 11, 4),
        updatedAt: DateTime(2024, 11, 4),
      ),
      BlogModel(
        blogId: '5',
        title: 'Dubai Launches New 3-Year Service Fee System for Palm Jumeirah',
        content:
            'Dubai has introduced a new 3-year service fee system for properties on Palm Jumeirah, providing greater transparency and predictability for property owners. This initiative aims to streamline service charge management for one of Dubai\'s most iconic developments.\n\nThere are many variations of but the majority have simply free text. The new system offers property owners better financial planning capabilities and enhanced transparency in service fee allocation.',
        excerpt: 'There are many variations of but the majority have simply free text.',
        category: 'Luxury',
        author: 'admin',
        publishedDate: DateTime(2024, 11, 4),
        createdAt: DateTime(2024, 11, 4),
        updatedAt: DateTime(2024, 11, 4),
      ),
      BlogModel(
        blogId: '6',
        title: 'What Are the Average Rental Prices in International City for 2025?',
        content:
            'As we enter 2025, prospective tenants are looking for insights into rental prices in International City, one of Dubai\'s most popular residential areas. This comprehensive guide provides the latest information on average rental prices and market trends.\n\nThere are many variations of but the majority have simply free text. International City continues to offer attractive rental options for various budgets, making it a preferred choice for many residents in Dubai.',
        excerpt: 'There are many variations of but the majority have simply free text.',
        category: 'Luxury',
        author: 'admin',
        publishedDate: DateTime(2024, 11, 4),
        createdAt: DateTime(2024, 11, 4),
        updatedAt: DateTime(2024, 11, 4),
      ),
    ];

    try {
      return blogs.firstWhere((blog) => blog.blogId == id);
    } catch (e) {
      return null;
    }
  }
}

