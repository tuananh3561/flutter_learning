import 'package:dartz/dartz.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/repositories/story_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/api_client.dart';
import '../datasources/local/story_local_datasource.dart';
import '../datasources/remote/story_remote_datasource.dart';

/// Implementation of the StoryRepository interface
/// This class connects the domain layer with the actual data sources
class StoryRepositoryImpl implements StoryRepository {
  final ApiClient apiClient;
  final StoryLocalDataSource localDataSource;
  final StoryRemoteDataSource remoteDataSource;

  StoryRepositoryImpl({
    required this.apiClient,
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<StoryEntity>>> getStories(
      {int page = 1, int limit = 10}) async {
    try {
      final stories =
          await remoteDataSource.getStories(page: page, limit: limit);
      await localDataSource.cacheStories(stories);
      return Right(stories);
    } on ServerException {
      try {
        final localStories = await localDataSource.getStories();
        return Right(localStories);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, StoryEntity>> getStoryById(String id) async {
    try {
      final story = await remoteDataSource.getStoryById(id);
      await localDataSource.cacheStory(story);
      return Right(story);
    } on ServerException {
      try {
        final localStory = await localDataSource.getStoryById(id);
        return Right(localStory);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(String id) async {
    try {
      final isFavorite = await localDataSource.toggleFavorite(id);
      return Right(isFavorite);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<StoryEntity>>> getFavoriteStories() async {
    try {
      final stories = await localDataSource.getFavoriteStories();
      return Right(stories);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> updateLastRead(
      String id, DateTime timestamp) async {
    try {
      final success = await localDataSource.updateLastRead(id, timestamp);
      return Right(success);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
