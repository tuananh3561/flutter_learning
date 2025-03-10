import 'package:flutter/foundation.dart';

/// Class untuk mengelola daftar kosakata
class VocabularyRepository {
  /// Danh sách từ vựng
  final List<Map<String, dynamic>> _vocabularyList = [
    {
      'text': 'bird',
      'audio': '../../assets/audio/word/bird.mp3',
      'image': '../../assets/images/word/bird.png'
    },
    {
      'text': 'cat',
      'audio': '../../assets/audio/word/cat.mp3',
      'image': '../../assets/images/word/cat.png'
    },
    {
      'text': 'dog',
      'audio': '../../assets/audio/word/dog.mp3',
      'image': '../../assets/images/word/dog.png'
    },
    {
      'text': 'duck',
      'audio': '../../assets/audio/word/duck.mp3',
      'image': '../../assets/images/word/duck.png'
    },
    {
      'text': 'pig',
      'audio': '../../assets/audio/word/pig.mp3',
      'image': '../../assets/images/word/pig.png'
    },
    {
      'text': 'cow',
      'audio': '../../assets/audio/word/cow.mp3',
      'image': '../../assets/images/word/cow.png'
    },
    {
      'text': 'sheep',
      'audio': '../../assets/audio/word/sheep.mp3',
      'image': '../../assets/images/word/sheep.png'
    },
    {
      'text': 'horse',
      'audio': '../../assets/audio/word/horse.mp3',
      'image': '../../assets/images/word/horse.png'
    },
    {
      'text': 'frog',
      'audio': '../../assets/audio/word/frog.mp3',
      'image': '../../assets/images/word/frog.png'
    },
  ];

  /// Khởi tạo repository, tải dữ liệu nếu cần
  Future<void> initialize() async {
    // Trong tương lai có thể tải từ vựng từ API hoặc file JSON
    if (kDebugMode) {
      print(
          'VocabularyRepository initialized with ${_vocabularyList.length} words');
    }
  }

  /// Lấy danh sách từ vựng
  List<Map<String, dynamic>> getVocabularyList() {
    return List.from(_vocabularyList);
  }

  /// Lấy từ vựng theo text
  Map<String, dynamic>? getVocabularyByText(String text) {
    try {
      return _vocabularyList.firstWhere((vocab) => vocab['text'] == text);
    } catch (e) {
      return null;
    }
  }
}
