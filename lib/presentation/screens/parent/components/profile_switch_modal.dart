import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/parent_data.dart';
import 'dart:math' as math;

/// Modal Bottom Sheet để chuyển đổi profile
class ProfileSwitchModal extends StatefulWidget {
  final List<ProfileSwitchItem> profiles;
  final Function(ProfileSwitchItem) onProfileSelected;

  const ProfileSwitchModal({
    super.key,
    required this.profiles,
    required this.onProfileSelected,
  });

  @override
  State<ProfileSwitchModal> createState() => _ProfileSwitchModalState();
}

class _ProfileSwitchModalState extends State<ProfileSwitchModal> {
  late List<ProfileSwitchItem> _profiles;

  @override
  void initState() {
    super.initState();
    _profiles = List.from(widget.profiles);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Responsive scaling dựa trên kích thước Figma 428x404px
    final scale =
        math.min(size.width / 428.0, size.height / 926.0).clamp(0.8, 1.8);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 24 * scale),

          // Title
          Text(
            'SWITCH PROFILE',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w900,
              fontSize: 24 * scale,
              height: 1.5,
              color: const Color(0xFF4B4B4B),
            ),
          ),

          SizedBox(height: 16 * scale),

          // Divider
          Container(
            width: double.infinity,
            height: 1 * scale,
            color: const Color(0xFFE5E5E5),
          ),

          SizedBox(height: 16 * scale),

          // Profile list
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24 * scale),
            child: Column(
              children: _profiles.map((profile) {
                return Column(
                  children: [
                    _buildProfileItem(scale, profile),
                    if (profile != _profiles.last) SizedBox(height: 16 * scale),
                  ],
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 34 * scale), // Space for bottom safe area
        ],
      ),
    );
  }

  Widget _buildProfileItem(double scale, ProfileSwitchItem profile) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Deselect all profiles
          _profiles =
              _profiles.map((p) => p.copyWith(isSelected: false)).toList();

          // Select the tapped profile
          final index = _profiles.indexWhere((p) => p.id == profile.id);
          if (index != -1) {
            _profiles[index] = _profiles[index].copyWith(isSelected: true);
          }
        });

        // Call the callback
        widget.onProfileSelected(profile);

        // Close modal
        Navigator.of(context).pop();
      },
      child: Container(
        width: 380 * scale,
        padding: EdgeInsets.all(12 * scale),
        decoration: BoxDecoration(
          color: profile.isSelected ? const Color(0xFFE5E5E5) : Colors.white,
          borderRadius: BorderRadius.circular(16 * scale),
          border: profile.isSelected
              ? Border.all(color: const Color(0xFFE5E5E5), width: 1 * scale)
              : null,
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 60 * scale,
              height: 60 * scale,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50 * scale),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.08),
                  width: 2 * scale,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(48 * scale),
                child: Image.asset(
                  profile.avatarAsset,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(width: 12 * scale),

            // Profile info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w800,
                      fontSize: 20 * scale,
                      height: 1.5,
                      color: const Color(0xFF4B4B4B),
                    ),
                  ),
                  SizedBox(height: 4 * scale),
                  Text(
                    profile.joinDate,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700,
                      fontSize: 16 * scale,
                      height: 1.5,
                      color: const Color(0xFFAFAFAF),
                    ),
                  ),
                ],
              ),
            ),

            // Checkmark icon (chỉ hiển thị nếu được selected)
            if (profile.isSelected)
              Container(
                width: 24 * scale,
                height: 24 * scale,
                decoration: BoxDecoration(
                  color: const Color(0xFF92C73D),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16 * scale,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
