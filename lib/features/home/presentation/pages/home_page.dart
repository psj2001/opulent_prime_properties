import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';
import 'package:opulent_prime_properties/features/admin/opportunities/data/repositories/opportunities_repository_impl.dart';
import 'package:opulent_prime_properties/shared/models/opportunity_model.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _heroFadeAnimation;
  late Animation<double> _heroScaleAnimation;
  late Animation<Offset> _heroSlideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Hero section animations
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _heroFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _heroController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _heroScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _heroController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _heroSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _heroController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    // Content animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Start animations
    _heroController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Why Dubai Section
            _WhyDubaiSection(
              fadeAnimation: _heroFadeAnimation,
              scaleAnimation: _heroScaleAnimation,
              slideAnimation: _heroSlideAnimation,
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Investor Quick Actions Section
                      _AnimatedSectionHeader(title: 'Get Started', delay: 200),
                      const SizedBox(height: 20),
                      _InvestorQuickActions(delay: 300),
                      const SizedBox(height: 40),
                      // Featured Opportunities Section
                      _AnimatedSectionHeader(
                        title: 'Curated by Opulent Prime Properties',
                        subtitle: 'Featured Opportunities',
                        delay: 400,
                        showViewAll: true,
                        onViewAll: () => context.push(RouteNames.categories),
                      ),
                      const SizedBox(height: 20),
                      _AnimatedFeaturedOpportunities(delay: 500),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Shortlist',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(RouteNames.home);
              break;
            case 1:
              context.push(RouteNames.categories);
              break;
            case 2:
              context.push(RouteNames.shortlist);
              break;
            case 3:
              context.push(RouteNames.profile);
              break;
          }
        },
      ),
    );
  }
}

// Why Dubai Section
class _WhyDubaiSection extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;
  final Animation<Offset> slideAnimation;

  const _WhyDubaiSection({
    required this.fadeAnimation,
    required this.scaleAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.accentColor,
                  AppTheme.primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Animated background pattern
                Positioned.fill(
                  child: CustomPaint(painter: _HeroPatternPainter()),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 32.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tagline
                      const Text(
                        'Invest in Dubai',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Confidently, Remotely, End-to-End.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Why Dubai Highlights
                      _WhyDubaiHighlights(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Why Dubai Highlights
class _WhyDubaiHighlights extends StatelessWidget {
  final List<_DubaiHighlight> highlights = const [
    _DubaiHighlight(
      icon: Icons.account_balance_wallet_rounded,
      title: 'Tax-Free Income',
      description: 'Zero income tax on rental returns',
    ),
    _DubaiHighlight(
      icon: Icons.security_rounded,
      title: 'Safety',
      description: 'One of the safest cities globally',
    ),
    _DubaiHighlight(
      icon: Icons.trending_up_rounded,
      title: 'High Rental Demand',
      description: 'Strong rental yields & occupancy',
    ),
    _DubaiHighlight(
      icon: Icons.public_rounded,
      title: 'Global Hub',
      description: 'Strategic location, world-class infrastructure',
    ),
  ];

  _WhyDubaiHighlights();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _DubaiHighlightCard(highlight: highlights[0], delay: 0),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DubaiHighlightCard(highlight: highlights[1], delay: 100),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _DubaiHighlightCard(highlight: highlights[2], delay: 200),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DubaiHighlightCard(highlight: highlights[3], delay: 300),
            ),
          ],
        ),
      ],
    );
  }
}

class _DubaiHighlight {
  final IconData icon;
  final String title;
  final String description;

