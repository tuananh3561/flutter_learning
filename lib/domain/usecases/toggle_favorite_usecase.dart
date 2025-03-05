import 'package:dartz/dartz.dart';
import '../repositories/story_repository.dart';
import '../../core/errors/failures.dart';

/// Use case for toggling the favorite status of a story
/// This is part of the domain layer and represents a business operation
class ToggleFavoriteUseCase {
  final StoryRepository repository;

  ToggleFavoriteUseCase(this.repository);

  /// Execute the use case to toggle the favorite status of a story
  /// [id] The ID of the story to toggle favorite status for
  /// Returns a [bool] indicating the new favorite status on success or a [Failure] on error
  Future<Either<Failure, bool>> execute(String id) {
    return repository.toggleFavorite(id);
  }
}