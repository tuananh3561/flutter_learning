import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
//route
import '../../../../routes/route_constants.dart';
// bloc
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
// widget
import '../widgets/onboarding_page.dart';
import '../widgets/onboarding_progress.dart';
import '../widgets/onboarding_button.dart';

@RoutePage()
class OnboardingScreen extends StatefulWidget implements AutoRouteWrapper {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.I<OnboardingBloc>()..add(const OnboardingEvent.initialize()),
      child: this,
    );
  }

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed(bool isLastPage) {
    if (isLastPage) {
      context.read<OnboardingBloc>().add(
            const OnboardingEvent.nextTapped(isLastPage: true),
          );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          state.maybeMap(
            completed: (_) {
              context.router.replaceNamed(RouteConstants.login);
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.map(
            initial: (_) => const SizedBox.shrink(),
            loading: (_) => const Center(
              child: CircularProgressIndicator(),
            ),
            success: (state) => SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: OnboardingProgress(
                      progress: state.progress,
                      onSkip: () => context.read<OnboardingBloc>().add(
                            const OnboardingEvent.skip(),
                          ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        context.read<OnboardingBloc>().add(
                              OnboardingEvent.pageChanged(
                                pageIndex: index,
                                totalPages: state.items.length,
                              ),
                            );
                      },
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        return OnboardingPage(
                          item: state.items[index],
                          isCurrentPage: index == state.currentPage,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: OnboardingButton(
                      isLastPage: state.isLastPage,
                      onPressed: () => _onNextPressed(state.isLastPage),
                    ),
                  ),
                ],
              ),
            ),
            error: (error) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    error.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red[700]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<OnboardingBloc>().add(
                          const OnboardingEvent.initialize(),
                        ),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
            completed: (_) => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
