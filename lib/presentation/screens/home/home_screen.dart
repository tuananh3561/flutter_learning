import 'package:flutter/material.dart' hide CarouselController;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_learning/routes/navigation_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3A0CA3), // Deep purple background
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.landscape
              ? _buildLandscapeLayout(context)
              : _buildPortraitLayout(context);
        },
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          // _buildSideNavigation(),
          Expanded(
            child: Column(
              children: [
                _buildTopNavigation(context),
                Expanded(
                  child: _buildStoryCarousel(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildTopNavigation(context),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _buildSideNavigation(),
                Expanded(
                  child: _buildStoryCarousel(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNavigation(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          _buildActionButton(
            'UNLOCK ALL',
            Icons.lock_open,
            const Color(0xFFFF0066),
            () {
              // TODO: Implement unlock functionality
            },
          ),
          SizedBox(width: 16.w),
          _buildActionButton(
            'Progress',
            Icons.show_chart,
            const Color(0xFF06D6A0),
            () {
              // TODO: Implement progress functionality
            },
          ),
          SizedBox(width: 16.w),
          _buildActionButton(
            'Categories',
            Icons.grid_view,
            const Color(0xFF118AB2),
            () {
              // TODO: Implement categories functionality
            },
          ),
          SizedBox(width: 16.w),
          _buildActionButton(
            'Config Editor',
            Icons.settings,
            const Color(0xFFFFAA00),
            () {
              // Navigate to the game config editor
              NavigationService.navigateToGameConfigEditor(context);
            },
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30.r),
            ),
            padding: EdgeInsets.all(8.r),
            child: IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                // TODO: Implement search functionality
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String text, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildSideNavigation() {
    return Container(
      width: 80.w,
      color: const Color(0xFFF8EDEB),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          _buildCharacterIcon('🦎', Colors.green),
          SizedBox(height: 16.h),
          _buildCharacterIcon('🐯', Colors.orange),
          SizedBox(height: 16.h),
          _buildCharacterIcon('🐻', Colors.brown),
          SizedBox(height: 16.h),
          _buildCharacterIcon('🐰', Colors.grey),
          const Spacer(),
          _buildCharacterIcon('❤️', Colors.red),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildCharacterIcon(String emoji, Color backgroundColor) {
    return Container(
      width: 50.w,
      height: 50.w,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Center(
        child: Text(
          emoji,
          style: TextStyle(fontSize: 24.sp),
        ),
      ),
    );
  }

  Widget _buildStoryCarousel() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: CarouselSlider.builder(
        itemCount: 2, // Show only 2 cards as in the image
        options: CarouselOptions(
          height: double.infinity,
          viewportFraction: 0.8,
          enlargeCenterPage: true,
          enableInfiniteScroll: true,
          autoPlay: false,
        ),
        itemBuilder: (context, index, realIndex) {
          // Create different cards based on index
          if (index == 0) {
            return _buildWelcomeCard(context);
          } else {
            return _buildScienceCard(context);
          }
        },
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to StoryReaderScreen with welcome story ID
        NavigationService.navigateToStoryReader(context, 'welcome_story');
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: const Color(0xFF90E0EF),
            image: const DecorationImage(
              image: NetworkImage(
                  'https://picsum.photos/seed/flags/800/100'), // Hình ảnh từ assets
              fit: BoxFit.cover, // Cách hiển thị hình
            ), // Light blue background
          ),
          child: Stack(
            children: [
              // Welcome text
              Positioned(
                bottom: 40.h,
                left: 20.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Let\'s start from here',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Gift box icon
              Positioned(
                bottom: 20.h,
                right: 20.w,
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.card_giftcard,
                    size: 24.sp,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScienceCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to StoryReaderScreen with science story ID
        NavigationService.navigateToStoryReader(context, 'science_story');
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE0AAFF),
                Color(0xFFC77DFF),
              ],
            ),
            image: const DecorationImage(
              image: NetworkImage(
                  'https://picsum.photos/seed/science/300/500'), // Hình ảnh từ assets
              fit: BoxFit.cover, // Cách hiển thị hình
            ),
          ),
          child: Stack(
            children: [
              // Text content
              Positioned(
                bottom: 40.h,
                left: 20.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Science or Magic',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Science Experiments',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterImage(String imageUrl, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
