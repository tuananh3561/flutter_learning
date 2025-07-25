import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../data/models/home_data.dart';

/// StoryCard widget hiển thị một story item
/// Bao gồm book design, badges, và favorite button theo thiết kế Figma
class StoryCard extends StatelessWidget {
  final StoryItem story;
  final Function(StoryItem) onStoryTap;
  final Function(StoryItem) onFavoriteTap;
  final double scale;

  const StoryCard({
    Key? key,
    required this.story,
    required this.onStoryTap,
    required this.onFavoriteTap,
    this.scale = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onStoryTap(story),
      child: SizedBox(
        width: 172 * scale,
        height: 230 * scale,
        child: Stack(
          children: [
            // Background book
            Container(
              width: 172 * scale,
              height: 230 * scale,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9 * scale),
                color: _getBookColor(story.type),
                border: Border.all(
                  color: story.type == StoryItemType.free
                      ? const Color(0xFF64E600)
                      : const Color(0xFFFFC300),
                  width: story.type == StoryItemType.free
                      ? 1 * scale
                      : 1.5 * scale,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9 * scale),
                child: Stack(
                  children: [
                    // Book spine
                    Positioned(
                      left: 12 * scale,
                      top: 0,
                      child: Container(
                        width: 160 * scale,
                        height: 210 * scale,
                        decoration: BoxDecoration(
                          color: _getBookColor(story.type),
                          borderRadius: BorderRadius.circular(2 * scale),
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.08),
                            width: 1 * scale,
                          ),
                        ),
                      ),
                    ),
                    // Book bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 20 * scale,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7E5),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(9 * scale),
                            bottomRight: Radius.circular(9 * scale),
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Bookmark corner
                            Positioned(
                              right: 2.87 * scale,
                              top: 1.65 * scale,
                              child: Container(
                                width: 165.31 * scale,
                                height: 16.26 * scale,
                                color: const Color(0xFFEFDCB1),
                              ),
                            ),
                            // Right edge
                            Positioned(
                              right: 0,
                              top: 2.07 * scale,
                              child: Container(
                                width: 8.44 * scale,
                                height: 15.75 * scale,
                                color: const Color(0xFFEFDCB1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // VIP overlay nếu có
                    if (story.type == StoryItemType.vipOverlay)
                      Container(
                        width: 172 * scale,
                        height: 230 * scale,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9 * scale),
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Letter badge
            Positioned(
              right: -11 * scale,
              top: -1 * scale,
              child: Container(
                width: 30 * scale,
                height: 42 * scale,
                decoration: BoxDecoration(
                  color: const Color(0xFF009AFF),
                  borderRadius: BorderRadius.circular(1 * scale),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 4 * scale,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    story.letter,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w800,
                      fontSize: 24 * scale,
                      height: 1.364,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // Type badge
            Positioned(
              left: -11 * scale,
              top:
                  story.type == StoryItemType.free ? -9.12 * scale : -9 * scale,
              child: Container(
                width: 40 * scale,
                height: 40 * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: story.type == StoryItemType.free
                      ? const Color(0xFF50B700)
                      : Colors.white,
                  border: Border.all(
                    color: story.type == StoryItemType.free
                        ? const Color(0xFF64E600)
                        : const Color(0xFFFFC300),
                    width: story.type == StoryItemType.free
                        ? 1 * scale
                        : 1.5 * scale,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.24),
                      blurRadius: story.type == StoryItemType.free
                          ? 4 * scale
                          : 6 * scale,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: story.type == StoryItemType.free
                      ? Text(
                          'FREE',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w700,
                            fontSize: 14 * scale,
                            height: 1.714,
                            color: Colors.white,
                          ),
                        )
                      : SvgPicture.asset(
                          'assets/images/home/crown_icon.svg',
                          width: 30 * scale,
                          height: 20 * scale,
                        ),
                ),
              ),
            ),
            // VIP overlay icon nếu có
            if (story.type == StoryItemType.vipOverlay)
              Positioned(
                left: 56 * scale,
                top: 85 * scale,
                child: Container(
                  width: 60 * scale,
                  height: 60 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFFFC300),
                      width: 1.5 * scale,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.24),
                        blurRadius: 6 * scale,
                        offset: const Offset(6, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/home/crown_icon.svg',
                      width: 42 * scale,
                      height: 28 * scale,
                    ),
                  ),
                ),
              ),
            // Favorite button
            Positioned(
              right: 8 * scale,
              bottom: 8 * scale,
              child: GestureDetector(
                onTap: () => onFavoriteTap(story),
                child: Container(
                  width: 24 * scale,
                  height: 24 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: story.isFavorite ? Colors.red : Colors.white,
                    border: Border.all(
                      color: story.isFavorite ? Colors.red : Colors.grey,
                      width: 1 * scale,
                    ),
                  ),
                  child: Icon(
                    story.isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 12 * scale,
                    color: story.isFavorite ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Lấy màu của book theo type
  Color _getBookColor(StoryItemType type) {
    switch (type) {
      case StoryItemType.free:
        return const Color(0xFF4F660C);
      case StoryItemType.vip:
        return const Color(0xFFA6A813);
      case StoryItemType.vipOverlay:
        return const Color(0xFF004743);
    }
  }
}
