import 'package:go_router/go_router.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/features/auth/presentation/pages/admin_login_page.dart';
import 'package:opulent_prime_properties/features/auth/presentation/pages/login_page.dart';
import 'package:opulent_prime_properties/features/auth/presentation/pages/signup_page.dart';
import 'package:opulent_prime_properties/features/auth/presentation/pages/splash_page.dart';
import 'package:opulent_prime_properties/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:opulent_prime_properties/features/home/presentation/pages/home_page.dart';
import 'package:opulent_prime_properties/features/opportunities/presentation/pages/categories_page.dart';
import 'package:opulent_prime_properties/features/opportunities/presentation/pages/category_listing_page.dart';
import 'package:opulent_prime_properties/features/opportunities/presentation/pages/opportunity_detail_page.dart';
import 'package:opulent_prime_properties/features/opportunities/presentation/pages/golden_visa_page.dart';
import 'package:opulent_prime_properties/features/shortlist/presentation/pages/shortlist_page.dart';
import 'package:opulent_prime_properties/features/consultation/presentation/pages/book_consultation_page.dart';
import 'package:opulent_prime_properties/features/consultation/presentation/pages/booking_confirmation_page.dart';
import 'package:opulent_prime_properties/features/education/presentation/pages/education_hub_page.dart';
import 'package:opulent_prime_properties/features/education/presentation/pages/education_detail_page.dart';
import 'package:opulent_prime_properties/features/services/presentation/pages/services_page.dart';
import 'package:opulent_prime_properties/features/contact/presentation/pages/contact_page.dart';
import 'package:opulent_prime_properties/features/profile/presentation/pages/profile_page.dart';
import 'package:opulent_prime_properties/features/blog/presentation/pages/blog_page.dart';
import 'package:opulent_prime_properties/features/blog/presentation/pages/blog_detail_page.dart';
import 'package:opulent_prime_properties/features/about/presentation/pages/about_us_page.dart';
import 'package:opulent_prime_properties/features/admin/dashboard/presentation/pages/admin_dashboard_page.dart';
import 'package:opulent_prime_properties/features/admin/opportunities/presentation/pages/opportunities_list_page.dart';
import 'package:opulent_prime_properties/features/admin/opportunities/presentation/pages/opportunity_form_page.dart';
import 'package:opulent_prime_properties/features/admin/categories/presentation/pages/categories_management_page.dart';
import 'package:opulent_prime_properties/features/admin/leads/presentation/pages/leads_list_page.dart';
import 'package:opulent_prime_properties/features/admin/leads/presentation/pages/lead_detail_page.dart';
import 'package:opulent_prime_properties/features/admin/consultants/presentation/pages/consultants_page.dart';
import 'package:opulent_prime_properties/features/admin/settings/presentation/pages/admin_settings_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      // Splash
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      
      // Onboarding
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      
      // Authentication
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.signup,
        builder: (context, state) => const SignupPage(),
      ),
      
      // Mobile App Routes
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.categories,
        builder: (context, state) => const CategoriesPage(),
      ),
      GoRoute(
        path: '${RouteNames.category}/:categoryId',
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;
          return CategoryListingPage(categoryId: categoryId);
        },
      ),
      GoRoute(
        path: '${RouteNames.opportunity}/:opportunityId',
        builder: (context, state) {
          final opportunityId = state.pathParameters['opportunityId']!;
          return OpportunityDetailPage(opportunityId: opportunityId);
        },
      ),
      GoRoute(
        path: RouteNames.shortlist,
        builder: (context, state) => const ShortlistPage(),
      ),
      GoRoute(
        path: RouteNames.bookConsultation,
        builder: (context, state) {
          final opportunityId = state.uri.queryParameters['opportunityId'];
          return BookConsultationPage(opportunityId: opportunityId);
        },
      ),
      GoRoute(
        path: RouteNames.bookingConfirmation,
        builder: (context, state) => const BookingConfirmationPage(),
      ),
      GoRoute(
        path: RouteNames.education,
        builder: (context, state) => const EducationHubPage(),
      ),
      GoRoute(
        path: '${RouteNames.educationDetail}/:articleId',
        builder: (context, state) {
          final articleId = state.pathParameters['articleId']!;
          return EducationDetailPage(articleId: articleId);
        },
      ),
      GoRoute(
        path: RouteNames.services,
        builder: (context, state) => const ServicesPage(),
      ),
      GoRoute(
        path: RouteNames.contact,
        builder: (context, state) => const ContactPage(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: RouteNames.goldenVisa,
        builder: (context, state) => const GoldenVisaPage(),
      ),
      GoRoute(
        path: RouteNames.blog,
        builder: (context, state) => const BlogPage(),
      ),
      GoRoute(
        path: '${RouteNames.blogDetail}/:blogId',
        builder: (context, state) {
          final blogId = state.pathParameters['blogId']!;
          return BlogDetailPage(blogId: blogId);
        },
      ),
      GoRoute(
        path: RouteNames.aboutUs,
        builder: (context, state) => const AboutUsPage(),
      ),
      
      // Admin Routes
      GoRoute(
        path: RouteNames.adminLogin,
        builder: (context, state) => const AdminLoginPage(),
      ),
      GoRoute(
        path: RouteNames.adminDashboard,
        builder: (context, state) => const AdminDashboardPage(),
      ),
      GoRoute(
        path: RouteNames.adminOpportunities,
        builder: (context, state) => const OpportunitiesListPage(),
      ),
      GoRoute(
        path: RouteNames.adminOpportunityNew,
        builder: (context, state) => const OpportunityFormPage(),
      ),
      GoRoute(
        path: '${RouteNames.adminOpportunityEdit}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return OpportunityFormPage(opportunityId: id);
        },
      ),
      GoRoute(
        path: RouteNames.adminCategories,
        builder: (context, state) => const CategoriesManagementPage(),
      ),
      GoRoute(
        path: RouteNames.adminAreas,
        builder: (context, state) => const CategoriesManagementPage(), // TODO: Create AreasManagementPage
      ),
      GoRoute(
        path: RouteNames.adminLeads,
        builder: (context, state) => const LeadsListPage(),
      ),
      GoRoute(
        path: '${RouteNames.adminLeadDetail}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return LeadDetailPage(leadId: id);
        },
      ),
      GoRoute(
        path: RouteNames.adminConsultants,
        builder: (context, state) => const ConsultantsPage(),
      ),
      GoRoute(
        path: RouteNames.adminSettings,
        builder: (context, state) => const AdminSettingsPage(),
      ),
    ],
  );
}

