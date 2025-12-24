import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:opulent_prime_properties/core/constants/app_constants.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _pages = [
    const OnboardingItem(
      title: 'Welcome to Opulent Prime Properties',
      description: 'Discover premium Dubai real estate investment opportunities with 15+ years of market expertise',
      icon: Icons.home_work,
      showLogo: true,
    ),
    const OnboardingItem(
      title: 'Premium Luxury Developments',
      description: 'Partnered with leading developers like Emaar and Meraas to bring you exclusive off-plan projects',
      icon: Icons.diamond,
      showLogo: false,
    ),
    const OnboardingItem(
      title: 'Prime Dubai Locations',
      description: 'Explore iconic areas: Palm Jebel Ali, Business Bay, Dubai Marina, and Downtown Dubai',
      icon: Icons.location_city,
      showLogo: false,
    ),
    const OnboardingItem(
      title: 'Expert Consultation & Services',
      description: 'Get personalized guidance from our strategic real estate leaders for buying, selling, and leasing',
      icon: Icons.verified_user,
      showLogo: false,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardingCompletedKey, true);
    if (mounted) {
      context.go(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              AppTheme.backgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: const EdgeInsets.only(top: 16.0, right: 16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _completeOnboarding,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _OnboardingContent(item: _pages[index]);
                  },
                ),
              ),
              // Progress indicators
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _buildDot(index),
                  ),
                ),
              ),
              // Action button
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _currentPage == _pages.length - 1
                        ? _completeOnboarding
                        : () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1
                          ? 'Explore Properties'
                          : 'Next',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: _currentPage == index
            ? AppTheme.secondaryColor
            : Colors.grey.shade300,
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;
  final bool showLogo;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
    this.showLogo = false,
  });
}

class _OnboardingContent extends StatelessWidget {
  final OnboardingItem item;

  const _OnboardingContent({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo on first screen
          if (item.showLogo) ...[
            Image.asset(
              'assets/Opulent Prime Properties logo-07.png',
              height: 80,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 48),
          ],
          // Icon with gradient background (not shown on first slide)
          if (!item.showLogo) ...[
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.1),
                    AppTheme.secondaryColor.withOpacity(0.1),
                  ],
                ),
              ),
              child: Icon(
                item.icon,
                size: 100,
                color: AppTheme.secondaryColor,
              ),
            ),
            const SizedBox(height: 48),
          ],
          // Title
          Text(
            item.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                  fontSize: 28,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Description
          Text(
            item.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

