import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/parent_data.dart';
import 'package:flutter_learning/presentation/screens/parent/parent_report_screen.dart';
import 'package:flutter_learning/presentation/screens/parent/parent_vip_screen.dart';
import 'package:flutter_learning/presentation/screens/parent/parent_settings_screen.dart';

/// Màn hình chính cho Parent Settings với tab navigation
class ParentMainScreen extends StatefulWidget {
  final ParentData? parentData;
  final bool showVipPurchased;

  const ParentMainScreen({
    super.key,
    this.parentData,
    this.showVipPurchased = false,
  });

  @override
  State<ParentMainScreen> createState() => _ParentMainScreenState();
}

class _ParentMainScreenState extends State<ParentMainScreen> {
  late ParentData _parentData;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    // Initialize data dựa trên parameter
    _parentData = widget.parentData ??
        (widget.showVipPurchased
            ? ParentData.getSampleDataWithVip()
            : ParentData.getSampleData());

    _pageController = PageController(
      initialPage: _parentData.currentTab.index,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Responsive scaling dựa trên kích thước Figma 428x926px
    final scale =
        math.min(size.width / 428.0, size.height / 926.0).clamp(0.8, 1.8);

    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      body: Column(
        children: [
          // Main content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                ParentReportScreen(reportData: _parentData.reportData),
                ParentVipScreen(vipData: _parentData.vipData),
                ParentSettingsScreen(settingsData: _parentData.settingsData),
              ],
            ),
          ),

          // Bottom tab bar
          _buildBottomTabBar(scale),
        ],
      ),
    );
  }

  /// Get background color dựa trên current tab
  Color _getBackgroundColor() {
    switch (_parentData.currentTab) {
      case ParentTab.report:
        return Color(0xFFF2F4F7);
      case ParentTab.vip:
      case ParentTab.settings:
        return Colors.white;
    }
  }

  /// Handle page change
  void _onPageChanged(int index) {
    setState(() {
      _parentData = _parentData.copyWith(
        currentTab: ParentTab.values[index],
      );
    });
  }

  /// Navigate to specific tab
  void _navigateToTab(ParentTab tab) {
    _pageController.animateToPage(
      tab.index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Build bottom tab bar
  Widget _buildBottomTabBar(double scale) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: Offset(0, -0.5 * scale),
            blurRadius: 20 * scale,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tab buttons
          Container(
            height: 49 * scale,
            child: Row(
              children: [
                SizedBox(width: 42 * scale),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTabItem(
                          scale, ParentTab.report, 'Báo cáo', Icons.bar_chart),
                      _buildTabItem(
                          scale, ParentTab.vip, 'Vip', Icons.workspace_premium),
                      _buildTabItem(
                          scale, ParentTab.settings, 'Cài đặt', Icons.settings),
                    ],
                  ),
                ),
                SizedBox(width: 42 * scale),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build individual tab item
  Widget _buildTabItem(
      double scale, ParentTab tab, String label, IconData icon) {
    final isActive = _parentData.currentTab == tab;
    final isVipTab = tab == ParentTab.vip;

    return GestureDetector(
      onTap: () => _navigateToTab(tab),
      child: Container(
        width: 75 * scale,
        height: 49 * scale,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 24 * scale,
              height: 24 * scale,
              child: _buildTabIcon(scale, tab, isActive),
            ),

            SizedBox(height: 7 * scale),

            // Label
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: 10 * scale,
                height: 1.364,
                letterSpacing: -0.024,
                color: isActive
                    ? (isVipTab ? Color(0xFF0077FF) : Color(0xFF0077FF))
                    : Color(0xFFAFAFAF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build tab icon dựa trên tab type và active state
  Widget _buildTabIcon(double scale, ParentTab tab, bool isActive) {
    Color iconColor = isActive ? Color(0xFF0077FF) : Color(0xFFAFAFAF);

    switch (tab) {
      case ParentTab.report:
        return _buildReportIcon(scale, iconColor, isActive);
      case ParentTab.vip:
        return _buildVipIcon(scale, iconColor, isActive);
      case ParentTab.settings:
        return _buildSettingsIcon(scale, iconColor, isActive);
    }
  }

  /// Build report tab icon
  Widget _buildReportIcon(double scale, Color color, bool isActive) {
    if (isActive) {
      // Active report icon (filled)
      return Container(
        width: 20 * scale,
        height: 20 * scale,
        child: Stack(
          children: [
            // Background shape
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2 * scale),
                ),
              ),
            ),
            // Inner elements could be added here for more detail
          ],
        ),
      );
    } else {
      // Inactive report icon (outline)
      return Icon(
        Icons.bar_chart_outlined,
        size: 24 * scale,
        color: color,
      );
    }
  }

  /// Build VIP tab icon
  Widget _buildVipIcon(double scale, Color color, bool isActive) {
    if (isActive) {
      // Active VIP icon (bold crown)
      return Container(
        width: 24 * scale,
        height: 24 * scale,
        child: Stack(
          children: [
            // Crown base
            Positioned(
              left: 6.25 * scale,
              top: 20.5 * scale,
              child: Container(
                width: 11.5 * scale,
                height: 1.5 * scale,
                color: color,
              ),
            ),
            // Crown top
            Positioned(
              left: 2.07 * scale,
              top: 2.23 * scale,
              child: Container(
                width: 19.86 * scale,
                height: 16.75 * scale,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2 * scale),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Inactive VIP icon (outline crown)
      return Icon(
        Icons.workspace_premium_outlined,
        size: 24 * scale,
        color: color,
      );
    }
  }

  /// Build settings tab icon
  Widget _buildSettingsIcon(double scale, Color color, bool isActive) {
    if (isActive) {
      // Active settings icon (filled)
      return Icon(
        Icons.settings,
        size: 24 * scale,
        color: color,
      );
    } else {
      // Inactive settings icon (outline)
      return Icon(
        Icons.settings_outlined,
        size: 24 * scale,
        color: color,
      );
    }
  }
}
