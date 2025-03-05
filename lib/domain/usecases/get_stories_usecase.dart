import 'package:dartz/dartz.dart';
import '../entities/story_entity.dart';
import '../repositories/story_repository.dart';
import '../../core/errors/failures.dart';

/// Use case for retrieving a list of stories
/// This is part of the domain layer and represents a business operation
class GetStoriesUseCase {
  final StoryRepository repository;

  GetStoriesUseCase(this.repository);

  /// Execute the use case to get a list of stories
  /// [page] The page number to retrieve (pagination)
  /// [limit] The number of stories per page
  /// Returns a [List<StoryEntity>] on success or a [Failure] on error
  Future<Either<Failure, List<StoryEntity>>> execute({int page = 1, int limit = 10}) {
    return repository.getStories(page: page, limit: limit);
  }
}