import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import '../../../../data/models/home_data.dart';

/// Component cho tab navigation của home screen
/// Hiển thị 4 tab: Truyện, Video, Sách nói, Lộ trình
class HomeTabNavigation extends StatelessWidget {
  final List<HomeTab> tabs;
  final int activeTabIndex;
  final Function(int) onTabChanged;

  const HomeTabNavigation({
    Key? key,
    required this.tabs,
    required this.activeTabIndex,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Responsive scaling theo kích thước Figma: 926x692
    final scale =
        math.min(size.width / 926.0, size.height / 692.0).clamp(0.8, 1.8);

    return Container(
      height: 48 * scale,
      margin: EdgeInsets.symmetric(horizontal: 20 * scale),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < tabs.length; i++) ...[
            _buildTabItem(
              tab: tabs[i],
              isActive: i == activeTabIndex,
              onTap: () => onTabChanged(i),
              scale: scale,
            ),
            if (i < tabs.length - 1) SizedBox(width: 20 * scale),
          ],
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required HomeTab tab,
    required bool isActive,
    required VoidCallback onTap,
    required double scale,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48 * scale,
        padding: EdgeInsets.symmetric(horizontal: 16 * scale),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFF009AFF),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(46.67 * scale),
          border: isActive
              ? Border.all(
                  color: const Color(0xFFFFFFFF),
                  width: 1.17 * scale,
                )
              : null,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 2 * scale,
                    offset: Offset(0, 2 * scale),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tab icon
            SvgPicture.asset(
              tab.type.iconPath,
              width: 24 * scale,
              height: 24 * scale,
              colorFilter: ColorFilter.mode(
                isActive ? const Color(0xFF009AFF) : const Color(0xFFFFFFFF),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 8 * scale),
            // Tab title
            Text(
              tab.type.title,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14 * scale,
                fontWeight: FontWeight.w700,
                color: isActive
                    ? const Color(0xFF009AFF)
                    : const Color(0xFFFFFFFF),
                letterSpacing: -0.04 * scale,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Component cho top header với avatar, menu và actions
class HomeTopHeader extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onVipTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onSearchTap;
  final bool isVipUnlocked;

  const HomeTopHeader({
    Key? key,
    this.onMenuTap,
    this.onVipTap,
    this.onFilterTap,
    this.onSearchTap,
    this.isVipUnlocked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale =
        math.min(size.width / 926.0, size.height / 692.0).clamp(0.8, 1.8);

    return Container(
      height: 68 * scale,
      padding:
          EdgeInsets.symmetric(horizontal: 20 * scale, vertical: 8 * scale),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - Avatar and menu
          Row(
            children: [
              // Avatar
              Container(
                width: 60 * scale,
                height: 60 * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFFFFFF),
                    width: 3 * scale,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8 * scale,
                      offset: Offset(0, 4 * scale),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://picsum.photos/seed/avatar/120/120',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 24 * scale),
              // Menu button
              GestureDetector(
                onTap: onMenuTap,
                child: Container(
                  width: 18.44 * scale,
                  height: 18.44 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFFFFFF),
                      width: 2 * scale,
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/images/home/menu_icon.svg',
                    width: 7.68 * scale,
                    height: 6.15 * scale,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFFFFFFF),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Right side - Actions
          Row(
            children: [
              // VIP button
              GestureDetector(
                onTap: onVipTap,
                child: Container(
                  height: 48 * scale,
                  padding: EdgeInsets.symmetric(horizontal: 20 * scale),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0077FF),
                    borderRadius: BorderRadius.circular(24 * scale),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Mở khóa VIP',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 20 * scale,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFFFFFFF),
                          letterSpacing: -0.04 * scale,
                        ),
                      ),
                      SizedBox(width: 12 * scale),
                      SvgPicture.asset(
                        'assets/images/home/crown_icon.svg',
                        width: 42 * scale,
                        height: 28 * scale,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12 * scale),
              // Filter button
              GestureDetector(
                onTap: onFilterTap,
                child: Container(
                  height: 48 * scale,
                  padding: EdgeInsets.symmetric(horizontal: 12 * scale),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(40 * scale),
                    border: Border.all(
                      color: const Color(0xFFB3E8FF),
                      width: 2 * scale,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/images/home/filter_icon.svg',
                        width: 24 * scale,
                        height: 24 * scale,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF009AFF),
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 6 * scale),
                      Text(
                        'Tất cả',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14 * scale,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF667085),
                        ),
                      ),
                      SizedBox(width: 6 * scale),
                      // Dropdown arrow
                      CustomPaint(
                        size: Size(16 * scale, 10 * scale),
                        painter: DropdownArrowPainter(
                          color: const Color(0xFF009AFF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12 * scale),
              // Search button
              GestureDetector(
                onTap: onSearchTap,
                child: Container(
                  height: 48 * scale,
                  padding: EdgeInsets.all(12 * scale),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(40 * scale),
                    border: Border.all(
                      color: const Color(0xFFB3E8FF),
                      width: 2 * scale,
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/images/home/search_icon.svg',
                    width: 24 * scale,
                    height: 24 * scale,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF009AFF),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom painter cho dropdown arrow
class DropdownArrowPainter extends CustomPainter {
  final Color color;

  DropdownArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
