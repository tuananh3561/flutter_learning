import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/check_first_time_usecase.dart';
import '../../domain/usecases/complete_onboarding_usecase.dart';
import '../../domain/usecases/get_onboarding_items_usecase.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

@injectable
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final GetOnboardingItemsUseCase _getOnboardingItems;
  final CheckFirstTimeUseCase _checkFirstTime;
  final CompleteOnboardingUseCase _completeOnboarding;

  OnboardingBloc(
    this._getOnboardingItems,
    this._checkFirstTime,
    this._completeOnboarding,
  ) : super(const OnboardingState.initial()) {
    on<OnboardingEvent>((event, emit) async {
      await event.map(
        initialize: (e) => _onInitialize(e, emit),
        pageChanged: (e) => _onPageChanged(e, emit),
        nextTapped: (e) => _onNextTapped(e, emit),
        skip: (e) => _onSkip(e, emit),
      );
    });
  }

  Future<void> _onInitialize(
    OnboardingInitialize event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      emit(const OnboardingState.loading());

      // final isFirstTime = await _checkFirstTime();
      // if (!isFirstTime) {
      //   emit(const OnboardingState.completed());
      //   return;
      // }

      final items = await _getOnboardingItems();
      if (items.isEmpty) {
        emit(const OnboardingState.error(
          message: 'No onboarding content available',
        ));
        return;
      }

      emit(OnboardingState.success(
        items: items,
        currentPage: 0,
        isLastPage: false,
        progress: 1 / items.length,
      ));
    } catch (e) {
      emit(OnboardingState.error(message: e.toString()));
    }
  }

  Future<void> _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) async {
    state.maybeMap(
      success: (state) {
        emit(OnboardingState.success(
          items: state.items,
          currentPage: event.pageIndex,
          isLastPage: event.pageIndex == event.totalPages - 1,
          progress: (event.pageIndex + 1) / event.totalPages,
        ));
      },
      orElse: () {},
    );
  }

  Future<void> _onNextTapped(
    OnboardingNextTapped event,
    Emitter<OnboardingState> emit,
  ) async {
    if (event.isLastPage) {
      try {
        await _completeOnboarding();
        emit(const OnboardingState.completed());
      } catch (e) {
        emit(OnboardingState.error(message: e.toString()));
      }
    }
  }

  Future<void> _onSkip(
    OnboardingSkip event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      await _completeOnboarding();
      emit(const OnboardingState.completed());
    } catch (e) {
      emit(OnboardingState.error(message: e.toString()));
    }
  }
}
