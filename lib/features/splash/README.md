# Splash Screen Implementation Structure

## 1. Core Layer Files

### 1.1 Storage
```
lib/core/storage/secure_storage.dart
```
- Quản lý lưu trữ bảo mật cho Device ID và authentication tokens
- Sử dụng flutter_secure_storage để bảo mật dữ liệu nhạy cảm

### 1.2 Network
```
lib/core/network/network_info.dart
```
- Kiểm tra trạng thái kết nối mạng
- Sử dụng internet_connection_checker để xác định trạng thái online/offline

### 1.3 Database
```
lib/core/storage/database/
├── app_database.dart
└── daos/
    └── device_info_dao.dart
```
- Quản lý local database sử dụng Floor/SQLite
- Lưu trữ thông tin Device ID và các thông tin local khác

## 2. Feature Layer Files

### 2.1 Data Layer
```
lib/features/splash/data/
├── datasources/
│   ├── splash_local_datasource.dart
│   └── splash_remote_datasource.dart
├── models/
│   └── device_info_model.dart
└── repositories/
    └── splash_repository_impl.dart
```
- **splash_local_datasource.dart**: Truy cập dữ liệu local (Device ID, first time flag)
- **splash_remote_datasource.dart**: Gọi API đăng ký Device ID
- **device_info_model.dart**: Model cho dữ liệu Device ID
- **splash_repository_impl.dart**: Implementation của repository pattern

### 2.2 Domain Layer
```
lib/features/splash/domain/
├── entities/
│   └── device_info.dart
├── repositories/
│   └── splash_repository.dart
└── usecases/
    ├── check_first_time_usecase.dart
    ├── get_device_id_usecase.dart
    ├── register_device_usecase.dart
    └── check_auth_status_usecase.dart
```
- **device_info.dart**: Entity class cho Device Info
- **splash_repository.dart**: Interface định nghĩa các method cần thiết
- **Các usecase**: Xử lý các business logic riêng biệt

### 2.3 Presentation Layer
```
lib/features/splash/presentation/
├── bloc/
│   ├── splash_bloc.dart
│   ├── splash_event.dart
│   └── splash_state.dart
├── screens/
│   └── splash_screen.dart
└── widgets/
    └── splash_content.dart
```
- **splash_bloc.dart**: Quản lý state cho splash screen
- **splash_screen.dart**: UI chính của splash screen
- **splash_content.dart**: Các widget con của splash screen

## 3. Shared Layer Files
```
lib/shared/
├── services/
│   └── device_info_service.dart
└── utils/
    └── device_utils.dart
```
- **device_info_service.dart**: Service xử lý logic liên quan đến Device ID
- **device_utils.dart**: Các utility function cho device info

## Luồng xử lý chính:

1. **Khởi động app**:
   - Splash Screen được hiển thị
   - BLoC emit LoadingState

2. **Kiểm tra kết nối**:
   - Sử dụng NetworkInfo
   - Xử lý các trường hợp offline

3. **Kiểm tra Device ID**:
   - Đọc từ local storage
   - Nếu chưa có, tạo mới và gọi API đăng ký

4. **Kiểm tra First Time**:
   - Đọc flag từ local storage
   - Quyết định navigation flow

5. **Kiểm tra Auth Status**:
   - Kiểm tra token trong secure storage
   - Quyết định màn hình đích

## Implementation Strategy:

1. **Step 1**: Implement Core Layer
   - Setup database
   - Setup secure storage
   - Setup network checking

2. **Step 2**: Implement Data Layer
   - Setup local data source
   - Setup remote data source
   - Implement repository

3. **Step 3**: Implement Domain Layer
   - Define entities
   - Create use cases
   - Setup repository interface

4. **Step 4**: Implement Presentation Layer
   - Setup BLoC
   - Create UI
   - Handle navigation