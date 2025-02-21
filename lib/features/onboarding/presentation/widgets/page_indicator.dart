import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const PageIndicator({
    Key? key,
    required this.count,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: PageController(initialPage: currentIndex),
      count: count,
      effect: WormEffect(
        dotHeight: 8,
        dotWidth: 8,
        activeDotColor: Theme.of(context).primaryColor,
        dotColor: Colors.grey.shade300,
      ),
    );
  }
}
