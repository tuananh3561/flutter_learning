/// Dữ liệu cho quy trình onboarding
class OnboardingData {
  final int? selectedYear;
  final LanguageLevel? selectedLevel;
  final LearningRoute? selectedRoute;

  const OnboardingData({
    this.selectedYear,
    this.selectedLevel,
    this.selectedRoute,
  });

  OnboardingData copyWith({
    int? selectedYear,
    LanguageLevel? selectedLevel,
    LearningRoute? selectedRoute,
  }) {
    return OnboardingData(
      selectedYear: selectedYear ?? this.selectedYear,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      selectedRoute: selectedRoute ?? this.selectedRoute,
    );
  }

  /// Kiểm tra onboarding đã hoàn thành chưa
  bool get isComplete =>
      selectedYear != null && selectedLevel != null && selectedRoute != null;

  /// Tính tuổi từ năm sinh
  int? get calculatedAge {
    if (selectedYear == null) return null;
    return DateTime.now().year - selectedYear!;
  }
}

/// Cấp độ tiếng Anh
enum LanguageLevel {
  beginner(
    title: 'Bé chưa biết gì về tiếng Anh',
    description: 'Hoàn toàn mới với tiếng Anh',
    progressBars: 1,
  ),
  elementary(
    title: 'Bé nhận biết được vài từ đơn giản',
    description: 'Biết một số từ vựng cơ bản',
    progressBars: 2,
  ),
  preIntermediate(
    title: 'Bé hiểu được câu ngắn, đơn giản',
    description: 'Hiểu được các câu đơn giản',
    progressBars: 3,
  ),
  intermediate(
    title: 'Bé đọc hiểu đoạn văn ngắn',
    description: 'Có thể đọc hiểu văn bản ngắn',
    progressBars: 4,
  );

  const LanguageLevel({
    required this.title,
    required this.description,
    required this.progressBars,
  });

  final String title;
  final String description;
  final int progressBars;
}

/// Lộ trình học tập
enum LearningRoute {
  starter(
    title: 'Chặng 1 - Khởi động',
    subtitle: 'Khởi động',
    description:
        'Chặng 1 dành cho trẻ mới làm quen với tiếng Anh hoặc biết một số từ vựng cơ bản.',
    color: 0xFFFFAE00,
    isActive: true,
  ),
  accelerate(
    title: 'Chặng 2 - Tăng tốc',
    subtitle: 'Tăng tốc',
    description: 'Phát triển vốn từ vựng và ngữ pháp cơ bản.',
    color: 0xFF63D3FF,
    isActive: false,
  ),
  strengthen(
    title: 'Chặng 3 - Vững vàng',
    subtitle: 'Vững vàng',
    description: 'Củng cố kiến thức và phát triển kỹ năng nghe nói.',
    color: 0xFF63D3FF,
    isActive: false,
  ),
  conquer(
    title: 'Chặng 4 - Chinh phục',
    subtitle: 'Chinh phục',
    description: 'Hoàn thiện kỹ năng và tự tin giao tiếp.',
    color: 0xFF63D3FF,
    isActive: false,
  );

  const LearningRoute({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    required this.isActive,
  });

  final String title;
  final String subtitle;
  final String description;
  final int color;
  final bool isActive;
}

/// Danh sách các năm sinh để chọn
class YearOfBirth {
  static List<int> getYearList() {
    final currentYear = DateTime.now().year;
    final years = <int>[];

    // Từ năm hiện tại về trước 15 năm (tương đương 2-17 tuổi)
    for (int year = currentYear - 2; year >= currentYear - 15; year--) {
      years.add(year);
    }

    return years;
  }

  static String getDisplayText(int year) {
    final age = DateTime.now().year - year;
    if (age <= 2) {
      return year.toString();
    }
    return year.toString();
  }

  static String getBeforeYearText() {
    final cutoffYear = DateTime.now().year - 15;
    return 'Sinh trước năm $cutoffYear';
  }
}
