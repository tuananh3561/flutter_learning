import 'package:dartz/dartz.dart';
import '../entities/story_entity.dart';
import '../../core/errors/failures.dart';

/// Repository interface for story-related operations
/// This is part of the domain layer and defines the contract
/// that data layer implementations must follow
abstract class StoryRepository {
  /// Get a list of stories
  /// Returns a [List<StoryEntity>] on success or a [Failure] on error
  Future<Either<Failure, List<StoryEntity>>> getStories({int page = 1, int limit = 10});
  
  /// Get a story by ID
  /// Returns a [StoryEntity] on success or a [Failure] on error
  Future<Either<Failure, StoryEntity>> getStoryById(String id);
  
  /// Toggle favorite status for a story
  /// Returns a [bool] indicating the new favorite status on success or a [Failure] on error
  Future<Either<Failure, bool>> toggleFavorite(String id);
  
  /// Get favorite stories
  /// Returns a [List<StoryEntity>] on success or a [Failure] on error
  Future<Either<Failure, List<StoryEntity>>> getFavoriteStories();
  
  /// Update last read timestamp for a story
  /// Returns a [bool] indicating success or a [Failure] on error
  Future<Either<Failure, bool>> updateLastRead(String id, DateTime timestamp);
}