import 'audio_service.dart';

/// Lớp khởi tạo tất cả các dịch vụ cần thiết cho ứng dụng
class ServicesInitializer {
  /// Singleton instance
  static final ServicesInitializer _instance = ServicesInitializer._internal();

  /// Factory constructor
  factory ServicesInitializer() {
    return _instance;
  }

  /// Internal constructor
  ServicesInitializer._internal();

  /// AudioService instance
  final AudioService _audioService = AudioService();

  /// Khởi tạo tất cả các dịch vụ
  Future<void> initializeAllServices() async {
    await _initializeAudioService();
    // Khởi tạo các dịch vụ khác ở đây
  }

  /// Khởi tạo dịch vụ âm thanh
  Future<void> _initializeAudioService() async {
    await _audioService.initialize();
  }

  /// Lấy instance của AudioService
  AudioService get audioService => _audioService;
}
