import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_learning/data/models/parent_data.dart';
import 'package:flutter_learning/presentation/screens/parent/components/profile_switch_modal.dart';

/// Màn hình báo cáo học tập cho phụ huynh
class ParentReportScreen extends StatefulWidget {
  final ParentReportData reportData;

  const ParentReportScreen({
    super.key,
    required this.reportData,
  });

  @override
  State<ParentReportScreen> createState() => _ParentReportScreenState();
}

class _ParentReportScreenState extends State<ParentReportScreen> {
  bool _showWeeklyData = true; // true = tuần này, false = tổng đã học
  bool _showAllLevels =
      false; // true = hiển thị tất cả levels, false = chỉ hiển thị 3 level đầu
  bool _showAllMonkeyPhonics =
      false; // true = hiển thị tất cả chặng Monkey Phonics, false = chỉ hiển thị 1 chặng
  bool _showAllReadingComprehension =
      false; // true = hiển thị tất cả chặng Reading Comprehension, false = chỉ hiển thị 1 chặng

  // Profile management
  late List<ProfileSwitchItem> _profiles;
  late ProfileSwitchItem _currentProfile;

  @override
  void initState() {
    super.initState();
    _initializeProfiles();
  }

  void _initializeProfiles() {
    _profiles = [
      ProfileSwitchItem(
        id: '1',
        name: 'Thanh Tâm',
        joinDate: 'Started from June 2022',
        avatarAsset: 'assets/images/profile/thanh_tam_avatar.png',
        isSelected: true,
      ),
      ProfileSwitchItem(
        id: '2',
        name: 'Trung Hiếu',
        joinDate: 'Started from October 2022',
        avatarAsset: 'assets/images/profile/trung_hieu_avatar.png',
        isSelected: false,
      ),
    ];
    _currentProfile = _profiles.firstWhere((p) => p.isSelected);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Responsive scaling dựa trên kích thước Figma 428x926px
    final scale =
        math.min(size.width / 428.0, size.height / 926.0).clamp(0.8, 1.8);

    return Scaffold(
      backgroundColor: Color(0xFFF2F4F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24 * scale),
            child: Column(
              children: [
                SizedBox(height: 24 * scale),

                // Header với profile info
                _buildProfileHeader(scale),

                SizedBox(height: 24 * scale),

                // Weekly chart
                _buildWeeklyChart(scale),

                SizedBox(height: 12 * scale),

                // Statistics cards
                _buildStatisticsCards(scale),

                SizedBox(height: 12 * scale),

                // Level chart
                _buildLevelChart(scale),

                SizedBox(height: 12 * scale),

                // Progress charts
                _buildProgressCharts(scale),

                SizedBox(height: 100 * scale), // Space for floating button
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(scale),
    );
  }

  /// Build profile header với avatar và thông tin
  Widget _buildProfileHeader(double scale) {
    return Container(
      padding: EdgeInsets.all(12 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * scale),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 132 * scale,
            height: 132 * scale,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(66 * scale),
              border: Border.all(
                color: Colors.black.withOpacity(0.08),
                width: 6 * scale,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60 * scale),
              child: Image.asset(
                _currentProfile.avatarAsset,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(width: 16 * scale),

          // Profile info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên và ngày tham gia
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentProfile.name,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w800,
                        fontSize: 20 * scale,
                        height: 1.5,
                        color: Color(0xFF4B4B4B),
                      ),
                    ),
                    SizedBox(height: 4 * scale),
                    Text(
                      _currentProfile.joinDate,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                        fontSize: 16 * scale,
                        height: 1.5,
                        color: Color(0xFFAFAFAF),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12 * scale),

                // Đổi hồ sơ button
                GestureDetector(
                  onTap: () => _showProfileSwitchModal(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20 * scale,
                      vertical: 8 * scale,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color(0xFFE5E5E5), width: 2 * scale),
                      borderRadius: BorderRadius.circular(12 * scale),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Đổi hồ sơ',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w800,
                            fontSize: 20 * scale,
                            height: 1.5,
                            color: Color(0xFFAFAFAF),
                          ),
                        ),
                        SizedBox(width: 8 * scale),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 24 * scale,
                          color: Color(0xFFAFAFAF),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build weekly chart
  Widget _buildWeeklyChart(double scale) {
    final weeklyData = widget.reportData.recentWeeklyReport.weeklyData;
    final maxValue = widget.reportData.recentWeeklyReport.maxValue.toDouble();

    return Container(
      padding: EdgeInsets.all(16 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20 * scale),
        boxShadow: [
          BoxShadow(
            color: Color(0x140D0A2C),
            offset: Offset(0, 2 * scale),
            blurRadius: 6 * scale,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thời lượng học 4 tuần gần nhất',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 20 * scale,
              height: 1.5,
              color: Color(0xFF333741),
            ),
          ),

          SizedBox(height: 24 * scale),

          // Chart
          SizedBox(
            height: 200 * scale,
            child: BarChart(
              BarChartData(
                maxY: maxValue * 1.2,
                barGroups: weeklyData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final value = entry.value.toDouble();
                  final isLatest = index == weeklyData.length - 1;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: value,
                        color: isLatest ? Color(0xFF0077FF) : Color(0xFFC9EAFF),
                        width: 26 * scale,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(4 * scale),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40 * scale,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}p',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          fontSize: 14 * scale,
                          color: Color(0xFFCECFD2),
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: maxValue / 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Color(0xFFECECED),
                    strokeWidth: 1.5 * scale,
                    dashArray: [4, 7],
                  ),
                  drawVerticalLine: false,
                ),
              ),
            ),
          ),

          SizedBox(height: 24 * scale),

          // Legend
          Column(
            children: [
              _buildLegendItem(
                  scale, Color(0xFF0077FF), 'Thời lượng học tuần này'),
              SizedBox(height: 6 * scale),
              _buildLegendItem(
                  scale, Color(0xFFC9EAFF), 'Thời lượng học các tuần trước'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(double scale, Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16 * scale,
          height: 16 * scale,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8 * scale),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w600,
            fontSize: 14 * scale,
            height: 1.0,
            color: Color(0xFF85888E),
          ),
        ),
      ],
    );
  }

  /// Build statistics cards (tuần này / tổng đã học)
  Widget _buildStatisticsCards(double scale) {
    return Container(
      padding: EdgeInsets.all(16 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20 * scale),
        boxShadow: [
          BoxShadow(
            color: Color(0x140D0A2C),
            offset: Offset(0, 2 * scale),
            blurRadius: 6 * scale,
          ),
        ],
      ),
      child: Column(
        children: [
          // Tuần này section
          _buildStatSection(scale, true),

          SizedBox(height: 24 * scale),

          // Tổng đã học section
          _buildStatSection(scale, false),
        ],
      ),
    );
  }

  Widget _buildStatSection(double scale, bool isWeekly) {
    final data = isWeekly
        ? widget.reportData.weeklyReport.general
        : widget.reportData.totalLearned.general;
    final title = isWeekly ? 'Tuần này' : 'Tổng đã học';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            fontSize: 20 * scale,
            height: 1.5,
            color: Color(0xFF333741),
          ),
        ),

        SizedBox(height: 12 * scale),

        // Divider
        Container(
          width: double.infinity,
          height: 1 * scale,
          color: Color(0xFFF5F5F6),
        ),

        SizedBox(height: 12 * scale),

        // Stats grid
        Column(
          children: [
            // Row 1: Truyện + Bài học
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    scale,
                    'assets/images/parent/book_icon.svg',
                    'Truyện',
                    data.totalStory.toString(),
                    Color(0xFF68AFFF),
                  ),
                ),
                SizedBox(width: 12 * scale),
                Expanded(
                  child: _buildStatItem(
                    scale,
                    'assets/images/parent/lesson_icon.svg',
                    'Bài học',
                    data.totalLesson.toString(),
                    Color(0xFF83D420),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12 * scale),

            // Row 2: Video + Sách nói
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    scale,
                    'assets/images/parent/video_icon.svg',
                    'Video',
                    data.totalVideo.toString(),
                    Color(0xFFFF8AD1),
                  ),
                ),
                SizedBox(width: 12 * scale),
                Expanded(
                  child: _buildStatItem(
                    scale,
                    'assets/images/parent/headphones_icon.svg',
                    'Sách nói',
                    data.audioBook.toString(),
                    Color(0xFFC08EFF),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12 * scale),

            // Row 3: Phút (full width)
            _buildStatItem(
              scale,
              'assets/images/parent/clock_icon.svg',
              'Phút',
              data.totalDurationMinutes.toString(),
              Color(0xFFFFB61C),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(double scale, String iconPath, String label,
      String value, Color bgColor) {
    return Container(
      padding: EdgeInsets.all(12 * scale),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12 * scale),
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 40 * scale,
            height: 40 * scale,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8 * scale),
            ),
            child: Center(
              child: SizedBox(
                width: 24 * scale,
                height: 24 * scale,
                child: SvgPicture.asset(
                  iconPath,
                  width: 24 * scale,
                  height: 24 * scale,
                  colorFilter: ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 12 * scale),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w900,
                    fontSize: 16 * scale,
                    height: 1.5,
                    color: Color(0xFF4B4B4B),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                    fontSize: 16 * scale,
                    height: 1.5,
                    color: Color(0xFF85888E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build level distribution chart (pie chart)
  Widget _buildLevelChart(double scale) {
    final levelData = _showWeeklyData
        ? widget.reportData.weeklyReport.proportion.level
        : widget.reportData.totalLearned.proportion.level;

    // Tạo data giả cho tất cả levels
    final allLevels = [
      {'name': 'Level A', 'count': levelData.a, 'color': Color(0xFF0077FF)},
      {'name': 'Level B', 'count': levelData.b, 'color': Color(0xFF66ADFF)},
      {'name': 'Level C', 'count': levelData.c, 'color': Color(0xFFB3D7FF)},
      {'name': 'Level D', 'count': 4, 'color': Color(0xFFB3D7FF)},
      {'name': 'Level E', 'count': 4, 'color': Color(0xFFB3D7FF)},
      {'name': 'Level F', 'count': 4, 'color': Color(0xFFB3D7FF)},
      {'name': 'Level G', 'count': 4, 'color': Color(0xFFB3D7FF)},
    ];

    // Chỉ hiển thị 3 level đầu hoặc tất cả tùy vào state
    final displayLevels =
        _showAllLevels ? allLevels : allLevels.take(3).toList();

    return Container(
      padding: EdgeInsets.all(16 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20 * scale),
        boxShadow: [
          BoxShadow(
            color: Color(0x140D0A2C),
            offset: Offset(0, 2 * scale),
            blurRadius: 6 * scale,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header với icon và title
          Row(
            children: [
              Container(
                width: 40 * scale,
                height: 40 * scale,
                decoration: BoxDecoration(
                  color: Color(0xFF68AFFF),
                  borderRadius: BorderRadius.circular(8 * scale),
                ),
                child: Center(
                  child: SizedBox(
                    width: 24 * scale,
                    height: 24 * scale,
                    child: SvgPicture.asset(
                      'assets/images/parent/book_icon.svg',
                      width: 24 * scale,
                      height: 24 * scale,
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12 * scale),
              Text(
                'Truyện đã đọc theo cấp độ',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w800,
                  fontSize: 20 * scale,
                  height: 1.5,
                  color: Color(0xFF333741),
                ),
              ),
            ],
          ),

          SizedBox(height: 12 * scale),

          // Divider
          Container(
            width: double.infinity,
            height: 1 * scale,
            color: Color(0xFFF5F5F6),
          ),

          SizedBox(height: 24 * scale),

          // Content area
          Column(
            children: [
              // Tab filters
              Container(
                padding: EdgeInsets.all(4 * scale),
                decoration: BoxDecoration(
                  color: Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(360 * scale),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _showWeeklyData = true),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16 * scale, vertical: 12 * scale),
                          decoration: BoxDecoration(
                            color: _showWeeklyData
                                ? Color(0xFF333741)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(360 * scale),
                          ),
                          child: Text(
                            'Tuần này',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 16 * scale,
                              height: 1.5,
                              color: _showWeeklyData
                                  ? Colors.white
                                  : Color(0xFF475467),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _showWeeklyData = false),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16 * scale, vertical: 12 * scale),
                          decoration: BoxDecoration(
                            color: !_showWeeklyData
                                ? Color(0xFF333741)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(360 * scale),
                          ),
                          child: Text(
                            'Tổng',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 16 * scale,
                              height: 1.5,
                              color: !_showWeeklyData
                                  ? Colors.white
                                  : Color(0xFF475467),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32 * scale),

              // Pie chart and legend
              Column(
                children: [
                  // Pie chart centered
                  Center(
                    child: SizedBox(
                      width: 220 * scale,
                      height: 220 * scale,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: levelData.aPercentage,
                              color: Color(0xFF0077FF),
                              radius: 110 * scale,
                              showTitle: true,
                              title: '${levelData.aPercentage.toInt()}%',
                              titleStyle: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                fontSize: 17 * scale,
                                color: Colors.white,
                              ),
                            ),
                            PieChartSectionData(
                              value: levelData.bPercentage,
                              color: Color(0xFF66ADFF),
                              radius: 110 * scale,
                              showTitle: true,
                              title: '${levelData.bPercentage.toInt()}%',
                              titleStyle: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                fontSize: 17 * scale,
                                color: Colors.white,
                              ),
                            ),
                            PieChartSectionData(
                              value: levelData.cPercentage,
                              color: Color(0xFFB3D7FF),
                              radius: 110 * scale,
                              showTitle: true,
                              title: '${levelData.cPercentage.toInt()}%',
                              titleStyle: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                fontSize: 17 * scale,
                                color: Colors.white,
                              ),
                            ),
                          ],
                          centerSpaceRadius: 0,
                          sectionsSpace: 2 * scale,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32 * scale),

                  // Legend list below pie chart
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60 * scale),
                    child: Column(
                      children: displayLevels.map((level) {
                        return Column(
                          children: [
                            _buildLevelLegendItem(
                              scale,
                              level['color'] as Color,
                              level['name'] as String,
                              '${level['count']} truyện',
                            ),
                            if (level != displayLevels.last)
                              SizedBox(height: 16 * scale),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 24 * scale),

          // Divider
          Container(
            width: double.infinity,
            height: 1 * scale,
            color: Color(0xFFF5F5F6),
          ),

          SizedBox(height: 12 * scale),

          // Xem thêm / Ẩn bớt button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => setState(() => _showAllLevels = !_showAllLevels),
                child: Row(
                  children: [
                    Text(
                      _showAllLevels ? 'Ẩn bớt' : 'Xem thêm',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        fontSize: 14 * scale,
                        color: Color(0xFF61646C),
                      ),
                    ),
                    SizedBox(width: 4 * scale),
                    Transform.rotate(
                      angle: _showAllLevels
                          ? -1.5708
                          : 0, // 90 degrees up if expanded
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16 * scale,
                        color: Color(0xFF61646C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLevelLegendItem(
      double scale, Color color, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side - dot and label
        Row(
          children: [
            Container(
              width: 16 * scale,
              height: 16 * scale,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8 * scale),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                fontSize: 14 * scale,
                color: Color(0xFF94969C),
              ),
            ),
          ],
        ),
        // Right side - value
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w600,
            fontSize: 14 * scale,
            color: Color(0xFF1F242F),
          ),
        ),
      ],
    );
  }

  /// Build progress charts for different levels
  Widget _buildProgressCharts(double scale) {
    // Data cho Monkey Phonics (3 chặng)
    final monkeyPhonicsSections = [
      {'title': 'Chặng 1', 'current': 24, 'total': 210, 'percentage': 12},
      {'title': 'Chặng 2', 'current': 24, 'total': 210, 'percentage': 12},
      {'title': 'Chặng 3', 'current': 24, 'total': 210, 'percentage': 12},
    ];

    // Data cho Reading Comprehension (4 chặng)
    final readingComprehensionSections = [
      {'title': 'Chặng 4', 'current': 24, 'total': 210, 'percentage': 12},
      {'title': 'Chặng 5', 'current': 24, 'total': 210, 'percentage': 12},
      {'title': 'Chặng 6', 'current': 24, 'total': 210, 'percentage': 12},
      {'title': 'Chặng 7', 'current': 24, 'total': 210, 'percentage': 12},
    ];

    // Luôn hiển thị cả 2 charts, mỗi chart có thể expand/collapse độc lập
    return Column(
      children: [
        _buildProgressChart(
          scale,
          'Monkey Phonics',
          'assets/images/parent/lesson_progress_icon.svg',
          monkeyPhonicsSections,
          _showAllMonkeyPhonics,
          () => setState(() => _showAllMonkeyPhonics = !_showAllMonkeyPhonics),
        ),
        SizedBox(height: 12 * scale),
        _buildProgressChart(
          scale,
          'Reading Comprehension',
          'assets/images/parent/student_icon.svg',
          readingComprehensionSections,
          _showAllReadingComprehension,
          () => setState(() =>
              _showAllReadingComprehension = !_showAllReadingComprehension),
        ),
      ],
    );
  }

  Widget _buildProgressChart(
      double scale,
      String title,
      String iconPath,
      List<Map<String, Object>> sections,
      bool isExpanded,
      VoidCallback onToggleExpanded) {
    return Container(
      width: 380 * scale,
      padding: EdgeInsets.all(16 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20 * scale),
        boxShadow: [
          BoxShadow(
            color: Color(0x140D0A2C),
            offset: Offset(0, 2 * scale),
            blurRadius: 6 * scale,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header với icon và title
          Row(
            children: [
              Container(
                width: 40 * scale,
                height: 40 * scale,
                decoration: BoxDecoration(
                  color: Color(0xFF83D420),
                  borderRadius: BorderRadius.circular(8 * scale),
                ),
                child: Center(
                  child: SizedBox(
                    width: 24 * scale,
                    height: 24 * scale,
                    child: SvgPicture.asset(
                      iconPath,
                      width: 24 * scale,
                      height: 24 * scale,
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12 * scale),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w800,
                  fontSize: 20 * scale,
                  height: 1.5,
                  color: Color(0xFF333741),
                ),
              ),
            ],
          ),

          SizedBox(height: 12 * scale),

          // Divider
          Container(
            width: double.infinity,
            height: 1 * scale,
            color: Color(0xFFF5F5F6),
          ),

          SizedBox(height: 24 * scale),

          // Progress sections - chỉ hiển thị section đầu tiên nếu không expanded
          Column(
            children: (isExpanded ? sections : sections.take(1).toList())
                .map((section) {
              final sectionsToShow =
                  isExpanded ? sections : sections.take(1).toList();
              final isLastSection = section == sectionsToShow.last;
              return Column(
                children: [
                  _buildProgressSection(scale, section),
                  if (!isLastSection) ...[
                    SizedBox(height: 24 * scale),
                    Container(
                      width: double.infinity,
                      height: 1 * scale,
                      color: Color(0xFFF5F5F6),
                    ),
                    SizedBox(height: 24 * scale),
                  ],
                ],
              );
            }).toList(),
          ),

          SizedBox(height: 24 * scale),

          // Divider cuối
          Container(
            width: double.infinity,
            height: 1 * scale,
            color: Color(0xFFF5F5F6),
          ),

          SizedBox(height: 12 * scale),

          // Xem thêm / Ẩn bớt button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onToggleExpanded,
                child: Row(
                  children: [
                    Text(
                      isExpanded ? 'Ẩn bớt' : 'Xem thêm',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        fontSize: 14 * scale,
                        color: Color(0xFF61646C),
                      ),
                    ),
                    SizedBox(width: 4 * scale),
                    Transform.rotate(
                      angle:
                          isExpanded ? -1.5708 : 0, // 90 degrees up if expanded
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16 * scale,
                        color: Color(0xFF61646C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(double scale, Map<String, Object> section) {
    final title = section['title'] as String;
    final current = section['current'] as int;
    final total = section['total'] as int;
    final percentage = section['percentage'] as int;
    final progressWidth = 48 * scale; // Fixed width từ Figma

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title và percentage
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w900,
                fontSize: 16 * scale,
                height: 1.5,
                color: Color(0xFF333741),
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                fontSize: 14 * scale,
                color: Color(0xFF61646C),
              ),
            ),
          ],
        ),

        SizedBox(height: 16 * scale),

        // Progress bar
        Row(
          children: [
            // Current progress (blue)
            Container(
              width: progressWidth,
              height: 16 * scale,
              decoration: BoxDecoration(
                color: Color(0xFF0077FF),
                borderRadius: BorderRadius.circular(4 * scale),
              ),
            ),
            SizedBox(width: 1 * scale),
            // Remaining progress (light blue)
            Expanded(
              child: Container(
                height: 16 * scale,
                decoration: BoxDecoration(
                  color: Color(0xFFE4F5FF),
                  borderRadius: BorderRadius.circular(4 * scale),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 16 * scale),

        // Current và total numbers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              current.toString(),
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                fontSize: 14 * scale,
                color: Color(0xFF61646C),
              ),
            ),
            Text(
              total.toString(),
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                fontSize: 12 * scale,
                color: Color(0xFF61646C),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build floating action button
  Widget _buildFloatingActionButton(double scale) {
    return Container(
      width: 80 * scale,
      height: 80 * scale,
      child: FloatingActionButton(
        onPressed: () {
          // TODO: Handle floating button action
        },
        backgroundColor: Color(0xFFFFBB00),
        child: Container(
          width: 32.89 * scale,
          height: 36 * scale,
          child: Image.asset(
            'assets/images/parent/play_icon.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  /// Show profile switch modal
  void _showProfileSwitchModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileSwitchModal(
        profiles: _profiles,
        onProfileSelected: _onProfileSelected,
      ),
    );
  }

  /// Handle profile selection
  void _onProfileSelected(ProfileSwitchItem selectedProfile) {
    setState(() {
      // Update profiles list
      _profiles = _profiles.map((profile) {
        return profile.copyWith(isSelected: profile.id == selectedProfile.id);
      }).toList();

      // Update current profile
      _currentProfile = selectedProfile;
    });
  }
}
