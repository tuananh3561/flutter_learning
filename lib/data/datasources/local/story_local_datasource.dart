import '../../../domain/entities/story_entity.dart';
import '../../models/story_model.dart';

/// Interface for local data source operations related to stories
/// This defines the contract for accessing story data from local storage
abstract class StoryLocalDataSource {
  /// Get all stories from local storage
  /// Throws [CacheException] if no cached data is present
  Future<List<StoryEntity>> getStories();
  
  /// Get a story by ID from local storage
  /// Throws [CacheException] if no cached data is present
  Future<StoryEntity> getStoryById(String id);
  
  /// Cache a list of stories to local storage
  /// Returns [bool] indicating success
  Future<bool> cacheStories(List<StoryEntity> stories);
  
  /// Cache a single story to local storage
  /// Returns [bool] indicating success
  Future<bool> cacheStory(StoryEntity story);
  
  /// Toggle favorite status for a story
  /// Returns [bool] indicating the new favorite status
  Future<bool> toggleFavorite(String id);
  
  /// Get all favorite stories from local storage
  /// Throws [CacheException] if no cached data is present
  Future<List<StoryEntity>> getFavoriteStories();
  
  /// Update last read timestamp for a story
  /// Returns [bool] indicating success
  Future<bool> updateLastRead(String id, DateTime timestamp);
}