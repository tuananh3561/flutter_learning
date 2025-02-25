# Onboarding Screen Implementation Structure

## 1. Implementation Structure

### 1.1 Data Layer
```
lib/features/onboarding/data/
├── datasources/
│   └── onboarding_local_datasource.dart    # Manages local storage for onboarding state
├── models/
│   └── onboarding_item_model.dart          # Data model for onboarding content
└── repositories/
    └── onboarding_repository_impl.dart      # Implementation of onboarding repository
```

**File Purposes:**
- `onboarding_local_datasource.dart`: Manages first-time launch flag and onboarding completion status
- `onboarding_item_model.dart`: Defines structure for onboarding content including title, description, image
- `onboarding_repository_impl.dart`: Implements repository pattern for onboarding data management

### 1.2 Domain Layer
```
lib/features/onboarding/domain/
├── entities/
│   └── onboarding_item.dart                # Business entity for onboarding item
├── repositories/
│   └── onboarding_repository.dart          # Repository interface
└── usecases/
    ├── get_onboarding_items_usecase.dart   # Get onboarding content
    ├── check_first_time_usecase.dart       # Check if first launch
    └── complete_onboarding_usecase.dart    # Mark onboarding as complete
```

**File Purposes:**
- `onboarding_item.dart`: Core business entity defining onboarding content structure
- `onboarding_repository.dart`: Defines contract for data operations
- `get_onboarding_items_usecase.dart`: Business logic for fetching onboarding content
- `check_first_time_usecase.dart`: Logic for checking first-time app launch
- `complete_onboarding_usecase.dart`: Logic for marking onboarding completion

### 1.3 Presentation Layer
```
lib/features/onboarding/presentation/
├── bloc/
│   ├── onboarding_bloc.dart                # State management
│   ├── onboarding_event.dart               # Events for state changes
│   └── onboarding_state.dart               # States for UI
├── screens/
│   └── onboarding_screen.dart              # Main onboarding screen
└── widgets/
    ├── onboarding_page.dart                # Individual page widget
    ├── page_indicator.dart                 # Page indicator dots
    └── onboarding_button.dart              # Navigation buttons
```

**File Purposes:**
- `onboarding_bloc.dart`: Manages state and business logic for onboarding flow
- `onboarding_event.dart`: Defines all possible events in onboarding flow
- `onboarding_state.dart`: Defines all possible states of onboarding screen
- `onboarding_screen.dart`: Main screen widget with PageView
- `onboarding_page.dart`: Individual page template
- `page_indicator.dart`: Custom dots indicator
- `onboarding_button.dart`: Custom navigation buttons

## 2. Dependencies Required

### 2.1 Core Dependencies
```yaml
dependencies:
  flutter_bloc: ^8.1.3         # State management
  get_it: ^7.6.4              # Dependency injection
  shared_preferences: ^2.2.2   # Local storage
  equatable: ^2.0.5           # Value equality

dev_dependencies:
  bloc_test: ^9.1.4           # Testing BLoC
  mockito: ^5.4.2             # Mocking for tests
  build_runner: ^2.4.6        # Code generation
```

### 2.2 Asset Dependencies
```yaml
flutter:
  assets:
    - assets/images/onboarding/
    - assets/icons/
```

## 3. Testing Structure

### 3.1 Unit Tests
```
test/features/onboarding/
├── data/
│   ├── datasources/
│   │   └── onboarding_local_datasource_test.dart
│   └── repositories/
│       └── onboarding_repository_impl_test.dart
├── domain/
│   └── usecases/
│       ├── get_onboarding_items_usecase_test.dart
│       ├── check_first_time_usecase_test.dart
│       └── complete_onboarding_usecase_test.dart
└── presentation/
    └── bloc/
        └── onboarding_bloc_test.dart
```

### 3.2 Widget Tests
```
test/features/onboarding/presentation/
├── screens/
│   └── onboarding_screen_test.dart
└── widgets/
    ├── onboarding_page_test.dart
    ├── page_indicator_test.dart
    └── onboarding_button_test.dart
```

### 3.3 Integration Tests
```
integration_test/
└── onboarding_flow_test.dart
```

## 4. Luồng xử lý chính

1. **Khởi động Onboarding**:
   - Kiểm tra first-time flag
   - Load onboarding content
   - Initialize PageController
   - Setup BLoC

2. **Xử lý Page Navigation**:
   - Swipe gesture handling
   - Button navigation
   - Page indicator updates
   - Progress tracking

3. **Hoàn thành Onboarding**:
   - Save completion status
   - Navigate to next screen (Login/Register)
   - Clean up resources

4. **Error Handling**:
   - Asset loading errors
   - Storage errors
   - Navigation errors

## 5. Implementation Strategy

### Phase 1: Setup & Infrastructure
1. Add required dependencies
2. Create file structure
3. Setup basic routing

### Phase 2: Data Layer
1. Implement LocalDataSource
2. Create OnboardingItemModel
3. Implement Repository

### Phase 3: Domain Layer
1. Create OnboardingItem entity
2. Define Repository interface
3. Implement UseCases

### Phase 4: Presentation Layer
1. Implement BLoC
2. Create base widgets
3. Build main screen
4. Add animations

### Phase 5: Testing & Refinement
1. Write unit tests
2. Add widget tests
3. Create integration tests
4. Performance optimization

### Phase 6: Documentation & Cleanup
1. Add documentation
2. Code cleanup
3. Review performance
4. Final testing