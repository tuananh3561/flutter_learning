import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadStories extends HomeEvent {}

class ToggleFavorite extends HomeEvent {
  final int storyId;

  const ToggleFavorite(this.storyId);

  @override
  List<Object> get props => [storyId];
}

// States
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Story> stories;
  final List<int> favoriteStoryIds;

  const HomeLoaded({
    required this.stories,
    required this.favoriteStoryIds,
  });

  @override
  List<Object> get props => [stories, favoriteStoryIds];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}

// Story Model
class Story extends Equatable {
  final int id;
  final String title;
  final String thumbnailUrl;

  const Story({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
  });

  @override
  List<Object> get props => [id, title, thumbnailUrl];
}

// BLoC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadStories>(_onLoadStories);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadStories(LoadStories event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      // TODO: Implement actual story loading logic
      final stories = List.generate(
        10,
        (index) => Story(
          id: index,
          title: 'Story $index',
          thumbnailUrl: 'https://placeholder.com/300x400',
        ),
      );
      emit(HomeLoaded(stories: stories, favoriteStoryIds: []));
    } catch (e) {
      emit(HomeError('Failed to load stories'));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<HomeState> emit) async {
    final currentState = state;
    if (currentState is HomeLoaded) {
      final updatedFavorites = List<int>.from(currentState.favoriteStoryIds);
      if (updatedFavorites.contains(event.storyId)) {
        updatedFavorites.remove(event.storyId);
      } else {
        updatedFavorites.add(event.storyId);
      }
      emit(HomeLoaded(
        stories: currentState.stories,
        favoriteStoryIds: updatedFavorites,
      ));
    }
  }
}