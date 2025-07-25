import 'package:flutter/material.dart';
import '../../../data/models/profile_data.dart';
import '../avatar/avatar_container.dart';

/// Widget ProfileCard tái sử dụng cho hiển thị profile
class ProfileCard extends StatelessWidget {
  final ProfileData profile;
  final double scaleFactor;
  final VoidCallback onTap;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.scaleFactor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180 * scaleFactor,
        child: Column(
          children: [
            // Avatar container
            AvatarContainer(
              avatarAsset: profile.avatarAsset,
              backgroundColor: profile.backgroundColor,
              scaleFactor: scaleFactor,
              isAddProfile: profile.isAddProfile,
            ),

            SizedBox(height: 8 * scaleFactor),

            // Name
            Container(
              width: 180 * scaleFactor,
              height: 36 * scaleFactor,
              child: Text(
                profile.name,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 14 * scaleFactor,
                  height: 1.286,
                  letterSpacing: -0.04 * 14 * scaleFactor,
                  color: profile.isAddProfile
                      ? const Color(0xFFD0D5DD)
                      : const Color(0xFF333741),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
