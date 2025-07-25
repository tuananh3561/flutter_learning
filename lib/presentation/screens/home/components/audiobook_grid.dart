import 'package:flutter/material.dart';

import '../../../../data/models/home_data.dart';
import 'card/audiobook_card.dart';

/// Component cho audiobook grid
/// Hiển thị danh sách audiobooks theo grid layout giống 100% thiết kế Figma
class AudiobookGrid extends StatelessWidget {
  final List<AudiobookItem> audiobooks;
  final Function(AudiobookItem) onAudiobookTap;
  final Function(AudiobookItem) onFavoriteTap;
  final ScrollController? scrollController;
  final double scale;

  const AudiobookGrid({
    Key? key,
    required this.audiobooks,
    required this.onAudiobookTap,
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
        crossAxisCount: 4,
        childAspectRatio:
            180 / 220, // 180w x 220h (180h vinyl + gap + speakers)
        crossAxisSpacing: 24 * scale,
        mainAxisSpacing: 40 * scale,
      ),
      itemCount: audiobooks.length,
      itemBuilder: (context, index) {
        final audiobook = audiobooks[index];
        return AudiobookCard(
          audiobook: audiobook,
          onAudiobookTap: onAudiobookTap,
          onFavoriteTap: onFavoriteTap,
          scale: scale,
        );
      },
    );
  }
}
