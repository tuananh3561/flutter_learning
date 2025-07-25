import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_learning/data/models/profile_data.dart';
import '../../common/buttom/custom_link.dart';
import '../../common/item/profile_card.dart';
import '../home/home_screen.dart';
import 'edit_profile_screen.dart';

/// Màn hình danh sách profile học tập
class ListProfileScreen extends StatefulWidget {
  /// Có phải được gọi từ parent settings không
  /// Nếu true: nhấn profile sẽ mở edit screen
  /// Nếu false: nhấn profile sẽ chuyển sang home screen
  final bool isFromParentSettings;

  const ListProfileScreen({
    super.key,
    this.isFromParentSettings = false,
  });

  @override
  State<ListProfileScreen> createState() => _ListProfileScreenState();
}

class _ListProfileScreenState extends State<ListProfileScreen> {
  late List<ProfileData> profiles;

  @override
  void initState() {
    super.initState();
    profiles = ProfileData.getSampleProfiles();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Responsive scaling dựa trên kích thước Figma 428x926px
    final scale =
        math.min(size.width / 428.0, size.height / 926.0).clamp(0.8, 1.8);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            padding: EdgeInsets.all(0),
            child: Column(
              children: [
                // Header với back button, title và setting icon
                _buildCustomHeader(scale),

                SizedBox(height: 231 * scale),

                // Profile Grid
                _buildProfileGrid(scale),

                SizedBox(height: 418 * scale),

                // Activation Button
                _buildActivationButton(scale),

                SizedBox(height: 24 * scale),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build custom header with settings button
  Widget _buildCustomHeader(double scale) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 4 * scale),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40 * scale,
              height: 40 * scale,
              child: Icon(
                Icons.arrow_back_ios,
                size: 24 * scale,
                color: const Color(0xFF4B4B4B),
              ),
            ),
          ),

          // Title
          Text(
            'Hồ sơ học tập',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w900,
              fontSize: 20 * scale,
              height: 1.5,
              color: const Color(0xFF333741),
            ),
          ),

          // Setting button
          GestureDetector(
            onTap: () {
              // Navigate to settings screen
              context.push('/parent');
            },
            child: Container(
              width: 40 * scale,
              height: 40 * scale,
              child: SvgPicture.asset(
                'assets/images/profile/setting_icon.svg',
                width: 40 * scale,
                height: 40 * scale,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build grid layout cho danh sách profile
  Widget _buildProfileGrid(double scale) {
    return Container(
      width: 377 * scale,
      child: Wrap(
        spacing: 16 * scale,
        runSpacing: 16 * scale,
        alignment: WrapAlignment.center,
        children: profiles
            .map((profile) => ProfileCard(
                  profile: profile,
                  scaleFactor: scale,
                  onTap: () {
                    if (profile.isAddProfile) {
                      _showAddProfileDialog();
                    } else {
                      _selectProfile(profile);
                    }
                  },
                ))
            .toList(),
      ),
    );
  }

  /// Build activation button using CustomLink
  Widget _buildActivationButton(double scale) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24 * scale),
      child: CustomLink(
        text: 'Nhập mã kích hoạt',
        onTap: _showActivationDialog,
        scale: scale,
      ),
    );
  }

  /// Show dialog để thêm profile mới
  void _showAddProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm Profile'),
        content:
            const Text('Chức năng thêm profile mới sẽ được phát triển sau.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Select profile - Logic dựa trên nguồn gọi màn hình
  void _selectProfile(ProfileData profile) {
    if (widget.isFromParentSettings) {
      // Đến từ parent settings → hiển thị dialog với options
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(profile.name),
          content: const Text('Bạn muốn làm gì với profile này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _navigateToEditProfile(profile);
              },
              child: const Text('Chỉnh sửa'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _useProfile(profile);
              },
              child: const Text('Chọn profile'),
            ),
          ],
        ),
      );
    } else {
      // Navigation thông thường → chuyển thẳng sang home
      _useProfile(profile);
    }
  }

  /// Use profile and navigate to home
  void _useProfile(ProfileData profile) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã chọn profile: ${profile.name}'),
      ),
    );

    // Navigate to home with selected profile
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  /// Navigate to edit profile screen
  void _navigateToEditProfile(ProfileData profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          currentName: profile.name,
          currentBirthYear: profile.birthYear,
          currentAvatarUrl: profile.avatarAsset,
          onSaved: (name, birthYear, avatarUrl) {
            // Update profile data
            setState(() {
              final index = profiles.indexWhere((p) => p.id == profile.id);
              if (index != -1) {
                profiles[index] = profiles[index].copyWith(
                  name: name,
                  birthYear: birthYear,
                  avatarAsset: avatarUrl,
                );
              }
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đã cập nhật thông tin profile $name'),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ),
    );
  }

  /// Show dialog nhập mã kích hoạt
  void _showActivationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nhập mã kích hoạt'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Nhập mã kích hoạt...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Handle activation code
              Navigator.pop(context);
            },
            child: const Text('Kích hoạt'),
          ),
        ],
      ),
    );
  }
}
