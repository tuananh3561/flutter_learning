import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_learning/data/models/story_content_model.dart';
import 'package:flutter_learning/presentation/screens/story_reader/widgets/page_flip_widget.dart';
import 'package:flutter_learning/presentation/screens/story_reader/widgets/story_page_widget.dart';

class StoryReaderScreen extends StatefulWidget {
  final String storyId;

  const StoryReaderScreen({Key? key, required this.storyId}) : super(key: key);

  @override
  State<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends State<StoryReaderScreen> {
  late Future<StoryData> _storyDataFuture;
  final PageController _pageController = PageController();
  final _pageFlipWidgetKey = GlobalKey<YouPageFlipWidgetState>();
  int _currentPage = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Force landscape orientation for the story reader
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _loadStoryData();
  }

  @override
  void dispose() {
    // Reset orientation when leaving the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadStoryData() async {
    setState(() {
      _isLoading = true;
    });

    _storyDataFuture = _loadStory(widget.storyId);

    setState(() {
      _isLoading = false;
    });
  }

  Future<StoryData> _loadStory(String storyId) async {
    // Extract the story folder ID from the storyId parameter
    // For now, we're using a hardcoded path for the demo
    final String storyFolderPath = 'assets/story/4063_1_3927';

    // Load the root.json file
    final String rootJsonString =
        await rootBundle.loadString('$storyFolderPath/root.json');
    final StoryRootModel rootData =
        await StoryRootModel.fromJsonString(rootJsonString);
    // Load all page files
    final List<StoryPageModel> pages = [];

    // Determine how many pages to load by checking the files in the assets
    // For now, we'll assume 10 pages based on the directory listing
    for (int i = 1; i <= 10; i++) {
      try {
        final String pageJsonString =
            await rootBundle.loadString('$storyFolderPath/4063_1_$i.json');
        final StoryPageModel pageData =
            await StoryPageModel.fromJsonString(pageJsonString);
        pages.add(pageData);
      } catch (e) {
        print('Error loading page $i: $e');
        // Stop loading pages if we encounter an error
        break;
      }
    }

    return StoryData(root: rootData, pages: pages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : FutureBuilder<StoryData>(
                future: _storyDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading story: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data!.pages.isEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)?.noStoryData ??
                            'No story data available',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final storyData = snapshot.data!;
                  return Column(
                    children: [
                      // Top navigation bar
                      _buildTopBar(context, storyData),

                      // Story content
                      Expanded(
                        child: PageFlipWidget(
                          key: _pageFlipWidgetKey,
                          controller: _pageController,
                          pageCount: storyData.pages.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return StoryPageWidget(
                              page: storyData.pages[index],
                              storyRoot: storyData.root,
                              basePath: 'assets/story/4063_1_3927',
                            );
                          },
                        ),
                      ),

                      // Bottom navigation bar
                      _buildBottomBar(context, storyData),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, StoryData storyData) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
      color: Colors.black.withOpacity(0.5),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 16),
            onPressed: () => Navigator.of(context).pop(),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              storyData.root.titleText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 8.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border,
                color: Colors.white, size: 16),
            onPressed: () {
              // TODO: Implement favorite functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.volume_up, color: Colors.white, size: 16),
            onPressed: () {
              // TODO: Implement audio control
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, StoryData storyData) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
      color: Colors.black.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Page navigation
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.white, size: 16),
                onPressed: _currentPage > 0
                    ? () {
                        _pageFlipWidgetKey.currentState?.previousPage();
                        // _pageController.previousPage(
                        //   duration: const Duration(milliseconds: 300),
                        //   curve: Curves.easeInOut,
                        // );
                      }
                    : null,
              ),
              Text(
                '${_currentPage + 1}/${storyData.pages.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 6.sp,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 16),
                onPressed: _currentPage < storyData.pages.length - 1
                    ? () {
                        _pageFlipWidgetKey.currentState?.nextPage();
                        // _pageController.nextPage(
                        //   duration: const Duration(milliseconds: 300),
                        //   curve: Curves.easeInOut,
                        // );
                      }
                    : null,
              ),
            ],
          ),

          // Additional controls
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.zoom_in, color: Colors.white, size: 16),
                onPressed: () {
                  // TODO: Implement zoom functionality
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white, size: 16),
                onPressed: () {
                  // TODO: Implement settings
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Helper class to hold the story data
class StoryData {
  final StoryRootModel root;
  final List<StoryPageModel> pages;

  StoryData({required this.root, required this.pages});
}