  const _DubaiHighlight({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _DubaiHighlightCard extends StatefulWidget {
  final _DubaiHighlight highlight;
  final int delay;

  const _DubaiHighlightCard({required this.highlight, required this.delay});

  @override
  State<_DubaiHighlightCard> createState() => _DubaiHighlightCardState();
}

class _DubaiHighlightCardState extends State<_DubaiHighlightCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(widget.highlight.icon, color: Colors.white, size: 28),
              const SizedBox(height: 8),
              Text(
                widget.highlight.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.highlight.description,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.9),
                ),
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

// Pattern painter for hero section
class _HeroPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw grid pattern
    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Animated Section Header
class _AnimatedSectionHeader extends StatefulWidget {
  final String title;
  final String? subtitle;
  final int delay;
  final bool showViewAll;
  final VoidCallback? onViewAll;

  const _AnimatedSectionHeader({
    required this.title,
    this.subtitle,
    required this.delay,
    this.showViewAll = false,
    this.onViewAll,
  });

  @override
  State<_AnimatedSectionHeader> createState() => _AnimatedSectionHeaderState();
}

class _AnimatedSectionHeaderState extends State<_AnimatedSectionHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: widget.subtitle != null ? 18 : 24,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                          letterSpacing: 0.3,
                        ),
                      ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.subtitle!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.showViewAll)
                  TextButton(
                    onPressed: widget.onViewAll,
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('View All'),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Investor Quick Actions
class _InvestorQuickActions extends StatelessWidget {
  final int delay;

  const _InvestorQuickActions({required this.delay});

  Future<void> _launchWhatsApp(BuildContext context) async {
    final uri = Uri.parse('https://wa.me/971501234567');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open WhatsApp. Please install WhatsApp.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _AnimatedQuickActionCard(
                title: 'Explore Opportunities',
                icon: Icons.search_rounded,
                color: AppTheme.primaryColor,
                delay: delay,
                onTap: () => context.push(RouteNames.categories),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _AnimatedQuickActionCard(
                title: 'Golden Visa\n(10 Years)',
                icon: Icons.verified_user_rounded,
                color: AppTheme.secondaryColor,
                delay: delay + 100,
                onTap: () => context.push(RouteNames.goldenVisa),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _AnimatedQuickActionCard(
                title: 'Book Consultation',
                icon: Icons.calendar_today_rounded,
                color: AppTheme.successColor,
                delay: delay + 200,
                onTap: () => context.push(RouteNames.bookConsultation),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _AnimatedQuickActionCard(
                title: 'Talk on WhatsApp',
                icon: Icons.chat_rounded,
                color: const Color(0xFF25D366),
                delay: delay + 300,
                onTap: () => _launchWhatsApp(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _AnimatedQuickActionCard(
                title: 'Blog',
                icon: Icons.article_rounded,
                color: AppTheme.accentColor,
                delay: delay + 400,
                onTap: () => context.push(RouteNames.blog),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _AnimatedQuickActionCard(
                title: 'About Us',
                icon: Icons.info_rounded,
                color: AppTheme.primaryColor,
                delay: delay + 500,
                onTap: () => context.push(RouteNames.aboutUs),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Animated Quick Action Card
class _AnimatedQuickActionCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final int delay;

  const _AnimatedQuickActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.delay,
  });

  @override
  State<_AnimatedQuickActionCard> createState() =>
      _AnimatedQuickActionCardState();
}

class _AnimatedQuickActionCardState extends State<_AnimatedQuickActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _elevationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedBuilder(
          animation: _elevationAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isPressed ? 0.95 : 1.0,
              child: Card(
                elevation: 2 + (_elevationAnimation.value * 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: widget.onTap,
                  onTapDown: (_) => setState(() => _isPressed = true),
                  onTapUp: (_) => setState(() => _isPressed = false),
                  onTapCancel: () => setState(() => _isPressed = false),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [Colors.white, widget.color.withOpacity(0.05)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: widget.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.icon,
                            size: 32,
                            color: widget.color,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Animated Featured Opportunities
class _AnimatedFeaturedOpportunities extends StatelessWidget {
  final int delay;

  const _AnimatedFeaturedOpportunities({required this.delay});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: StreamBuilder<List<OpportunityModel>>(
        stream: OpportunitiesRepository().getActiveOpportunities(limit: 5),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryColor,
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
            );
          }

          final opportunities = snapshot.data ?? [];

          if (opportunities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No featured opportunities available',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: opportunities.length,
            itemBuilder: (context, index) {
              final opportunity = opportunities[index];
              return _AnimatedFeaturedOpportunityCard(
                opportunity: opportunity,
                delay: delay + (index * 150),
                onTap: () {
                  context.push(
                    '${RouteNames.opportunity}/${opportunity.opportunityId}',
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// Animated Featured Opportunity Card
class _AnimatedFeaturedOpportunityCard extends StatefulWidget {
  final OpportunityModel opportunity;
  final VoidCallback onTap;
  final int delay;

  const _AnimatedFeaturedOpportunityCard({
    required this.opportunity,
    required this.onTap,
    required this.delay,
  });

  @override
  State<_AnimatedFeaturedOpportunityCard> createState() =>
      _AnimatedFeaturedOpportunityCardState();
}

class _AnimatedFeaturedOpportunityCardState
    extends State<_AnimatedFeaturedOpportunityCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat.currency(symbol: 'AED ', decimalDigits: 0);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isHovered = true),
              onTapUp: (_) {
                setState(() => _isHovered = false);
                widget.onTap();
              },
              onTapCancel: () => setState(() => _isHovered = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.identity()..scale(_isHovered ? 0.95 : 1.0),
                child: Card(
                  elevation: _isHovered ? 8 : 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image section
                        Expanded(
                          flex: 3,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.grey.shade300,
                                  Colors.grey.shade200,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: widget.opportunity.images.isNotEmpty
                                ? Hero(
                                    tag:
                                        'opportunity_${widget.opportunity.opportunityId}',
                                    child: Image.network(
                                      widget.opportunity.images.first,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Center(
                                              child: Icon(
                                                Icons.home_rounded,
                                                size: 60,
                                                color: Colors.grey.shade400,
                                              ),
                                            );
                                          },
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                  Color
                                                >(AppTheme.primaryColor),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.home_rounded,
                                      size: 60,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                          ),
                        ),
                        // Content section
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.opportunity.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppTheme.textPrimary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.attach_money_rounded,
                                      size: 20,
                                      color: AppTheme.secondaryColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      priceFormat.format(
                                        widget.opportunity.price,
                                      ),
                                      style: TextStyle(
                                        color: AppTheme.secondaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
