import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final Map<String, bool> _expandedFaqs = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.accentColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'About Us',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Dubai\'s Leading Real Estate Brokerage Firm',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Main Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Introduction
                  const Text(
                    'Welcome to Opulent Prime Properties',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to Opulent Prime Properties, where your dream home becomes a reality. With a legacy built on trust, integrity, and exceptional customer service, we are a leading real estate firm dedicated to providing high-quality properties and outstanding investment opportunities.\n\nAt Opulent Prime Properties, we understand that real estate is more than just a transaction, it\'s about creating lasting connections and finding the perfect space for every individual. Whether you\'re looking for your first home, a luxury investment, or a commercial space, our team of experts is here to guide you every step of the way.\n\nOur mission is simple: to offer a seamless experience by combining innovative solutions with unparalleled market knowledge. With a keen eye for detail, we ensure that every property we offer reflects our commitment to quality and excellence.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Based in Dubai Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Based in Dubai, Known Worldwide\n\nAt Opulent Prime Properties, we\'re more than a team, we\'re a close-knit family. Built on trust, collaboration, and shared goals, we foster a supportive environment where every member feels valued. Together, we create exceptional experiences, both for our clients and within our company.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Statistics
                  const Text(
                    'Our Achievements',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _StatisticsGrid(),
                  const SizedBox(height: 40),
                  
                  // Mission, Vision, Values
                  _MissionVisionValues(),
                  const SizedBox(height: 40),
                  
                  // CEO Message
                  _CEOMessage(),
                  const SizedBox(height: 40),
                  
                  // Developer Partners
                  const Text(
                    'Our Trusted Developer Partners',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'We work with leading developers in Dubai to bring you the best properties.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _DeveloperPartners(),
                  const SizedBox(height: 40),
                  
                  // FAQ Section
                  const Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _FAQSection(expandedFaqs: _expandedFaqs),
                  const SizedBox(height: 40),
                  
                  // Contact CTA
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor,
                          AppTheme.accentColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Ready to Find Your Dream Property?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Contact us today and let our experts help you find the perfect property.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            context.push(RouteNames.contact);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Contact Us',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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

class _StatisticsGrid extends StatelessWidget {
  const _StatisticsGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                value: 'AED 3B+',
                label: 'Annual Sales Value',
                icon: Icons.trending_up,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                value: 'Since 2010',
                label: 'Established',
                icon: Icons.calendar_today,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                value: '5000+',
                label: 'Happy Clients',
                icon: Icons.people,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                value: '180+',
                label: 'Realtors',
                icon: Icons.business,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: AppTheme.secondaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionVisionValues extends StatelessWidget {
  const _MissionVisionValues();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Our Mission',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Opulent Prime Properties is your personalized Real Estate broker. We have redefined business standards through impartiality and honesty. We undergo each deal with integrity and are determined to bestow unrelenting effective and efficient customer service.',
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Our Vision',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Our mandate is to provide quality services in a result-oriented manner with complete transparency for our clients. Our goal is to succeed, enabling our diverse team of valued employees to hold great accountability towards our prized customers.',
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Our Values',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Opulent Prime Properties is a family founded real estate company based in Dubai. We aim to achieve our vision through upholding our values of integrity, passion, professionalism, and work.',
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _CEOMessage extends StatelessWidget {
  const _CEOMessage();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Message From CEO',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Muhammad Asif Pervaiz',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              '"At Opulent Prime Properties, we are more than just a real estate brokerage firm, we are trusted advisors dedicated to helping our clients achieve their property dreams. Whether buying, selling, or investing, our commitment to delivering exceptional service is at the heart of everything we do.\n\nOur success is built on a foundation of integrity, expertise, and a deep understanding of the ever-evolving real estate market. We take pride in providing personalized solutions, leveraging our extensive network and market insights to deliver results that exceed expectations.\n\nAs a team, we believe in building lasting relationships, not just transactions. At Opulent Prime Properties, every client becomes part of our family, and their success is our greatest reward. Thank you for entrusting us with your real estate journey. We look forward to helping you navigate the path to your goals with confidence and care."',
              style: TextStyle(
                fontSize: 16,
                height: 1.8,
                fontStyle: FontStyle.italic,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeveloperPartners extends StatelessWidget {
  const _DeveloperPartners();

  @override
  Widget build(BuildContext context) {
    // Sample developer names - in real app, fetch from Firestore
    final developers = [
      'Emaar Properties',
      'Dubai Properties',
      'Nakheel',
      'Sobha Realty',
      'Azizi Developments',
      'Damac Properties',
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: developers.map((developer) {
        return Chip(
          label: Text(developer),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          backgroundColor: AppTheme.secondaryColor.withOpacity(0.1),
          labelStyle: const TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        );
      }).toList(),
    );
  }
}

class _FAQSection extends StatelessWidget {
  final Map<String, bool> expandedFaqs;

  const _FAQSection({required this.expandedFaqs});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'question': 'What services does Opulent Prime Properties offer?',
        'answer':
            'Opulent Prime Properties offers a wide range of real estate services, including property sales, rentals, investment opportunities, and property management. We specialize in residential, commercial, and luxury properties.',
      },
      {
        'question': 'Can Opulent Prime Properties help me find my dream home?',
        'answer':
            'Absolutely! Whether you\'re a first-time buyer or seeking a luxury property, our experienced team will work closely with you to find the perfect home that matches your lifestyle and budget.',
      },
      {
        'question': 'How long has Opulent Prime Properties been in business?',
        'answer':
            'Opulent Prime Properties has been serving clients for over 13 years, establishing a strong reputation for reliability, professionalism, and exceptional service in the real estate industry.',
      },
      {
        'question':
            'What makes Opulent Prime Properties different from other real estate companies?',
        'answer':
            'We stand out for our personalized approach, understanding the unique needs of each client. Our team combines extensive market knowledge with a dedication to delivering the highest quality properties and investments.',
      },
      {
        'question':
            'Does Opulent Prime Properties handle both residential and commercial properties?',
        'answer':
            'Yes, we specialize in both residential and commercial properties, offering a diverse portfolio to cater to various needs, from family homes to office spaces and investment properties.',
      },
      {
        'question': 'Can Opulent Prime Properties assist with property investment?',
        'answer':
            'Yes, we offer expert advice and guidance on property investments, helping you identify the best opportunities for long-term returns. Whether you\'re a seasoned investor or a first-timer, we provide tailored solutions to maximize your investment potential.',
      },
    ];

    return Column(
      children: faqs.map((faq) {
        final question = faq['question']!;
        final answer = faq['answer']!;
        final isExpanded = expandedFaqs[question] ?? false;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            title: Text(
              question,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            initiallyExpanded: isExpanded,
            onExpansionChanged: (expanded) {
              expandedFaqs[question] = expanded;
            },
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  answer,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

