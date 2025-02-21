import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/onboarding_page.dart';
import '../widgets/page_indicator.dart';
import '../widgets/onboarding_button.dart';

@RoutePage()
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<OnboardingBloc>().add(const OnboardingInitialize());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed(OnboardingInitialize state) {
    if (state.isLastPage) {
      context.read<OnboardingBloc>().add(CompleteOnboarding());
      // Navigate to next screen
      context.router.replaceNamed('/login');
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
      body: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          if (state is _Loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OnboardingError) {
            return Center(child: Text(state.message));
          }

          if (state is OnboardingLoaded) {
            return Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    context.read<OnboardingBloc>().add(PageChanged(index));
                  },
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    return OnboardingPage(item: state.items[index]);
                  },
                ),
                Positioned(
                  bottom: 80,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: PageIndicator(
                      count: state.items.length,
                      currentIndex: state.currentPage,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: OnboardingButton(
                      text: state.isLastPage ? 'Get Started' : 'Next',
                      onPressed: () => _onNextPressed(state),
                      isLastPage: state.isLastPage,
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
