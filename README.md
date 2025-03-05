# Project name

Story Nighty Night – 1000 Câu truyện Chúc Ngủ ngon

# Target

- Cung cấp một bộ sưu tập 1000 câu truyện nhẹ nhàng, dễ hiểu cho trẻ nhỏ.
- Giúp bé thư giãn, tạo điều kiện thuận lợi cho giấc ngủ ngon và kích thích trí tưởng tượng, phát triển ngôn ngữ.
- Hỗ trợ phụ huynh theo dõi và quản lý trải nghiệm đọc truyện của con.

# Features App:

## Onboarding:

- Màn hình chào mừng với hình ảnh ấm áp và lời giới thiệu nhẹ nhàng về ứng dụng.
- Hướng dẫn sử dụng đơn giản, kèm hình minh họa, tùy chọn cài đặt (ngôn ngữ, âm thanh, chế độ bảo mật cho phụ huynh).

## Home (List Story):

- Giao diện chính trình bày danh sách truyện dưới dạng carousel (dãy ngang) theo chế độ landscape.
- Mỗi card truyện bao gồm thumbnail minh họa, tiêu đề truyện và biểu tượng “yêu thích”.
- Hỗ trợ swipe gesture và điều hướng bằng mũi tên (nếu cần).

## Read Story:

- Màn hình đọc truyện được thiết kế để hiển thị nội dung truyện tranh và anime với trải nghiệm xem mượt mà.
- Các chức năng phóng to, chuyển trang và hỗ trợ đọc bằng giọng nói (Text-to-Speech) giúp bé dễ dàng theo dõi nội dung.

## Multi Post-Story Games:

Tích hợp nhiều trò chơi tương tác được thiết kế theo nội dung câu truyện, khuyến khích bé vận dụng kiến thức và phát triển tư duy sáng tạo sau khi đọc truyện.

## Login/Signup:

- Cho phép đăng ký, đăng nhập nhanh chóng bằng số điện thoại, hỗ trợ xác thực an toàn và dễ dàng cho cả trẻ em (với sự giám sát của phụ huynh).

## Setting:

- Phần cài đặt dành riêng cho phụ huynh, cho phép điều chỉnh các tùy chọn như chế độ đọc (ví dụ: chế độ ban đêm), kiểm soát truy cập, ngăn chặn mua hàng trong ứng dụng và các thiết lập bảo mật khác.

## Report:

- Màn hình báo cáo giúp phụ huynh theo dõi kết quả hoạt động của trẻ, như số giờ đọc, trò chơi đã chơi, tiến độ học tập và các chỉ số quan trọng khác.
- Báo cáo được trình bày trực quan qua biểu đồ, bảng số liệu, nhằm cung cấp thông tin hữu ích về sự phát triển của trẻ.

# Tổng Quan Về Đối Tượng Người Dùng
## Trẻ nhỏ:
- Là người dùng chính, tập trung vào việc duyệt và đọc truyện (truyện tranh, anime) và sau đó tham gia các trò chơi tương tác sau truyện.
- Giao diện dành cho trẻ nhỏ sẽ được tối giản, hình ảnh minh họa sống động, các thao tác dễ thực hiện bằng cử chỉ (swipe, chạm) và phản hồi trực quan để tạo cảm giác vui vẻ, thư giãn.
## Phụ huynh:
- Chỉ giúp tạo và quản lý profile, đăng nhập (qua số điện thoại) và khi vào mục dành riêng cho phụ huynh, họ có thêm các chức năng quản lý như Report (theo dõi hoạt động của trẻ, số giờ đọc, trò chơi đã chơi, …) và Settings (cài đặt giới hạn, bảo mật, điều chỉnh chế độ đọc,…).


