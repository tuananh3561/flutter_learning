octopy_splash/
├── assets/
│   ├── audio/
│   │   ├── background_music.mp3
│   │   ├── correct_sound.mp3
│   │   ├── incorrect_sound.mp3
│   │   └── voice_over/  # Các file âm thanh đọc từ vựng
│   │       ├── bounce.mp3
│   │       ├── float.mp3
│   │       └── ...
│   ├── images/
│   │   ├── background.png
│   │   ├── cat/
│   │   │   ├── idle.png
│   │   │   ├── throwing.png
│   │   │   └── ...
│   │   ├── octopus/
│   │   │   ├── idle.png
│   │   │   ├── hit.png
│   │   │   └── ...
│   │   ├── water_balloon.png
│   │   ├── ui/ #các thành phần giao diện
│   │   │   ├── play_button.png
│   │   │   ├── skip_button.png
│   │   │   ├── mute_button.png
│   │   │   └── ...
│   │   └── ...
│   └── fonts/  # (Tùy chọn) Nếu bạn sử dụng font chữ tùy chỉnh
│       └── my_custom_font.ttf
├── lib/
│   ├── main.dart
│   ├── game/
│   │   ├── octopy_splash_game.dart  # Lớp chính của game (FlameGame)
│   │   ├── components/
│   │   │   ├── background.dart      # Component cho background
│   │   │   ├── cat.dart          # Component cho nhân vật mèo
│   │   │   ├── octopus.dart        # Component cho nhân vật bạch tuộc
│   │   │   ├── water_balloon.dart   # Component cho quả bóng nước
│   │   │   ├── word_display.dart    # Component hiển thị các lựa chọn từ
│   │   │   └── ...
│   │   ├── levels/
│   │   │   ├── level_1.dart
│   │   │   ├── level_2.dart # Dữ liệu từ màn 2
│   │   │   └── ...
│   │   ├── managers/   # (Tùy chọn) Quản lý trạng thái, âm thanh, v.v.
│   │   │    ├── game_manager.dart
│	   |	├── sound_manage.dart
│   │   │    └── ...
│   │   └── utils.dart           # Các hàm tiện ích (ví dụ: tạo chữ)
│   ├── screens/
│   │   ├── main_menu_screen.dart # Màn hình chính
│   │   ├── game_screen.dart     # Màn hình chơi game
│   │   ├── game_over_screen.dart # Màn hình khi hoàn thành/thua.
│   │   └── ...
│   └── widgets/ #tái sử dụng UI widgets.
│        ├── my_button.dart
│        └── ...
└── pubspec.yaml