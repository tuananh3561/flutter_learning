import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_learning/data/models/story_content_model.dart';

/// Widget to display a single page of a story
class StoryPageWidget extends StatelessWidget {
  final StoryPageModel page;
  final StoryRootModel storyRoot;
  final String basePath;

  const StoryPageWidget({
    Key? key,
    required this.page,
    required this.storyRoot,
    required this.basePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          _buildBackgroundImage(),

          // Text elements
          ..._buildTextElements(),

          // Interactive image elements
          ..._buildImageElements(),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    // Parse the position string to get coordinates
    final position = _parsePosition(page.bgImage.position);
    return Positioned(
      // left: position.dx,
      // top: position.dy,
      left: 0,
      top: 0,
      child: Image.asset(
        '$basePath/${page.bgImage.path}',
        fit: BoxFit.cover,
        width: 1.sw,
        height: 1.sh,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading background image: $error');
          return Container(
            width: 1.sw,
            height: 1.sh,
            color: Colors.grey[200],
            child: Center(
              child: Icon(Icons.image_not_supported,
                  size: 50.sp, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildTextElements() {
    return page.textElements.map((textElement) {
      // Parse the bounding box to get position and size
      final rect = _parseRect(textElement.boundingBox);

      return Positioned(
        // left: rect.left,
        // top: rect.top,
        // width: rect.width,
        // height: rect.height,
        left: 0,
        top: 0,
        child: Container(
          padding: EdgeInsets.all(8.r),
          child: Text(
            textElement.text,
            style: TextStyle(
              fontSize: 24,
              // fontSize: page.fontSize.sp,
              color: _parseColor(page.normalColor),
              height: page.lineHeight / page.fontSize,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildImageElements() {
    return page.images.map((imageElement) {
      // Parse the position string to get coordinates
      final position = _parsePosition(imageElement.position);

      // Only add touchable images that have a path
      if (imageElement.touchable && imageElement.path.isNotEmpty) {
        return Positioned(
          left: position.dx,
          top: position.dy,
          child: GestureDetector(
            onTap: () {
              // TODO: Implement interaction with the image element
              print('Tapped on image: ${imageElement.path}');
            },
            child: Image.asset(
              '$basePath/${imageElement.path}',
              errorBuilder: (context, error, stackTrace) {
                print('Error loading image element: $error');
                return Container(
                  width: 50.w,
                  height: 50.h,
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, size: 30.sp),
                );
              },
            ),
          ),
        );
      }

      // For non-touchable or empty path images, return an empty container
      return const SizedBox.shrink();
    }).toList();
  }

  // Helper method to parse position string like "{513,381}"
  Offset _parsePosition(String positionStr) {
    try {
      // Remove braces and split by comma
      final cleanStr = positionStr.replaceAll('{', '').replaceAll('}', '');
      final parts = cleanStr.split(',');

      if (parts.length == 2) {
        final x = double.tryParse(parts[0]) ?? 0.0;
        final y = double.tryParse(parts[1]) ?? 0.0;
        return Offset(x, y);
      }
    } catch (e) {
      print('Error parsing position: $positionStr');
    }

    return Offset.zero;
  }

  // Helper method to parse rectangle string like "{{0,0},{150,150}}"
  Rect _parseRect(String rectStr) {
    try {
      // Remove all braces and split by comma
      final cleanStr = rectStr.replaceAll('{', '').replaceAll('}', '');
      final parts = cleanStr.split(',');

      if (parts.length == 4) {
        final x = double.tryParse(parts[0]) ?? 0.0;
        final y = double.tryParse(parts[1]) ?? 0.0;
        final width = double.tryParse(parts[2]) ?? 0.0;
        final height = double.tryParse(parts[3]) ?? 0.0;
        return Rect.fromLTWH(x, y, width, height);
      }
    } catch (e) {
      print('Error parsing rect: $rectStr');
    }

    return Rect.zero;
  }

  // Helper method to parse color string like "{{255,0},{0,0}}"
  Color _parseColor(String colorStr) {
    try {
      // For now, just return a default color
      // In a real implementation, this would parse the color format
      return Colors.black;
    } catch (e) {
      print('Error parsing color: $colorStr');
      return Colors.black;
    }
  }
}