# Danh Sách Màn Hình & Flow Chính
## A. Flow của Trẻ Nhỏ:
### Onboarding (Màn hình giới thiệu):
- Giới thiệu nhẹ nhàng với hình ảnh ấm áp, hướng dẫn cách sử dụng ứng dụng cho bé.
### Home (List Story - Dạng Carousel):
- Hiển thị danh sách các câu truyện dưới dạng dãy ngang (carousel).
- Mỗi card truyện bao gồm thumbnail minh họa, tiêu đề và icon đánh dấu “yêu thích”.
- Bé có thể sử dụng gesture swipe để duyệt qua danh sách.
### Read Story:
- Khi bé chọn 1 truyện từ danh sách, chuyển sang màn hình đọc truyện.
- Màn hình này hiển thị nội dung truyện (ảnh, văn bản, audio hỗ trợ TTS nếu có) với các chức năng chuyển trang, phóng to/thu nhỏ.
### Multi Post-Story Games:
- Sau khi đọc xong, bé được chuyển đến màn hình game liên quan đến nội dung truyện vừa đọc.
- Các trò chơi được thiết kế đơn giản, vui nhộn, phù hợp với nội dung câu chuyện và khuyến khích bé vận dụng kiến thức một cách sáng tạo.
## B. Flow của Phụ Huynh:
### Login/Signup:
- Phụ huynh đăng nhập bằng số điện thoại để tạo/điền profile.
- Quy trình xác thực đơn giản, an toàn.
### Parent Dashboard (Profile dành cho Phụ Huynh):
- Sau khi đăng nhập, phụ huynh có thể truy cập vào giao diện - riêng dành cho họ.
### Report:
- Màn hình báo cáo hiển thị các chỉ số hoạt động của bé (số giờ đọc, trò chơi đã chơi, tiến độ,…), trình bày qua biểu đồ hoặc bảng số liệu trực quan.
### Settings:
- Màn hình cài đặt cho phụ huynh cho phép điều chỉnh các tùy chọn như: chế độ đọc (ban ngày/ban đêm), giới hạn thời gian sử dụng, các thiết lập bảo mật và kiểm soát nội dung dành cho bé.


# Use Case Diagram:

```
%% Use Case Diagram for Story Nighty Night App
graph LR;
    %% Actors
    ChildUser((Trẻ nhỏ))
    ParentUser((Phụ huynh))
    
    %% Use Cases dành cho trẻ nhỏ
    A[Browse Stories]
    B[Read Story]
    C[Multi Post-Story Games]
    D[Mark as Favorite]
    
    %% Use Cases dành cho phụ huynh
    E[Login/Signup]
    F[Manage Profile]
    G[View Report]
    H[Adjust Settings]
    
    %% Child User flows
    ChildUser --> A
    ChildUser --> B
    ChildUser --> C
    ChildUser --> D
    
    %% Parent User flows
    ParentUser --> E
    ParentUser --> F
    ParentUser --> G
    ParentUser --> H
    
    %% Hệ thống xử lý các use case
    A --- S[System]
    B --- S
    C --- S
    D --- S
    E --- S
    F --- S
    G --- S
    H --- S
```
## Giải thích sơ đồ:
### Trẻ nhỏ (Child User):

- Browse Stories: Bé duyệt qua danh sách các câu truyện (hiển thị dưới dạng carousel).
- Read Story: Khi bé chọn 1 câu truyện, chuyển sang màn hình đọc truyện (truyện tranh/anime).
- Multi Post-Story Games: Sau khi đọc, bé được chuyển đến các trò chơi tương tác dựa trên nội dung câu truyện.
- - Mark as Favorite: Bé có thể đánh dấu các câu truyện yêu thích.

### Phụ huynh (Parent User):

Login/Signup: Phụ huynh đăng nhập/đăng ký bằng số điện thoại.
Manage Profile: Quản lý thông tin cá nhân của phụ huynh và hồ sơ của bé.
- View Report: Xem báo cáo hoạt động của trẻ (giờ đọc, trò chơi đã chơi, tiến độ,…).
- Adjust Settings: Điều chỉnh cài đặt liên quan đến bảo mật, giới hạn và chế độ đọc cho bé.

