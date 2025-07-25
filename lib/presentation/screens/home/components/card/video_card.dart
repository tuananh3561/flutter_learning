import 'package:flutter/material.dart';

import '../../../../../data/models/home_data.dart';

/// VideoCard widget hiển thị một video item
/// Bao gồm thumbnail, badges, và duration badge theo thiết kế Figma
class VideoCard extends StatelessWidget {
  final VideoItem video;
  final Function(VideoItem) onVideoTap;
  final Function(VideoItem) onFavoriteTap;
  final double scale;

  const VideoCard({
    Key? key,
    required this.video,
    required this.onVideoTap,
    required this.onFavoriteTap,
    this.scale = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onVideoTap(video),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Video thumbnail container
          Container(
            width: 240 * scale,
            height: 140 * scale,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16 * scale),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.12),
                width: 2 * scale,
              ),
            ),
            child: Stack(
              children: [
                // Thumbnail image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16 * scale),
                  child: Container(
                    width: 240 * scale,
                    height: 140 * scale,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(video.thumbnailUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // VIP overlay nếu là VIP video
                if (video.type == VideoItemType.vipOverlay)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16 * scale),
                    child: Container(
                      width: 240 * scale,
                      height: 140 * scale,
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ),
                // FREE badge cho free videos
                if (video.type == VideoItemType.free)
                  Positioned(
                    left: -11 * scale,
                    top: -9.12 * scale,
                    child: Container(
                      width: 40 * scale,
                      height: 40 * scale,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF50B700),
                        border: Border.all(
                          color: const Color(0xFF64E600),
                          width: 1 * scale,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.24),
                            blurRadius: 4 * scale,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'FREE',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w700,
                            fontSize: 8 * scale,
                            color: Colors.white,
                            letterSpacing: -0.04 * scale,
                          ),
                        ),
                      ),
                    ),
                  ),
                // VIP play button cho VIP videos
                if (video.type == VideoItemType.vipOverlay)
                  Positioned(
                    left: 90 * scale,
                    top: 40 * scale,
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
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // VIP crown background
                          Container(
                            width: 42 * scale,
                            height: 28 * scale,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFD900), Color(0xFFFFC300)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(4 * scale),
                            ),
                          ),
                          // Crown gems
                          Positioned(
                            left: 25.63 * scale,
                            top: 23 * scale,
                            child: Container(
                              width: 8.75 * scale,
                              height: 8.75 * scale,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFFD900),
                              ),
                            ),
                          ),
                          // Crown details
                          Positioned(
                            left: 21.19 * scale,
                            top: 33.49 * scale,
                            child: Container(
                              width: 31.64 * scale,
                              height: 10.51 * scale,
                              color: const Color(0xFFFFC300),
                            ),
                          ),
                          Positioned(
                            left: 23.01 * scale,
                            top: 35.23 * scale,
                            child: Container(
                              width: 27.97 * scale,
                              height: 7.07 * scale,
                              color: const Color(0xFFFF8800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Duration badge
                Positioned(
                  right: 14 * scale,
                  bottom: 14 * scale,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8 * scale,
                      vertical: 4 * scale,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(360 * scale),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 2 * scale,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      video.duration,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                        fontSize: 12 * scale,
                        color: Colors.white,
                        height: 1.67,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8 * scale),
          // Video title
          SizedBox(
            width: 240 * scale,
            child: Text(
              video.title,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
                fontSize: 12 * scale,
                color: const Color(0xFF161B26),
                height: 1.67,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
