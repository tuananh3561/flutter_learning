/// Data models cho parent report theo JSON structure
class ParentReportData {
  final WeeklyReport weeklyReport;
  final TotalLearned totalLearned;
  final RecentWeeklyReport recentWeeklyReport;
  final Progress progress;
  final String stageFocusLearnToRead;
  final String stageFocusEarlyReader;

  const ParentReportData({
    required this.weeklyReport,
    required this.totalLearned,
    required this.recentWeeklyReport,
    required this.progress,
    required this.stageFocusLearnToRead,
    required this.stageFocusEarlyReader,
  });

  factory ParentReportData.fromJson(Map<String, dynamic> json) {
    return ParentReportData(
      weeklyReport: WeeklyReport.fromJson(json['WeeklyReport']),
      totalLearned: TotalLearned.fromJson(json['TotalLearned']),
      recentWeeklyReport:
          RecentWeeklyReport.fromJson(json['RecentWeeklyReport']),
      progress: Progress.fromJson(json['Progress']),
      stageFocusLearnToRead: json['StageFocusLearnToRead'],
      stageFocusEarlyReader: json['StageFocusEarlyReader'],
    );
  }

  /// Sample data cho demo
  static ParentReportData getSampleData() {
    return ParentReportData.fromJson({
      "WeeklyReport": {
        "General": {
          "TotalStory": 10,
          "TotalLesson": 20,
          "TotalVideo": 5,
          "AudioBook": 2,
          "TotalDuration": 3600
        },
        "Proportion": {
          "Level": {"A": 5, "B": 3, "C": 2}
        }
      },
      "TotalLearned": {
        "General": {
          "TotalStory": 100,
          "TotalLesson": 200,
          "TotalVideo": 50,
          "AudioBook": 20,
          "TotalDuration": 36000
        },
        "Proportion": {
          "Level": {"A": 50, "B": 30, "C": 20}
        }
      },
      "RecentWeeklyReport": {"W1": 120, "W2": 150, "W3": 100, "W4": 180},
      "Progress": {
        "Level": {
          "one": {"Current": 10, "Total": 20},
          "two": {"Current": 5, "Total": 25},
          "three": {"Current": 0, "Total": 30},
          "four": {"Current": 0, "Total": 15},
          "five": {"Current": 0, "Total": 10},
          "six": {"Current": 0, "Total": 10},
          "seven": {"Current": 0, "Total": 10}
        }
      },
      "StageFocusLearnToRead": "three",
      "StageFocusEarlyReader": "five"
    });
  }
}

class WeeklyReport {
  final GeneralStats general;
  final Proportion proportion;

  const WeeklyReport({
    required this.general,
    required this.proportion,
  });

  factory WeeklyReport.fromJson(Map<String, dynamic> json) {
    return WeeklyReport(
      general: GeneralStats.fromJson(json['General']),
      proportion: Proportion.fromJson(json['Proportion']),
    );
  }
}

class TotalLearned {
  final GeneralStats general;
  final Proportion proportion;

  const TotalLearned({
    required this.general,
    required this.proportion,
  });

  factory TotalLearned.fromJson(Map<String, dynamic> json) {
    return TotalLearned(
      general: GeneralStats.fromJson(json['General']),
      proportion: Proportion.fromJson(json['Proportion']),
    );
  }
}

class GeneralStats {
  final int totalStory;
  final int totalLesson;
  final int totalVideo;
  final int audioBook;
  final int totalDuration; // in seconds

  const GeneralStats({
    required this.totalStory,
    required this.totalLesson,
    required this.totalVideo,
    required this.audioBook,
    required this.totalDuration,
  });

  factory GeneralStats.fromJson(Map<String, dynamic> json) {
    return GeneralStats(
      totalStory: json['TotalStory'],
      totalLesson: json['TotalLesson'],
      totalVideo: json['TotalVideo'],
      audioBook: json['AudioBook'],
      totalDuration: json['TotalDuration'],
    );
  }

  /// Convert duration từ seconds sang phút
  int get totalDurationMinutes => (totalDuration / 60).round();
}

class Proportion {
  final LevelStats level;

  const Proportion({
    required this.level,
  });

  factory Proportion.fromJson(Map<String, dynamic> json) {
    return Proportion(
      level: LevelStats.fromJson(json['Level']),
    );
  }
}

class LevelStats {
  final int a;
  final int b;
  final int c;

  const LevelStats({
    required this.a,
    required this.b,
    required this.c,
  });

  factory LevelStats.fromJson(Map<String, dynamic> json) {
    return LevelStats(
      a: json['A'],
      b: json['B'],
      c: json['C'],
    );
  }

  /// Tính tổng
  int get total => a + b + c;

  /// Tính phần trăm cho từng level
  double get aPercentage => total > 0 ? (a / total * 100) : 0;
  double get bPercentage => total > 0 ? (b / total * 100) : 0;
  double get cPercentage => total > 0 ? (c / total * 100) : 0;
}

class RecentWeeklyReport {
  final int w1;
  final int w2;
  final int w3;
  final int w4;

  const RecentWeeklyReport({
    required this.w1,
    required this.w2,
    required this.w3,
    required this.w4,
  });

  factory RecentWeeklyReport.fromJson(Map<String, dynamic> json) {
    return RecentWeeklyReport(
      w1: json['W1'],
      w2: json['W2'],
      w3: json['W3'],
      w4: json['W4'],
    );
  }

  /// Lấy danh sách weeks
  List<int> get weeklyData => [w1, w2, w3, w4];

  /// Tính max value cho chart scale
  int get maxValue => [w1, w2, w3, w4].reduce((a, b) => a > b ? a : b);
}

class Progress {
  final ProgressLevel level;

  const Progress({
    required this.level,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      level: ProgressLevel.fromJson(json['Level']),
    );
  }
}

class ProgressLevel {
  final LevelProgress one;
  final LevelProgress two;
  final LevelProgress three;
  final LevelProgress four;
  final LevelProgress five;
  final LevelProgress six;
  final LevelProgress seven;

  const ProgressLevel({
    required this.one,
    required this.two,
    required this.three,
    required this.four,
    required this.five,
    required this.six,
    required this.seven,
  });

  factory ProgressLevel.fromJson(Map<String, dynamic> json) {
    return ProgressLevel(
      one: LevelProgress.fromJson(json['one']),
      two: LevelProgress.fromJson(json['two']),
      three: LevelProgress.fromJson(json['three']),
      four: LevelProgress.fromJson(json['four']),
      five: LevelProgress.fromJson(json['five']),
      six: LevelProgress.fromJson(json['six']),
      seven: LevelProgress.fromJson(json['seven']),
    );
  }

  /// Lấy tất cả levels dưới dạng list
  List<LevelProgress> get allLevels =>
      [one, two, three, four, five, six, seven];
}

class LevelProgress {
  final int current;
  final int total;

  const LevelProgress({
    required this.current,
    required this.total,
  });

  factory LevelProgress.fromJson(Map<String, dynamic> json) {
    return LevelProgress(
      current: json['Current'],
      total: json['Total'],
    );
  }

  /// Tính phần trăm hoàn thành
  double get percentage => total > 0 ? (current / total * 100) : 0;

  /// Kiểm tra xem level đã hoàn thành chưa
  bool get isCompleted => current >= total;
}
