import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import '../../../../data/models/home_data.dart';
import 'card/story_card.dart';

/// Component cho story grid
/// Hiển thị danh sách stories theo grid layout
class StoryGrid extends StatelessWidget {
  final List<StoryItem> stories;
  final Function(StoryItem) onStoryTap;
  final Function(StoryItem) onFavoriteTap;
  final ScrollController? scrollController;
  final double scale;

  const StoryGrid({
    Key? key,
    required this.stories,
    required this.onStoryTap,
    required this.onFavoriteTap,
    this.scrollController,
    this.scale = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(vertical: 24 * scale),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        childAspectRatio: 172 / 230,
        crossAxisSpacing: 24 * scale,
        mainAxisSpacing: 24 * scale,
      ),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return StoryCard(
          story: story,
          onStoryTap: onStoryTap,
          onFavoriteTap: onFavoriteTap,
          scale: scale,
        );
      },
    );
  }
}

/// Component cho navigation button (back button)
class HomeNavigationButton extends StatelessWidget {
  final VoidCallback onTap;

  const HomeNavigationButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale =
        math.min(size.width / 926.0, size.height / 692.0).clamp(0.8, 1.8);

    return Positioned(
      bottom: 620 * scale,
      left: 439 * scale,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 48 * scale,
          height: 48 * scale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFFFFF),
            border: Border.all(
              color: const Color(0xFF009AFF),
              width: 1.33 * scale,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 4 * scale,
                offset: Offset(0, 4 * scale),
              ),
            ],
          ),
          child: SvgPicture.asset(
            'assets/images/home/arrow_left.svg',
            width: 26.67 * scale,
            height: 26.67 * scale,
            colorFilter: const ColorFilter.mode(
              Color(0xFF009AFF),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

/// Component cho scroll indicator
class HomeScrollIndicator extends StatelessWidget {
  final double scrollProgress; // 0.0 to 1.0

  const HomeScrollIndicator({
    Key? key,
    required this.scrollProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale =
        math.min(size.width / 926.0, size.height / 692.0).clamp(0.8, 1.8);

    return Positioned(
      top: 92 * scale,
      right: 8 * scale,
      child: Container(
        width: 4 * scale,
        height: 508 * scale,
        decoration: BoxDecoration(
          color: const Color(0xFF6DC5FF).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(40 * scale),
        ),
        child: Stack(
          children: [
            // Progress indicator
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 4 * scale,
                height: 40 * scale * scrollProgress,
                decoration: BoxDecoration(
                  color: const Color(0xFF6DC5FF),
                  borderRadius: BorderRadius.circular(40 * scale),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
