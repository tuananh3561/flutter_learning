import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget AvatarContainer tái sử dụng cho hiển thị avatar
class AvatarContainer extends StatelessWidget {
  /// Đường dẫn đến avatar asset (null nếu là add profile)
  final String? avatarAsset;

  /// Background color của container
  final String backgroundColor;

  /// Scale factor cho responsive design
  final double scaleFactor;

  /// Có phải là add profile card không
  final bool isAddProfile;

  /// Icon path cho add profile (default: add_icon_x.svg)
  final String? addIconPath;

  const AvatarContainer({
    super.key,
    this.avatarAsset,
    required this.backgroundColor,
    required this.scaleFactor,
    this.isAddProfile = false,
    this.addIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180 * scaleFactor,
      height: 180 * scaleFactor,
      decoration: BoxDecoration(
        color: _parseColor(backgroundColor),
        borderRadius: BorderRadius.circular(36 * scaleFactor),
      ),
      child: isAddProfile ? _buildAddProfileIcon() : _buildAvatarImage(),
    );
  }

  /// Build add profile icon (dấu X)
  Widget _buildAddProfileIcon() {
    return Center(
      child: Container(
        width: 93.34 * scaleFactor,
        height: 93.34 * scaleFactor,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150 * scaleFactor),
        ),
        child: SvgPicture.asset(
          addIconPath ?? 'assets/images/profile/add_icon_x.svg',
          width: 38.18 * scaleFactor,
          height: 38.18 * scaleFactor,
        ),
      ),
    );
  }

  /// Build avatar image
  Widget _buildAvatarImage() {
    return Container(
      padding: EdgeInsets.all(30 * scaleFactor),
      child: Container(
        width: 120 * scaleFactor,
        height: 120 * scaleFactor,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60 * scaleFactor),
          border: Border.all(
            color: Colors.black.withOpacity(0.08),
            width: 6 * scaleFactor,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(54 * scaleFactor),
          child: avatarAsset != null
              ? Image.asset(
                  avatarAsset!,
                  fit: BoxFit.cover,
                )
              : Container(
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    size: 60 * scaleFactor,
                    color: Colors.grey[600],
                  ),
                ),
        ),
      ),
    );
  }

  /// Parse color string thành Color object
  Color _parseColor(String colorString) {
    final hex = colorString.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
