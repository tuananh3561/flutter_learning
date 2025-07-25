import 'package:flutter/material.dart';

import '../../../../data/models/home_data.dart';
import 'card/video_card.dart';

/// Component cho video grid
/// Hiển thị danh sách videos theo grid layout giống 100% thiết kế Figma
class VideoGrid extends StatelessWidget {
  final List<VideoItem> videos;
  final Function(VideoItem) onVideoTap;
  final Function(VideoItem) onFavoriteTap;
  final ScrollController? scrollController;
  final double scale;

  const VideoGrid({
    Key? key,
    required this.videos,
    required this.onVideoTap,
    required this.onFavoriteTap,
    this.scrollController,
    this.scale = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: 67 * scale,
        vertical: 24 * scale,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio:
            240 / 180, // 240w x 180h (160h image + 20h gap + title)
        crossAxisSpacing: 32 * scale,
        mainAxisSpacing: 24 * scale,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return VideoCard(
          video: video,
          onVideoTap: onVideoTap,
          onFavoriteTap: onFavoriteTap,
          scale: scale,
        );
      },
    );
  }
}
