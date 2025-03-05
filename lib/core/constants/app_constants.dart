/// App-wide constants
class AppConstants {
  // App information
  static const String appName = "Story Nighty Night";
  static const String appDescription = "1000 Câu truyện Chúc Ngủ ngon";
  
  // API endpoints and keys would go here
  
  // Feature flags
  static const bool enableOfflineMode = true;
  
  // Default values
  static const int defaultAnimationDuration = 300; // milliseconds
  
  // Pagination
  static const int storiesPerPage = 10;
  
  // Cache configuration
  static const int maxCacheAge = 7; // days
  
  // Timeouts
  static const int connectionTimeout = 30000; // milliseconds
  static const int receiveTimeout = 30000; // milliseconds
  
  // Prevent instantiation
  AppConstants._();
}