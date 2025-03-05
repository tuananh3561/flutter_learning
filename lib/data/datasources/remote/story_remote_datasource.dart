import '../../../domain/entities/story_entity.dart';

/// Interface for remote data source operations related to stories
/// This defines the contract for accessing story data from remote APIs
abstract class StoryRemoteDataSource {
  /// Get a list of stories from the remote API
  /// Throws [ServerException] if there is a server error
  Future<List<StoryEntity>> getStories({int page = 1, int limit = 10});
  
  /// Get a story by ID from the remote API
  /// Throws [ServerException] if there is a server error
  Future<StoryEntity> getStoryById(String id);
  
  /// Search stories by keyword
  /// Throws [ServerException] if there is a server error
  Future<List<StoryEntity>> searchStories(String keyword);
  
  /// Get recommended stories based on user preferences
  /// Throws [ServerException] if there is a server error
  Future<List<StoryEntity>> getRecommendedStories();
  
  /// Get recently added stories
  /// Throws [ServerException] if there is a server error
  Future<List<StoryEntity>> getRecentStories({int limit = 10});
}