### System: Hệ thống 
- Hệ thống sẽ xử lý tất cả các tác vụ, đảm bảo các use case hoạt động mượt mà.

# Technical Requirements
## Frontend:
- Flutter : Sử dụng Flutter để xây dựng giao diện người dùng.
## Engine game:
- Flame-engine : Sử dụng Flame-engine để xây dựng các trò chơi tương tác và hiệu ứng. (Read Story and Multi Post-Story Games)
## Technical
Multilingual support
Clean Architecture or Layered Architecture

# Project Structure

```
lib/
├── core/                     # Core functionality and utilities
│   ├── constants/            # App constants, theme data, etc.
│   ├── errors/               # Error handling
│   ├── network/              # Network services
│   ├── storage/              # Local storage services
│   └── utils/                # Utility functions
│
├── data/                     # Data layer
│   ├── datasources/          # Remote and local data sources
│   │   ├── local/            # Local data sources
│   │   └── remote/           # Remote API data sources
│   ├── models/               # Data models
│   └── repositories/         # Repository implementations
│
├── domain/                   # Domain layer
│   ├── entities/             # Business entities
│   ├── repositories/         # Repository interfaces
│   └── usecases/             # Business logic use cases
│
├── presentation/             # Presentation layer
│   ├── blocs/                # State management
│   ├── common/               # Common widgets
│   └── screens/              # App screens
│       ├── onboarding/       # Onboarding screens
│       ├── home/             # Home screen with story carousel
│       ├── story_reader/     # Story reading interface
│       ├── games/            # Post-story games
│       ├── auth/             # Login/signup screens
│       ├── parent/           # Parent dashboard
│       │   ├── reports/      # Child activity reports
│       │   └── settings/     # App settings
│       └── profile/          # User profile
│
├── games/                    # Game engine components
│   ├── engine/               # Flame engine setup
│   ├── components/           # Reusable game components
│   └── games/                # Individual games
│
├── l10n/                     # Localization resources
├── config/                   # App configuration
├── routes/                   # App navigation
└── main.dart                 # App entry point
```

# Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # UI Components
  flutter_svg: ^2.0.5         # SVG rendering
  cached_network_image: ^3.2.3 # Image caching
  carousel_slider: ^4.2.1      # Carousel for story list
  lottie: ^2.3.2              # Animation support
  flutter_screenutil: ^5.7.0   # Responsive UI
  
  # State Management
  flutter_bloc: ^8.1.2         # BLoC pattern implementation
  equatable: ^2.0.5            # Value equality
  
  # Navigation
  go_router: ^7.0.0            # Declarative routing
  
  # Storage
  shared_preferences: ^2.1.0    # Local storage
  sqflite: ^2.2.8+4            # SQLite database
  path_provider: ^2.0.14        # File system access
  
  # Network
  dio: ^5.1.1                  # HTTP client
  connectivity_plus: ^3.0.3     # Network connectivity
  
  # Game Engine
  flame: ^1.7.3                # 2D game engine
  flame_audio: ^1.4.0           # Audio support for games
  
  # Authentication
  firebase_auth: ^4.4.2         # Phone authentication
  firebase_core: ^2.10.0        # Firebase core
  
  # Analytics & Reporting
  fl_chart: ^0.62.0             # Charts for reports
  firebase_analytics: ^10.2.1   # User analytics
  
  # Localization
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0                # Internationalization
  
  # Utilities
  logger: ^1.3.0                # Logging
  permission_handler: ^10.2.0   # Permission management
  flutter_tts: ^3.6.3           # Text-to-speech
  
  # Testing
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.1             # BLoC testing
  mockito: ^5.4.0               # Mocking for tests
  flutter_lints: ^2.0.1         # Linting rules
