import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';
import 'package:opulent_prime_properties/core/widgets/loading_widget.dart';
import 'package:opulent_prime_properties/features/admin/opportunities/data/repositories/opportunities_repository_impl.dart';
import 'package:opulent_prime_properties/shared/models/opportunity_model.dart';

class GoldenVisaPage extends StatelessWidget {
  const GoldenVisaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = OpportunitiesRepository();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('UAE Golden Visa'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.secondaryColor,
                    AppTheme.secondaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.verified_user_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'UAE Golden Visa 2025',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Premier long-term residency program (5 or 10 years) that allows foreigners to live, work, and study without a local sponsor. Eligibility is determined by specific achievements or financial thresholds.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            
            // Eligibility Categories
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Eligibility Categories',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // 1. Real Estate Investors
                  _EligibilitySection(
                    title: '1. Real Estate Investors (5 or 10 Years)',
                    icon: Icons.home_work,
                    color: AppTheme.primaryColor,
                    children: [
                      _InfoItem(
                        icon: Icons.house,
                        title: 'Property Ownership',
                        description: 'Purchase property (or multiple properties) with a total value of at least AED 2 million.',
                      ),
                      _InfoItem(
                        icon: Icons.account_balance,
                        title: 'Mortgages',
                        description: 'Properties with a mortgage are eligible if a bank letter proves at least AED 2 million has been paid toward the value.',
                      ),
                      _InfoItem(
                        icon: Icons.construction,
                        title: 'Off-Plan',
                        description: 'Investors may qualify for off-plan properties from approved real estate companies if the value is AED 2 million or more.',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 2. Public Investment
                  _EligibilitySection(
                    title: '2. Public Investment (10 Years)',
                    icon: Icons.account_balance_wallet,
                    color: AppTheme.secondaryColor,
                    children: [
                      _InfoItem(
                        icon: Icons.savings,
                        title: 'Investment Fund',
                        description: 'Provide a letter from an accredited UAE fund confirming a deposit of at least AED 2 million.',
                      ),
                      _InfoItem(
                        icon: Icons.business,
                        title: 'Business Capital',
                        description: 'Hold a valid commercial/industrial license with a minimum capital contribution of AED 2 million.',
                      ),
                      _InfoItem(
                        icon: Icons.receipt_long,
                        title: 'Tax Contributions',
                        description: 'Own a business that pays at least AED 250,000 annually in federal taxes.',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 3. Skilled Professionals
                  _EligibilitySection(
                    title: '3. Skilled Professionals (10 Years)',
                    icon: Icons.work,
                    color: AppTheme.successColor,
                    children: [
                      _InfoItem(
                        icon: Icons.badge,
                        title: 'Occupation Level',
                        description: 'Hold a position classified as Level 1 or 2 by the Ministry of Human Resources and Emiratisation (e.g., Managers, Scientists, Engineers, Doctors, Law, Education).',
                      ),
                      _InfoItem(
                        icon: Icons.attach_money,
                        title: 'Minimum Salary',
                        description: 'Have a monthly salary of at least AED 30,000.',
                      ),
                      _InfoItem(
                        icon: Icons.school,
                        title: 'Education',
                        description: 'Hold a Bachelor\'s degree or its equivalent.',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 4. Exceptional Talents & Specialists
                  _EligibilitySection(
                    title: '4. Exceptional Talents & Specialists (10 Years)',
                    icon: Icons.star,
                    color: Colors.amber,
                    children: [
                      _InfoItem(
                        icon: Icons.local_hospital,
                        title: 'Doctors & Scientists',
                        description: 'Need a letter of recommendation from the Ministry of Health or the Emirates Council of Scientists.',
                      ),
                      _InfoItem(
                        icon: Icons.palette,
                        title: 'Creative Talents',
                        description: 'Artists and cultural professionals must have an approval letter from the local Department of Culture.',
                      ),
                      _InfoItem(
                        icon: Icons.lightbulb,
                        title: 'Inventors',
                        description: 'Require a recommendation from the Ministry of Economy.',
                      ),
                      _InfoItem(
                        icon: Icons.medical_services,
                        title: 'Frontline Heroes',
                        description: 'Recommendation from the Frontline Heroes Office (e.g., medical staff during the COVID-19 pandemic).',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 5. Entrepreneurs
                  _EligibilitySection(
                    title: '5. Entrepreneurs (5 Years)',
                    icon: Icons.business_center,
                    color: Colors.purple,
                    children: [
                      _InfoItem(
                        icon: Icons.assessment,
                        title: 'Project Value',
                        description: 'Own or be a partner in a startup/economic project valued at no less than AED 500,000.',
                      ),
                      _InfoItem(
                        icon: Icons.trending_up,
                        title: 'Revenue Requirement',
                        description: 'Be a founder or partner in a startup generating annual revenue of at least AED 1 million.',
                      ),
                      _InfoItem(
                        icon: Icons.business,
                        title: 'Incubator Approval',
                        description: 'Secure approval from an accredited business incubator in the UAE.',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 6. Outstanding Students
                  _EligibilitySection(
                    title: '6. Outstanding Students (5 or 10 Years)',
                    icon: Icons.school,
                    color: Colors.blue,
                    children: [
                      _InfoItem(
                        icon: Icons.emoji_events,
                        title: 'High School',
                        description: 'Toppers in national secondary schools with a minimum grade of 95%.',
                      ),
                      _InfoItem(
                        icon: Icons.school_outlined,
                        title: 'UAE University Graduates',
                        description: 'Must have a GPA of at least 3.5 or 3.8 (depending on university classification) and have graduated within the last two years.',
                      ),
                      _InfoItem(
                        icon: Icons.public,
                        title: 'International Graduates',
                        description: 'Graduates from the world\'s top 100 universities with a GPA of at least 3.5.',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Additional Eligibility & Benefits
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.secondaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppTheme.secondaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Additional Eligibility & Benefits',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _InfoItem(
                          icon: Icons.person_outline,
                          title: 'Retirees',
                          description: 'Individuals aged 55+ with 15 years of work experience and either AED 1 million in savings or property worth AED 1 million may qualify for a 5-year visa.',
                        ),
                        const SizedBox(height: 12),
                        _InfoItem(
                          icon: Icons.family_restroom,
                          title: 'Family Sponsorship',
                          description: 'All Golden Visa holders can sponsor their spouse, children (regardless of age), and unlimited domestic staff.',
                        ),
                        const SizedBox(height: 12),
                        _InfoItem(
                          icon: Icons.flight_takeoff,
                          title: 'Stay Abroad',
                          description: 'Unlike standard visas, Golden Visa holders can stay outside the UAE for more than six months without losing their residency status.',
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Eligible Properties Section
                  const Text(
                    'Golden Visa Eligible Properties',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            
            // Properties List
            StreamBuilder<List<OpportunityModel>>(
              stream: repository.getGoldenVisaOpportunities(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: LoadingWidget(),
                  );
                }
                
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Error loading opportunities',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                final opportunities = snapshot.data ?? [];
                
                if (opportunities.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.home_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Golden Visa eligible properties',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Properties worth AED 2M+ will appear here',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: opportunities.length,
                  itemBuilder: (context, index) {
                    final opportunity = opportunities[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _GoldenVisaOpportunityCard(
                        opportunity: opportunity,
                        onTap: () {
                          context.push('${RouteNames.opportunity}/${opportunity.opportunityId}');
                        },
                      ),
                    );
                  },
                );
              },
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _EligibilitySection extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const _EligibilitySection({
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
  });

  @override
  State<_EligibilitySection> createState() => _EligibilitySectionState();
}

class _EligibilitySectionState extends State<_EligibilitySection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppTheme.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.children,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppTheme.secondaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GoldenVisaOpportunityCard extends StatelessWidget {
  final OpportunityModel opportunity;
  final VoidCallback onTap;

  const _GoldenVisaOpportunityCard({
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
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: opportunity.images.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
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
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                size: 14,
                                color: AppTheme.secondaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Golden Visa',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.secondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      priceFormat.format(opportunity.price),
                      style: TextStyle(
                        color: AppTheme.secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
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

