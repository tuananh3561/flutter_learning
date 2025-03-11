# Contributing to Game Configuration Editor

Cảm ơn bạn đã quan tâm đến việc đóng góp cho module Game Configuration Editor! Tài liệu này cung cấp hướng dẫn về cách đóng góp và bảo trì module.

## Cài đặt môi trường phát triển

1. Đảm bảo bạn đã cài đặt Flutter SDK phiên bản 3.10.0 trở lên
2. Clone repository và cài đặt dependencies:
   ```bash
   flutter pub get
   ```
3. Tạo các file mock cần thiết cho unit test:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## Nguyên tắc phát triển

### Kiến trúc

Game Configuration Editor được xây dựng theo mô hình BLoC, với các nguyên tắc sau:

1. **Separation of Concerns**:
   - `blocs/`: Chứa tất cả logic nghiệp vụ
   - `widgets/`: Chứa các UI components
   - `models/`: Chứa các model dữ liệu

2. **Dependency Injection**:
   - Sử dụng BlocProvider để cung cấp BLoC cho các widget
   - Tránh tạo instance trực tiếp của BLoC trong widget

3. **Immutability**:
   - State là immutable, không thay đổi trực tiếp
   - Tạo state mới thông qua events

### Quy tắc code

1. **Formatting**:
   - Tuân thủ quy tắc format của Dart/Flutter
   - Sử dụng `flutter format .` trước khi commit

2. **Linting**:
   - Tuân thủ các quy tắc của linter
   - Không vô hiệu hóa linter trừ khi có lý do hợp lý

3. **Naming Conventions**:
   - Class: PascalCase
   - Variables, methods: camelCase 
   - Private fields/methods: _camelCase
   - Constants: kConstantName hoặc CONSTANT_NAME

4. **Comments và Documentation**:
   - Thêm docstring cho tất cả class và public methods
   - Comment code phức tạp

## Testing

### Unit Tests

Unit tests tập trung vào logic nghiệp vụ, đặc biệt là BLoC:

```bash
flutter test test/presentation/screens/game_config/blocs/game_config_bloc_test.dart
```

### Widget Tests

Widget tests kiểm tra tính chính xác của UI và tương tác giữa UI và BLoC:

```bash
flutter test test/presentation/screens/game_config/game_config_editor_screen_test.dart
```

### Integration Tests

Integration tests kiểm tra tương tác giữa các phần của module:

```bash
flutter test integration_test/game_config_editor_test.dart
```

### Test Coverage

Để đo lường test coverage:

```bash
flutter test --coverage
flutter pub run test_coverage # Yêu cầu cài đặt package test_coverage
```

## Quy trình pull request

1. Tạo branch mới cho tính năng hoặc fix: `feature/ten-tinh-nang` hoặc `fix/ten-issue`
2. Viết tests cho tính năng mới
3. Implement tính năng
4. Đảm bảo tất cả tests pass
5. Format code và fix linting issues
6. Tạo pull request với mô tả chi tiết về thay đổi

## Tối ưu hiệu năng

Khi phát triển, hãy chú ý đến hiệu năng:

1. Sử dụng `const` constructors khi có thể
2. Tránh rebuild UI không cần thiết
3. Sử dụng các widget hiệu suất cao như `ListView.builder`
4. Tránh tính toán phức tạp trong build method
5. Sử dụng `equatable` cho classes trong BLoC pattern để so sánh hiệu quả

## Xử lý phụ thuộc

Module này có những phụ thuộc sau:

- `flutter_bloc`: Quản lý state và tách biệt logic nghiệp vụ
- `equatable`: So sánh object hiệu quả
- `mockito` và `bloc_test`: Phục vụ unit testing

Khi thêm phụ thuộc mới:
1. Đánh giá sự cần thiết của package
2. Kiểm tra license và tính ổn định
3. Cập nhật documentation này

## Hỗ trợ

Nếu bạn có câu hỏi hoặc gặp vấn đề, vui lòng tạo issue mới hoặc liên hệ team lead. 