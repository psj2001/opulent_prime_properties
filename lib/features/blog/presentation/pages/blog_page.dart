import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';
import 'package:opulent_prime_properties/shared/models/blog_model.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  String? selectedCategory;
  String? selectedArchive;

  // Sample blog data based on the website
  final List<BlogModel> _blogs = [
    BlogModel(
      blogId: '1',
      title: 'Dubai Sets New Luxury Property Record with Dh550 Million Penthouse Sale',
      content: 'There are many variations of but the majority have simply free text.',
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
      content: 'There are many variations of but the majority have simply free text.',
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
      content: 'There are many variations of but the majority have simply free text.',
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
      content: 'There are many variations of but the majority have simply free text.',
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
      content: 'There are many variations of but the majority have simply free text.',
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
      content: 'There are many variations of but the majority have simply free text.',
      excerpt: 'There are many variations of but the majority have simply free text.',
      category: 'Luxury',
      author: 'admin',
      publishedDate: DateTime(2024, 11, 4),
      createdAt: DateTime(2024, 11, 4),
      updatedAt: DateTime(2024, 11, 4),
    ),
  ];

  final List<String> _categories = ['All', 'Fitness Zone', 'House', 'Luxury', 'Restaurant'];
  final List<String> _archives = ['All', 'December 2024', 'November 2024'];

  List<BlogModel> get _filteredBlogs {
    var filtered = _blogs.where((blog) => blog.isPublished).toList();

    if (selectedCategory != null && selectedCategory != 'All') {
      filtered = filtered.where((blog) => blog.category == selectedCategory).toList();
    }

    if (selectedArchive != null && selectedArchive != 'All') {
      final yearMonth = _parseArchive(selectedArchive!);
      if (yearMonth != null) {
        filtered = filtered.where((blog) {
          return blog.publishedDate.year == yearMonth['year'] &&
                 blog.publishedDate.month == yearMonth['month'];
        }).toList();
      }
    }

    // Sort by published date (newest first)
    filtered.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));

    return filtered;
  }

  Map<String, int>? _parseArchive(String archive) {
    if (archive == 'December 2024') return {'year': 2024, 'month': 12};
    if (archive == 'November 2024') return {'year': 2024, 'month': 11};
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Blogs'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Providing the best Real Estate services',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Categories
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = selectedCategory == category ||
                          (selectedCategory == null && category == 'All');
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = selected ? category : null;
                            });
                          },
                          selectedColor: AppTheme.secondaryColor,
                          checkmarkColor: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Archives
                const Text(
                  'Archives',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _archives.length,
                    itemBuilder: (context, index) {
                      final archive = _archives[index];
                      final isSelected = selectedArchive == archive ||
                          (selectedArchive == null && archive == 'All');
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(archive),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              selectedArchive = selected ? archive : null;
                            });
                          },
                          selectedColor: AppTheme.secondaryColor,
                          checkmarkColor: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Blog List
          Expanded(
            child: _filteredBlogs.isEmpty
                ? Center(
                    child: Text(
                      'No blogs found',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredBlogs.length,
                    itemBuilder: (context, index) {
                      final blog = _filteredBlogs[index];
                      return _BlogCard(
                        blog: blog,
                        onTap: () {
                          context.push('${RouteNames.blogDetail}/${blog.blogId}');
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _BlogCard extends StatelessWidget {
  final BlogModel blog;
  final VoidCallback onTap;

  const _BlogCard({
    required this.blog,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM', 'en_US');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
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
                  const Spacer(),
                  Text(
                    dateFormat.format(blog.publishedDate),
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                blog.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                blog.excerpt,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    blog.author,
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.comment_outlined,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '0 Comments',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

