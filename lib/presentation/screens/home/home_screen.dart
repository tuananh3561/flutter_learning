import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_learning/routes/navigation_service.dart';
import 'dart:math' as math;

import '../../../data/models/home_data.dart';
import 'components/story_grid.dart';
import 'components/video_grid.dart';
import 'components/audiobook_grid.dart';
import 'components/home_tab_navigation.dart';

/// Màn hình Home chính theo thiết kế Figma
/// Kích thước: 926x692px tablet layout
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeData _homeData;
  late ScrollController _scrollController;
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _homeData = HomeDataDemo.defaultData;
    _scrollController = ScrollController();
    _scrollController.addListener(_updateScrollProgress);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollProgress() {
    if (_scrollController.hasClients) {
      final progress =
          _scrollController.offset / _scrollController.position.maxScrollExtent;
      setState(() {
        _scrollProgress = progress.clamp(0.0, 1.0);
      });
    }
  }

  void _onTabChanged(int index) {
    setState(() {
      _homeData = _homeData.copyWith(
        activeTabIndex: index,
        tabs: _homeData.tabs.asMap().entries.map((entry) {
          return entry.value.copyWith(isActive: entry.key == index);
        }).toList(),
      );
    });
  }

  /// Tạo content grid based on active tab
  Widget _buildContentGrid(double scale) {
    switch (_homeData.activeTabIndex) {
      case 0: // Story tab
        return _buildStoryGrid(scale);
      case 1: // Video tab
        return _buildVideoGrid(scale);
      case 2: // Audiobook tab
        return _buildAudiobookGrid(scale);
      case 3: // Lesson tab
        return _buildStoryGrid(scale); // Temporarily use story grid
      default:
        return _buildStoryGrid(scale);
    }
  }

  /// Tạo video grid
  Widget _buildVideoGrid(double scale) {
    return VideoGrid(
      videos: _homeData.videos,
      onVideoTap: _onVideoTap,
      onFavoriteTap: _onVideoFavoriteTap,
      scrollController: _scrollController,
      scale: scale,
    );
  }

  /// Tạo audiobook grid
  Widget _buildAudiobookGrid(double scale) {
    return AudiobookGrid(
      audiobooks: _homeData.audiobooks,
      onAudiobookTap: _onAudiobookTap,
      onFavoriteTap: _onAudiobookFavoriteTap,
      scrollController: _scrollController,
      scale: scale,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Responsive scaling theo kích thước Figma: 926x692
    final scale =
        math.min(size.width / 926.0, size.height / 692.0).clamp(0.8, 1.8);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _buildBackgroundDecoration(),
        child: Stack(
          children: [
            // Background blur effects
            _buildBackgroundBlurEffects(scale),
            // Main content
            Column(
              children: [
                // Top navigation bar
                _buildTopNavigationBar(scale),

                // Tab navigation
                HomeTabNavigation(
                  tabs: _homeData.tabs,
                  activeTabIndex: _homeData.activeTabIndex,
                  onTabChanged: _onTabChanged,
                ),

                SizedBox(height: 24 * scale),

                // Content grid based on active tab
                Expanded(
                  child: _buildContentGrid(scale),
                ),
              ],
            ),
            // Navigation back button
            _buildNavigationButton(scale),
            // Scroll indicator
            _buildScrollIndicator(scale),
          ],
        ),
      ),
    );
  }

  /// Tạo background decoration với gradient
  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF009AFF),
          Color(0xFF0088DD),
          Color(0xFF0077CC),
        ],
      ),
    );
  }

  /// Tạo background blur effects
  Widget _buildBackgroundBlurEffects(double scale) {
    return Stack(
      children: [
        // Blur circle 1
        Positioned(
          left: 401 * scale,
          top: 508 * scale,
          child: Container(
            width: 248 * scale,
            height: 248 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF009AFF).withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF009AFF).withOpacity(0.1),
                  blurRadius: 93 * scale,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        ),
        // Blur circle 2
        Positioned(
          left: 30 * scale,
          top: 834 * scale,
          child: Container(
            width: 279 * scale,
            height: 279 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF009AFF).withOpacity(0.3),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF009AFF).withOpacity(0.3),
                  blurRadius: 93 * scale,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        ),
        // Blur circle 3
        Positioned(
          left: 842 * scale,
          top: 889 * scale,
          child: Container(
            width: 279 * scale,
            height: 279 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF009AFF).withOpacity(0.3),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF009AFF).withOpacity(0.3),
                  blurRadius: 93 * scale,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        ),
        // Blur circle 4
        Positioned(
          left: 873 * scale,
          top: 117 * scale,
          child: Container(
            width: 285 * scale,
            height: 285 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF009AFF).withOpacity(0.2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF009AFF).withOpacity(0.2),
                  blurRadius: 93 * scale,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        ),
        // Blur circle 5
        Positioned(
          left: 0 * scale,
          top: 0 * scale,
          child: Container(
            width: 359 * scale,
            height: 358 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF009AFF).withOpacity(0.2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF009AFF).withOpacity(0.2),
                  blurRadius: 93 * scale,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Tạo top navigation bar theo thiết kế Figma
  Widget _buildTopNavigationBar(double scale) {
    return Container(
      width: 926 * scale,
      height: 68 * scale,
      padding:
          EdgeInsets.symmetric(horizontal: 20 * scale, vertical: 8 * scale),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left section với avatar và tabs
          Row(
            children: [
              // Avatar với menu icon overlay
              Container(
                width: 60 * scale,
                height: 60 * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3 * scale),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4 * scale,
                      offset: Offset(0, 2 * scale),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 2 * scale,
                      offset: Offset(0, -2 * scale),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Avatar image
                    Container(
                      width: 60 * scale,
                      height: 60 * scale,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 3.75 * scale,
                            spreadRadius: 0,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/home/avatar_placeholder.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Menu icon overlay
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 18.44 * scale,
                        height: 18.44 * scale,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF009AFF),
                          border:
                              Border.all(color: Colors.white, width: 2 * scale),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/home/menu_icon.svg',
                            width: 7.68 * scale,
                            height: 6.15 * scale,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 24 * scale),
              // Tab navigation
              _buildTabNavigation(scale),
            ],
          ),
          // Right section với VIP và actions
          Row(
            children: [
              // VIP Button
              GestureDetector(
                onTap: _onVipTap,
                child: Container(
                  height: 48 * scale,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0077FF),
                    borderRadius: BorderRadius.circular(48 * scale),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20 * scale),
                        child: Text(
                          'Mở khóa VIP',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w900,
                            fontSize: 20 * scale,
                            height: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 12 * scale),
                      Container(
                        width: 42 * scale,
                        height: 28 * scale,
                        margin: EdgeInsets.only(right: 12 * scale),
                        child: SvgPicture.asset(
                          'assets/images/home/crown_icon.svg',
                          width: 42 * scale,
                          height: 28 * scale,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12 * scale),
              // Filter Button
              GestureDetector(
                onTap: _onFilterTap,
                child: Container(
                  width: 132 * scale,
                  height: 48 * scale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40 * scale),
                    border: Border.all(
                        color: const Color(0xFFB3E8FF), width: 2 * scale),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Filter icon
                      Container(
                        width: 24 * scale,
                        height: 24 * scale,
                        margin: EdgeInsets.only(left: 12 * scale),
                        child: Stack(
                          children: [
                            Positioned(
                              left: 4 * scale,
                              top: 4 * scale,
                              child: Container(
                                width: 16 * scale,
                                height: 16 * scale,
                                child: Stack(
                                  children: [
                                    // Filter bars
                                    Positioned(
                                      left: 0,
                                      top: 10.67 * scale,
                                      child: Container(
                                        width: 5.33 * scale,
                                        height: 5.33 * scale,
                                        color: const Color(0xFF009AFF),
                                      ),
                                    ),
                                    Positioned(
                                      left: 5.33 * scale,
                                      top: 5.33 * scale,
                                      child: Container(
                                        width: 5.33 * scale,
                                        height: 10.67 * scale,
                                        color: const Color(0xFF009AFF),
                                      ),
                                    ),
                                    Positioned(
                                      left: 10.67 * scale,
                                      top: 0,
                                      child: Container(
                                        width: 5.33 * scale,
                                        height: 16 * scale,
                                        color: const Color(0xFF009AFF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // "Tất cả" text
                      Text(
                        'Tất cả',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w800,
                          fontSize: 14 * scale,
                          height: 1.857,
                          color: const Color(0xFF667085),
                        ),
                      ),
                      // Dropdown arrow
                      Container(
                        width: 16 * scale,
                        height: 10 * scale,
                        margin: EdgeInsets.only(right: 12 * scale),
                        child: CustomPaint(
                          painter: DropdownArrowPainter(
                            color: const Color(0xFF009AFF),
                            scale: scale,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12 * scale),
              // Search Button
              GestureDetector(
                onTap: _onSearchTap,
                child: Container(
                  width: 48 * scale,
                  height: 48 * scale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40 * scale),
                    border: Border.all(
                        color: const Color(0xFFB3E8FF), width: 2 * scale),
                  ),
                  child: Center(
                    child: Container(
                      width: 24 * scale,
                      height: 24 * scale,
                      child: Stack(
                        children: [
                          // Search icon
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 21.65 * scale,
                              height: 21.65 * scale,
                              child: SvgPicture.asset(
                                'assets/images/home/search_icon.svg',
                                width: 21.65 * scale,
                                height: 21.65 * scale,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF009AFF),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          // Search handle
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 11.3 * scale,
                              height: 11.3 * scale,
                              child: SvgPicture.asset(
                                'assets/images/home/search_icon.svg',
                                width: 11.3 * scale,
                                height: 11.3 * scale,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF009AFF),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  /// Tạo tab navigation với 4 tabs
  Widget _buildTabNavigation(double scale) {
    final tabs = [
      {
        'icon': 'assets/images/home/book_icon.svg',
        'label': 'Truyện',
        'active': _homeData.activeTabIndex == 0
      },
      {
        'icon': 'assets/images/home/video_icon.svg',
        'label': 'Video',
        'active': _homeData.activeTabIndex == 1
      },
      {
        'icon': 'assets/images/home/audiobook_icon.svg',
        'label': 'Sách nói',
        'active': _homeData.activeTabIndex == 2
      },
      {
        'icon': 'assets/images/home/lesson_icon.svg',
        'label': 'Lộ trình',
        'active': _homeData.activeTabIndex == 3
      },
    ];

    return Row(
      children: tabs.asMap().entries.map((entry) {
        final index = entry.key;
        final tab = entry.value;
        final isActive = tab['active'] as bool;

        return GestureDetector(
          onTap: () => _onTabChanged(index),
          child: Container(
            width: 48 * scale,
            height: 48 * scale,
            margin: EdgeInsets.only(
                right: index < tabs.length - 1 ? 20 * scale : 0),
            child: Stack(
              children: [
                // Active background gradient
                if (isActive)
                  Positioned(
                    left: -10 * scale,
                    top: -10 * scale,
                    child: Container(
                      width: 68 * scale,
                      height: 68 * scale,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.4),
                            const Color(0xFF009AFF).withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                // Tab icon
                Center(
                  child: SvgPicture.asset(
                    tab['icon'] as String,
                    width: 24 * scale,
                    height: 24 * scale,
                    colorFilter: ColorFilter.mode(
                      isActive ? const Color(0xFF009AFF) : Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                // Active label
                if (isActive)
                  Positioned(
                    left: -6.5 * scale,
                    bottom: -6.5 * scale,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.33 * scale,
                        vertical: 4.67 * scale,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD7EFFF),
                        borderRadius: BorderRadius.circular(46.67 * scale),
                        border: Border.all(
                            color: Colors.white, width: 1.17 * scale),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 2 * scale,
                            offset: Offset(0, 2 * scale),
                          ),
                        ],
                      ),
                      child: Text(
                        tab['label'] as String,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                          fontSize: 14 * scale,
                          height: 1.143,
                          color: const Color(0xFF009AFF),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Tạo story grid
  Widget _buildStoryGrid(double scale) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 67 * scale),
      child: StoryGrid(
        stories: _getFilteredStories(),
        onStoryTap: _onStoryTap,
        onFavoriteTap: _onFavoriteTap,
        scrollController: _scrollController,
        scale: scale,
      ),
    );
  }

  /// Tạo navigation button
  Widget _buildNavigationButton(double scale) {
    return Positioned(
      left: 439 * scale,
      bottom: 72 * scale,
      child: GestureDetector(
        onTap: _onBackTap,
        child: Container(
          width: 48 * scale,
          height: 48 * scale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border:
                Border.all(color: const Color(0xFF009AFF), width: 1.33 * scale),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 4 * scale,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/images/home/arrow_left.svg',
              width: 26.67 * scale,
              height: 26.67 * scale,
              colorFilter: const ColorFilter.mode(
                Color(0xFF009AFF),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Tạo scroll indicator
  Widget _buildScrollIndicator(double scale) {
    return Positioned(
      right: 12 * scale,
      top: 92 * scale,
      child: Container(
        width: 4 * scale,
        height: 508 * scale,
        decoration: BoxDecoration(
          color: const Color(0xFF6DC5FF).withOpacity(0.2),
          borderRadius: BorderRadius.circular(40 * scale),
        ),
        child: Stack(
          children: [
            Positioned(
              top: _scrollProgress * (508 - 40) * scale,
              child: Container(
                width: 4 * scale,
                height: 40 * scale,
                decoration: BoxDecoration(
                  color: const Color(0xFF6DC5FF),
                  borderRadius: BorderRadius.circular(40 * scale),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Lấy danh sách stories theo tab hiện tại
  List<StoryItem> _getFilteredStories() {
    return _homeData.stories;
  }

  /// Xử lý tap video
  void _onVideoTap(VideoItem video) {
    if (video.type == VideoItemType.vipOverlay && !_homeData.isVipUnlocked) {
      _showVipVideoDialog(video);
      return;
    }
    // Handle video playback
    // TODO: Implement video playback
  }

  /// Xử lý tap favorite cho video
  void _onVideoFavoriteTap(VideoItem video) {
    setState(() {
      final updatedVideos = _homeData.videos.map((v) {
        if (v.id == video.id) {
          return v.copyWith(isFavorite: !v.isFavorite);
        }
        return v;
      }).toList();
      _homeData = _homeData.copyWith(videos: updatedVideos);
    });
  }

  /// Xử lý tap audiobook
  void _onAudiobookTap(AudiobookItem audiobook) {
    if (audiobook.type == AudiobookItemType.vipOverlay &&
        !_homeData.isVipUnlocked) {
      _showVipAudiobookDialog(audiobook);
      return;
    }
    // Handle audiobook playback
    // TODO: Implement audiobook playback
  }

  /// Xử lý tap favorite cho audiobook
  void _onAudiobookFavoriteTap(AudiobookItem audiobook) {
    setState(() {
      final updatedAudiobooks = _homeData.audiobooks.map((a) {
        if (a.id == audiobook.id) {
          return a.copyWith(isFavorite: !a.isFavorite);
        }
        return a;
      }).toList();
      _homeData = _homeData.copyWith(audiobooks: updatedAudiobooks);
    });
  }

  /// Xử lý tap story
  void _onStoryTap(StoryItem story) {
    if (story.type != StoryItemType.free && !_homeData.isVipUnlocked) {
      _showVipDialog(story);
      return;
    }
    NavigationService.navigateToStoryReader(context, story.id);
  }

  /// Xử lý tap favorite
  void _onFavoriteTap(StoryItem story) {
    setState(() {
      final updatedStories = _homeData.stories.map((s) {
        if (s.id == story.id) {
          return s.copyWith(isFavorite: !s.isFavorite);
        }
        return s;
      }).toList();
      _homeData = _homeData.copyWith(stories: updatedStories);
    });
  }

  /// Xử lý tap VIP
  void _onVipTap() {
    _showVipPurchaseDialog();
  }

  /// Xử lý tap filter
  void _onFilterTap() {
    _showFilterOptions();
  }

  /// Xử lý tap search
  void _onSearchTap() {
    _showSearchDialog();
  }

  /// Xử lý tap back
  void _onBackTap() {
    Navigator.of(context).pop();
  }

  /// Hiển thị dialog VIP required
  void _showVipDialog(StoryItem story) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('VIP Required'),
        content: Text('${story.title} requires VIP membership to access.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _onVipTap();
            },
            child: const Text('Get VIP'),
          ),
        ],
      ),
    );
  }

  /// Hiển thị dialog VIP required cho video
  void _showVipVideoDialog(VideoItem video) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('VIP Required'),
        content: Text('${video.title} requires VIP membership to access.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _onVipTap();
            },
            child: const Text('Get VIP'),
          ),
        ],
      ),
    );
  }

  /// Hiển thị dialog VIP required cho audiobook
  void _showVipAudiobookDialog(AudiobookItem audiobook) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('VIP Required'),
        content: Text('${audiobook.title} requires VIP membership to access.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _onVipTap();
            },
            child: const Text('Get VIP'),
          ),
        ],
      ),
    );
  }

  /// Hiển thị VIP purchase dialog
  void _showVipPurchaseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('VIP Membership'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Unlock all premium content with VIP membership!'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _homeData = _homeData.copyWith(isVipUnlocked: true);
                });
              },
              child: const Text('Unlock VIP - \$9.99/month'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  /// Hiển thị filter options
  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Filter Options',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.all_inclusive),
              title: const Text('All Stories'),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.free_breakfast),
              title: const Text('Free Stories'),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('VIP Stories'),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorites'),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  /// Hiển thị search dialog
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Stories'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter story name...',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            // Implement search logic
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}

/// Custom painter để vẽ dropdown arrow
class DropdownArrowPainter extends CustomPainter {
  final Color color;
  final double scale;

  DropdownArrowPainter({required this.color, required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(16 * scale, 0);
    path.lineTo(8 * scale, 10 * scale);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
