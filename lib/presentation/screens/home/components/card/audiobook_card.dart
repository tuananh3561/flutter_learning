import 'package:flutter/material.dart';

import '../../../../../data/models/home_data.dart';

/// AudiobookCard widget hiển thị một audiobook item
/// Bao gồm vinyl record, album cover, badges và speaker icons theo thiết kế Figma
class AudiobookCard extends StatelessWidget {
  final AudiobookItem audiobook;
  final Function(AudiobookItem) onAudiobookTap;
  final Function(AudiobookItem) onFavoriteTap;
  final double scale;

  const AudiobookCard({
    Key? key,
    required this.audiobook,
    required this.onAudiobookTap,
    required this.onFavoriteTap,
    this.scale = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onAudiobookTap(audiobook),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Vinyl record with album cover
          SizedBox(
            width: 180 * scale,
            height: 180 * scale,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Vinyl record circles (concentric circles)
                _buildVinylRecord(),
                // Album cover container
                Container(
                  width: 180 * scale,
                  height: 180 * scale,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24 * scale),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF0084FF), Color(0xFFB5E2FF)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Album cover image
                      Container(
                        margin: EdgeInsets.all(10 * scale),
                        width: 160 * scale,
                        height: 160 * scale,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20 * scale),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                            width: 2 * scale,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(audiobook.thumbnailUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // VIP overlay nếu là VIP audiobook
                      if (audiobook.type == AudiobookItemType.vipOverlay)
                        Container(
                          margin: EdgeInsets.all(10 * scale),
                          width: 160 * scale,
                          height: 160 * scale,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20 * scale),
                            color: Colors.black.withValues(alpha: 0.5),
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
                                color: Colors.black.withValues(alpha: 0.24),
                                blurRadius: 4 * scale,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            audiobook.duration,
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
                // FREE badge cho free audiobooks
                if (audiobook.type == AudiobookItemType.free)
                  Positioned(
                    left: -11 * scale,
                    top: 16.88 * scale,
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
                // VIP play button cho VIP audiobooks
                if (audiobook.type == AudiobookItemType.vipOverlay)
                  Positioned(
                    left: 60 * scale,
                    top: 88 * scale,
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
              ],
            ),
          ),
          SizedBox(height: 12 * scale),
          // Speaker icons ở hai bên
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSpeakerIcon(),
              _buildSpeakerIcon(),
            ],
          ),
        ],
      ),
    );
  }

  /// Tạo vinyl record với concentric circles
  Widget _buildVinylRecord() {
    return SizedBox(
      width: 160 * scale,
      height: 160 * scale,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer gradient circle
          Container(
            width: 160 * scale,
            height: 160 * scale,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.5,
                colors: [
                  Color(0xFF000000),
                  Color(0xFF5E5E5E),
                  Color(0xFF000000),
                  Color(0xFF5E5E5E),
                  Color(0xFF000000),
                ],
                stops: [0.35, 0.41, 0.47, 0.56, 0.63],
              ),
            ),
          ),
          // Concentric circles
          for (int i = 0; i < 10; i++)
            SizedBox(
              width: (150 - i * 10) * scale,
              height: (150 - i * 10) * scale,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF333333),
                    width: 1 * scale,
                  ),
                ),
              ),
            ),
          // Center white circle
          Container(
            width: 90 * scale,
            height: 90 * scale,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Tạo speaker icon
  Widget _buildSpeakerIcon() {
    return SizedBox(
      width: 24 * scale,
      height: 24 * scale,
      child: CustomPaint(
        painter: SpeakerIconPainter(
          color: const Color(0xFFAADCFF),
          scale: scale,
        ),
      ),
    );
  }
}

/// Custom painter cho speaker icon
class SpeakerIconPainter extends CustomPainter {
  final Color color;
  final double scale;

  SpeakerIconPainter({required this.color, required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = const Color(0xFFDDF1FF)
      ..style = PaintingStyle.fill;

    // Vẽ speaker base
    final baseRect = Rect.fromLTWH(
      0,
      27.71 * scale,
      24 * scale,
      14.15 * scale,
    );
    canvas.drawRect(baseRect, paint);

    // Vẽ speaker top
    final topRect = Rect.fromLTWH(
      0,
      0,
      24 * scale,
      27.71 * scale,
    );
    canvas.drawRect(topRect, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
