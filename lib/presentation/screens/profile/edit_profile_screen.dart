import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_learning/presentation/common/app_header.dart';
import 'package:flutter_learning/presentation/common/buttom/custom_button.dart';

/// Màn hình chỉnh sửa thông tin profile
class EditProfileScreen extends StatefulWidget {
  /// Tên hiện tại của profile
  final String currentName;

  /// Năm sinh hiện tại
  final String currentBirthYear;

  /// Avatar URL hiện tại
  final String? currentAvatarUrl;

  /// Callback khi lưu thông tin thành công
  final Function(String name, String birthYear, String? avatarUrl)? onSaved;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentBirthYear,
    this.currentAvatarUrl,
    this.onSaved,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _birthYearController;
  String? _selectedAvatarUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _birthYearController = TextEditingController(text: widget.currentBirthYear);
    _selectedAvatarUrl = widget.currentAvatarUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthYearController.dispose();
    super.dispose();
  }

  /// Handle save button press
  void _handleSave() {
    final name = _nameController.text.trim();
    final birthYear = _birthYearController.text.trim();

    if (name.isEmpty) {
      _showErrorSnackBar('Vui lòng nhập họ và tên');
      return;
    }

    if (birthYear.isEmpty) {
      _showErrorSnackBar('Vui lòng nhập năm sinh');
      return;
    }

    // Validate birth year
    final year = int.tryParse(birthYear);
    if (year == null || year < 1900 || year > DateTime.now().year) {
      _showErrorSnackBar('Năm sinh không hợp lệ');
      return;
    }

    // Call callback and go back
    if (widget.onSaved != null) {
      widget.onSaved!(name, birthYear, _selectedAvatarUrl);
    }

    Navigator.of(context).pop();
  }

  /// Show error snack bar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Handle avatar change
  void _handleAvatarChange() {
    // TODO: Implement avatar picker
    // For now, just show a placeholder message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng thay đổi ảnh đại diện đang được phát triển'),
      ),
    );
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
        child: Column(
          children: [
            // Header - Figma: y=0, height=84px
            AppHeader(
              title: 'Hồ sơ của ${widget.currentName}',
              scaleFactor: scale,
              fallbackRoute: '/profile',
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24 * scale),
                  child: Column(
                    children: [
                      SizedBox(height: 24 * scale),

                      // Avatar section
                      _buildAvatarSection(scale),

                      SizedBox(height: 24 * scale),

                      // Divider
                      _buildDivider(scale),

                      SizedBox(height: 24 * scale),

                      // Form fields
                      _buildFormFields(scale),

                      SizedBox(height: 80 * scale), // Space for bottom button
                    ],
                  ),
                ),
              ),
            ),

            // Save button - Fixed at bottom
            _buildSaveButton(scale),

            SizedBox(height: 24 * scale),
          ],
        ),
      ),
    );
  }

  /// Build avatar section - Figma: avatar + camera icon + text
  Widget _buildAvatarSection(double scale) {
    return Column(
      children: [
        // Avatar with border - Figma: 132x132px with 6px border
        Container(
          width: 132 * scale,
          height: 132 * scale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.08),
              width: 6 * scale,
            ),
          ),
          child: ClipOval(
            child: Container(
              width: 120 * scale,
              height: 120 * scale,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF5F5F5),
              ),
              child: _selectedAvatarUrl != null
                  ? Image.network(
                      _selectedAvatarUrl!,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.person,
                      size: 60 * scale,
                      color: const Color(0xFFAFAFAF),
                    ),
            ),
          ),
        ),

        SizedBox(height: 16 * scale),

        // Change avatar button
        GestureDetector(
          onTap: _handleAvatarChange,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Camera icon - Figma: 24x24px
              Container(
                width: 24 * scale,
                height: 24 * scale,
                decoration: const BoxDecoration(
                  color: Color(0xFF777777),
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 18 * scale,
                  color: Colors.white,
                ),
              ),

              SizedBox(width: 12 * scale),

              // Text
              Text(
                'Thay đổi hình đại diện',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 16 * scale,
                  color: const Color(0xFF777777),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build divider - Figma: stroke #E5E5E5
  Widget _buildDivider(double scale) {
    return Container(
      height: 1 * scale,
      width: double.infinity,
      color: const Color(0xFFE5E5E5),
    );
  }

  /// Build form fields - Figma: 2 fields with icons and edit buttons
  Widget _buildFormFields(double scale) {
    return SizedBox(
      width: 380 * scale,
      child: Column(
        children: [
          // Name field
          _buildFormField(
            scale: scale,
            label: 'Họ và tên:',
            controller: _nameController,
            icon: Icons.person_outline,
            iconColor: const Color(0xFF92C73D),
          ),

          SizedBox(height: 16 * scale),

          // Birth year field
          _buildFormField(
            scale: scale,
            label: 'Năm sinh:',
            controller: _birthYearController,
            icon: Icons.calendar_today_outlined,
            iconColor: const Color(0xFFFFB61C),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  /// Build individual form field
  Widget _buildFormField({
    required double scale,
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required Color iconColor,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with icon
        Row(
          children: [
            Container(
              width: 24 * scale,
              height: 24 * scale,
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: 18 * scale,
                color: iconColor,
              ),
            ),
            SizedBox(width: 8 * scale),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
                fontSize: 16 * scale,
                color: const Color(0xFF6F6F6F),
                height: 1.5,
              ),
            ),
          ],
        ),

        SizedBox(height: 8 * scale),

        // Form input - Figma: border #AFAFAF, padding 16x24, border radius 8px
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFAFAFAF),
              width: 1 * scale,
            ),
            borderRadius: BorderRadius.circular(8 * scale),
          ),
          child: Row(
            children: [
              // Text field
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24 * scale,
                    vertical: 16 * scale,
                  ),
                  child: TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w800,
                      fontSize: 16 * scale,
                      color: const Color(0xFFAFAFAF),
                      height: 1.5,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),

              // Edit icon
              Padding(
                padding: EdgeInsets.only(right: 24 * scale),
                child: Icon(
                  Icons.edit_outlined,
                  size: 18 * scale,
                  color: const Color(0xFF777777),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build save button - Figma: width 380px, primary button
  Widget _buildSaveButton(double scale) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24 * scale),
      child: CustomButton(
        text: 'Lưu',
        onPressed: _handleSave,
        type: ButtonType.primary,
        size: ButtonSize.xl,
        customScale: scale,
        maxWidth: 380 * scale,
      ),
    );
  }
}
