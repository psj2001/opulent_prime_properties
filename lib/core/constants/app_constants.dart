class AppConstants {
  // App Info
  static const String appName = 'Opulent Prime Properties';
  static const String appVersion = '1.0.0';
  
  // Collections
  static const String usersCollection = 'users';
  static const String opportunitiesCollection = 'opportunities';
  static const String categoriesCollection = 'categories';
  static const String areasCollection = 'areas';
  static const String shortlistsCollection = 'shortlists';
  static const String consultationsCollection = 'consultations';
  static const String leadsCollection = 'leads';
  static const String consultantsCollection = 'consultants';
  static const String notificationsCollection = 'notifications';
  
  // Storage
  static const String opportunityImagesPath = 'opportunities';
  
  // Cloudinary Configuration
  static const String cloudinaryCloudName = 'dzp3hv4fy';
  static const String cloudinaryApiKey = '421671167788767';
  static const String cloudinaryApiSecret = ''; // Not needed for unsigned uploads with preset
  static const String cloudinaryUploadPreset = 'opportunity_images';
  
  // Shared Preferences Keys
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String isAdminKey = 'is_admin';
  
  // Lead Status
  static const String leadStatusNew = 'new';
  static const String leadStatusContacted = 'contacted';
  static const String leadStatusQualified = 'qualified';
  static const String leadStatusWon = 'won';
  static const String leadStatusLost = 'lost';
  
  // Consultation Status
  static const String consultationStatusPending = 'pending';
  static const String consultationStatusConfirmed = 'confirmed';
  static const String consultationStatusCancelled = 'cancelled';
  
  // Opportunity Status
  static const String opportunityStatusActive = 'active';
  static const String opportunityStatusInactive = 'inactive';
}

