import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Screen for the Feed the Shark game
class FeedTheSharkScreen extends StatefulWidget {
  /// Constructor
  const FeedTheSharkScreen({Key? key}) : super(key: key);

  @override
  State<FeedTheSharkScreen> createState() => _FeedTheSharkScreenState();
}

class _FeedTheSharkScreenState extends State<FeedTheSharkScreen> {
  @override
  void initState() {
    super.initState();
    // Force landscape orientation for the game
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog before exiting the game
        final bool shouldPop = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Bạn có muốn thoát khỏi trò chơi không?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Không'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Có'),
                  ),
                ],
              ),
            ) ??
            false;

        return shouldPop;
      },
      child: Scaffold(
        backgroundColor: Colors.blue[900],
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),
                    Icon(
                      Icons.info_outline,
                      size: 60.sp,
                      color: Colors.amber,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Feed the Shark',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Trò chơi này cần Spine 2D Animations',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Game Feed the Shark sử dụng thư viện Spine 2D Animation, một công cụ chuyên nghiệp để tạo hiệu ứng chuyển động dành cho game. Để trò chơi hoạt động đúng cách, cần phải:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildRequirementCard(
                      icon: Icons.folder_outlined,
                      title: 'Chuẩn bị file Spine',
                      description:
                          'File Spine animation cần được xuất ra đúng định dạng và đặt trong thư mục assets.',
                    ),
                    SizedBox(height: 8.h),
                    _buildRequirementCard(
                      icon: Icons.key_outlined,
                      title: 'License hợp lệ',
                      description:
                          'Spine Runtime yêu cầu license hợp lệ để sử dụng trong ứng dụng thương mại.',
                    ),
                    SizedBox(height: 8.h),
                    _buildRequirementCard(
                      icon: Icons.integration_instructions_outlined,
                      title: 'Cấu hình thư viện',
                      description:
                          'Thư viện flame_spine phải được cấu hình đúng cách với phiên bản Spine runtime tương thích.',
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Cấu trúc file yêu cầu:',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '- assets/Feed the Shark/shark/4.1-3.8/\n  ├─ shark.atlas\n  ├─ shark.json\n  └─ shark.png\n',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontFamily: 'monospace',
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            '- assets/Feed the Shark/ca nho 1/4.1-3.8/\n  ├─ ca nho 1.atlas\n  ├─ ca nho 1.json\n  └─ ca nho 1.png',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontFamily: 'monospace',
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: EdgeInsets.symmetric(
                            horizontal: 32.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Quay lại',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white24,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24.sp,
            color: Colors.amber,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