```

# Implementation Strategy

## 1. Phân Chia Giai Đoạn Phát Triển

### Giai Đoạn 1: Thiết Lập Nền Tảng & Kiến Trúc
- Thiết lập kiến trúc Clean Architecture
- Cấu hình routing và navigation
- Thiết lập hệ thống đa ngôn ngữ
- Xây dựng theme và design system

### Giai Đoạn 2: Phát Triển Tính Năng Cốt Lõi
- Màn hình Onboarding
- Home screen với carousel hiển thị danh sách truyện
- Màn hình đọc truyện cơ bản
- Hệ thống đánh dấu yêu thích

### Giai Đoạn 3: Tích Hợp Flame Engine & Trò Chơi
- Thiết lập Flame engine
- Phát triển các trò chơi tương tác đơn giản
- Tích hợp trò chơi với nội dung truyện

### Giai Đoạn 4: Hệ Thống Xác Thực & Quản Lý
- Đăng nhập/đăng ký qua số điện thoại
- Màn hình quản lý dành cho phụ huynh
- Báo cáo hoạt động của trẻ
- Cài đặt và tùy chỉnh

### Giai Đoạn 5: Hoàn Thiện & Tối Ưu
- Tối ưu hiệu suất
- Kiểm thử toàn diện
- Chuẩn bị triển khai

## 2. Chiến Lược Phát Triển

### Kiến Trúc Ứng Dụng
- **Clean Architecture**: Phân tách rõ ràng giữa các layer (Presentation, Domain, Data) để dễ bảo trì và mở rộng.
- **BLoC Pattern**: Sử dụng BLoC cho state management, giúp tách biệt UI và business logic.

### Quản Lý Dữ Liệu
- **Repository Pattern**: Trừu tượng hóa nguồn dữ liệu, cho phép chuyển đổi giữa API và local storage.
- **Caching Strategy**: Lưu trữ truyện đã đọc để sử dụng offline và tối ưu hiệu suất.

### UI/UX
- **Responsive Design**: Sử dụng flutter_screenutil để đảm bảo UI hiển thị tốt trên nhiều kích thước màn hình.
- **Landscape Mode**: Tối ưu hóa trải nghiệm đọc truyện ở chế độ landscape.
- **Animation**: Sử dụng Lottie và các animation có sẵn của Flutter để tạo trải nghiệm sinh động.

### Game Development
- **Component-Based Design**: Thiết kế các game component có thể tái sử dụng.
- **Game-Story Integration**: Liên kết nội dung trò chơi với nội dung truyện.

### Đa Ngôn Ngữ
- **Internationalization**: Sử dụng flutter_localizations và intl để hỗ trợ đa ngôn ngữ.
- **Resource Management**: Tổ chức tài nguyên ngôn ngữ theo cấu trúc dễ mở rộng.

### Testing Strategy
- **Unit Tests**: Kiểm thử các use case và repository.
- **Widget Tests**: Kiểm thử các component UI riêng lẻ.
- **Integration Tests**: Kiểm thử luồng người dùng end-to-end.

## 3. Kỹ Thuật Triển Khai

### Flame Engine Integration
- Tích hợp Flame vào Flutter app thông qua FlameGame widget
- Sử dụng Flame Audio cho hiệu ứng âm thanh trong game
- Thiết kế các game component tái sử dụng

### Offline Support
- Lưu trữ truyện đã đọc trong SQLite
- Caching assets và hình ảnh
- Đồng bộ hóa dữ liệu khi có kết nối

### Performance Optimization
- Lazy loading cho danh sách truyện
- Tối ưu hóa asset loading
- Memory management cho game components

### Security
- Secure storage cho thông tin đăng nhập
- Parental controls với mã PIN
- Safe browsing cho trẻ em

## 4. Công Cụ & Quy Trình

### Development Workflow
- Git flow cho quản lý mã nguồn
- CI/CD pipeline cho automated testing và deployment
- Code review và quality checks

### Monitoring & Analytics
- Firebase Analytics để theo dõi hành việc người dùng
- Crash reporting
- Performance monitoring