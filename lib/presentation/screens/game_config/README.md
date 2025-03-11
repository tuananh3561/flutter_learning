# Game Configuration Editor

## Tổng quan

Game Configuration Editor là module quản lý và chỉnh sửa cấu hình cho các trò chơi trong dự án "Story Nighty Night". Module này cho phép điều chỉnh vị trí, kích thước, và thuộc tính của các thành phần trong trò chơi như Question, Answer, DropZone, AnimSpine, và Sound.

## Kiến trúc

Module được thiết kế theo mô hình BLoC (Business Logic Component) để tách biệt rõ ràng giữa logic nghiệp vụ và UI:

```
game_config/
├── blocs/                      # Business Logic Components
│   ├── game_config_bloc.dart   # BLoC chính quản lý trạng thái
│   └── game_config_events.dart # Các event được gửi đến BLoC
├── models/                     # Data Models
│   └── game_config_model.dart  # Model dữ liệu cấu hình
├── widgets/                    # UI Components
│   ├── config_editor_panel.dart  # Panel chỉnh sửa cấu hình
│   ├── config_preview.dart       # Preview cấu hình trực quan
│   ├── feedback_message.dart     # Thông báo phản hồi
│   └── sections/                 # Các phần chỉnh sửa cấu hình
│       ├── answer_section.dart
│       ├── drop_zone_section.dart
│       ├── question_section.dart
│       └── ...
└── game_config_editor_screen.dart  # Màn hình chính
```

## Các cải tiến đã thực hiện

1. **Áp dụng mô hình BLoC**:
   - Tách biệt rõ ràng giữa logic nghiệp vụ và UI
   - Quản lý trạng thái tập trung, dễ theo dõi
   - Tối ưu hiệu suất re-render chỉ khi cần thiết

2. **Cải thiện UX/UI**:
   - Thêm animation khi cập nhật Preview
   - Feedback rõ ràng thông qua hệ thống thông báo
   - Hiển thị vị trí thành phần khi kéo thả

3. **Quản lý vị trí và kích thước**:
   - Kéo thả trực quan để điều chỉnh vị trí các thành phần
   - Cập nhật dữ liệu configuration khi kéo thả
   - Tooltip hiển thị tọa độ khi di chuyển

4. **Tối ưu hóa hiệu năng**:
   - Sử dụng `const` constructor và `equatable` để giảm build lại widget không cần thiết
   - Lazy loading các phần không cần thiết
   - Tách nhỏ widget để giảm thiểu việc vẽ lại toàn bộ UI

5. **Xử lý lỗi**:
   - Hiển thị thông báo lỗi phù hợp
   - Cơ chế phục hồi khi xảy ra lỗi
   - Logging chi tiết

## Hướng dẫn sử dụng

### Cập nhật Preview

Preview được cập nhật theo các cách sau:
1. **Tự động**: Khi kéo thả các thành phần trong preview
2. **Thủ công**: Nhấn nút "Cập nhật Preview" trong từng section hoặc nút "Update Preview" trên thanh công cụ

### Lưu cấu hình

Để lưu cấu hình, nhấn nút "Save" trên thanh công cụ. Hệ thống sẽ lưu cấu hình hiện tại và hiển thị thông báo xác nhận.

## Unit Tests

Module này được phát triển theo TDD (Test-Driven Development) với các test sau:
- Unit tests cho BLoC
- Widget tests cho UI
- Integration tests

Các test này đảm bảo tính ổn định và chất lượng của code khi phát triển thêm tính năng mới.

## Hướng phát triển tiếp theo

1. Thêm chức năng export/import cấu hình
2. Cải thiện trải nghiệm kéo thả với grid snap và alignment guides
3. Thêm tính năng undo/redo
4. Tối ưu hóa hiệu suất cho các cấu hình phức tạp 