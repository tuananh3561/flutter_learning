# Login Screen Implementation Structure

## 1. Implementation Structure

### 1.1 Data Layer
```
lib/features/auth/data/
├── datasources/
│   ├── auth_remote_datasource.dart    # Handle API calls for authentication
│   └── auth_local_datasource.dart     # Manage local storage for auth data
├── models/
│   ├── login_request_model.dart       # Request model for login API
│   ├── login_response_model.dart      # Response model from login API
│   └── user_model.dart               # User data model
└── repositories/
    └── auth_repository_impl.dart      # Implementation of auth repository
```

**File Purposes:**
- `auth_remote_datasource.dart`: Handles all API calls related to authentication
- `auth_local_datasource.dart`: Manages token storage and user data persistence
- `login_request_model.dart`: Defines the structure for login API request
- `login_response_model.dart`: Defines the structure for login API response
- `user_model.dart`: Data model for user information
- `auth_repository_impl.dart`: Implements repository pattern for auth operations

### 1.2 Domain Layer
```
lib/features/auth/domain/
├── entities/
│   └── user.dart                     # User entity for business logic
├── repositories/
│   └── auth_repository.dart          # Repository interface
└── usecases/
    ├── login_usecase.dart           # Login business logic
    ├── validate_phone_usecase.dart   # Phone validation logic
    └── store_auth_token_usecase.dart # Token storage logic
```

**File Purposes:**
- `user.dart`: Core business entity defining user data structure
- `auth_repository.dart`: Defines contract for authentication operations
- `login_usecase.dart`: Contains login business logic
- `validate_phone_usecase.dart`: Handles phone number validation
- `store_auth_token_usecase.dart`: Manages authentication token storage

### 1.3 Presentation Layer
```
lib/features/auth/presentation/
├── bloc/
│   ├── login_bloc.dart              # State management for login
│   ├── login_event.dart             # Login events
│   └── login_state.dart             # Login states
├── screens/
│   └── login_screen.dart            # Main login screen
└── widgets/
    ├── phone_input_field.dart       # Custom phone input widget
    ├── password_input_field.dart    # Custom password input widget
    └── login_button.dart            # Custom login button widget
```

**File Purposes:**
- `login_bloc.dart`: Manages state and business logic for login flow
- `login_event.dart`: Defines all possible events in login flow
- `login_state.dart`: Defines all possible states of login screen
- `login_screen.dart`: Main screen widget for login
- Custom widgets for reusable UI components

## 2. Dependencies Required

```yaml
dependencies:
  # State Management
  flutter_bloc: ^9.0.0
  equatable: ^2.0.7

  # Network & API
  dio: ^5.4.0
  internet_connection_checker: ^1.0.0+1

  # Local Storage
  flutter_secure_storage: ^9.0.0
  shared_preferences: ^2.5.2

  # Validation & Formatting
  phone_number: ^2.0.1
  form_validator: ^2.1.1

  # UI Components
  flutter_svg: ^2.0.17

dev_dependencies:
  # Testing
  bloc_test: ^9.1.5
  mockito: ^5.4.4
```

## 3. Testing Structure

### 3.1 Unit Tests
```
test/features/auth/
├── data/
│   ├── datasources/
│   │   ├── auth_remote_datasource_test.dart
│   │   └── auth_local_datasource_test.dart
│   └── repositories/
│       └── auth_repository_impl_test.dart
├── domain/
│   └── usecases/
│       ├── login_usecase_test.dart
│       └── validate_phone_usecase_test.dart
└── presentation/
    └── bloc/
        └── login_bloc_test.dart
```

### 3.2 Widget Tests
```
test/features/auth/presentation/
├── screens/
│   └── login_screen_test.dart
└── widgets/
    ├── phone_input_field_test.dart
    ├── password_input_field_test.dart
    └── login_button_test.dart
```

### 3.3 Integration Tests
```
integration_test/
└── login_flow_test.dart
```

## 4. Luồng xử lý chính

1. **Khởi tạo màn hình**:
   - Setup UI components
   - Initialize BLoC
   - Load saved credentials (if any)

2. **Validate Input**:
   - Phone number format validation
   - Password requirements check
   - Form completion check

3. **Xử lý Login**:
   - Submit credentials
   - Handle API response
   - Store authentication token
   - Navigate based on response

4. **Error Handling**:
   - Network errors
   - Invalid credentials
   - Validation errors
   - Server errors

5. **Navigation Flow**:
   - Success → Profile List Screen
   - Forgot Password → Password Recovery Screen
   - Register → Registration Screen

## 5. Implementation Strategy

### Phase 1: Setup & Infrastructure (2 days)
1. Create file structure
2. Add dependencies
3. Setup basic routing
4. Configure DI

### Phase 2: Data Layer (2 days)
1. Implement API client
2. Create data models
3. Implement local storage
4. Setup repository

### Phase 3: Domain Layer (1 day)
1. Create entities
2. Define interfaces
3. Implement use cases

### Phase 4: Presentation Layer (3 days)
1. Implement BLoC
2. Create UI components
3. Add form validation
4. Implement error handling

### Phase 5: Testing & Refinement (2 days)
1. Write unit tests
2. Add widget tests
3. Integration testing
4. Performance optimization

### Phase 6: Documentation & Cleanup (1 day)
1. Add documentation
2. Code cleanup
3. Review performance
4. Final testing

# Registration Screen Implementation Structure

## 1. Implementation Structure

### 1.1 Data Layer
```
lib/features/auth/data/
├── datasources/
│   ├── registration_remote_datasource.dart    # Handle API calls for registration
│   └── registration_local_datasource.dart     # Manage local storage for registration data
├── models/
│   ├── registration_request_model.dart        # Request model for registration API
│   ├── registration_response_model.dart       # Response model from registration API
│   └── user_profile_model.dart               # User profile data model
└── repositories/
    └── registration_repository_impl.dart      # Implementation of registration repository
```

**File Purposes:**
- `registration_remote_datasource.dart`: 
  - Handles API calls for user registration
  - Manages OTP verification requests
  - Handles device registration with backend
  
- `registration_local_datasource.dart`:
  - Stores temporary registration data
  - Manages registration progress state
  - Caches user input during multi-step registration

- `registration_request_model.dart`:
  - Defines registration API request structure
  - Includes phone, password, name, device info
  - Handles request data validation

- `registration_response_model.dart`:
  - Defines API response structure
  - Includes user data, tokens, status
  - Handles response parsing and validation

- `user_profile_model.dart`:
  - Models user profile data
  - Handles data transformation
  - Maps between API and domain models

- `registration_repository_impl.dart`:
  - Implements registration repository interface
  - Coordinates between data sources
  - Handles error mapping and recovery

### 1.2 Domain Layer
```
lib/features/auth/domain/
├── entities/
│   ├── user_profile.dart                    # User profile entity
│   └── registration_result.dart             # Registration result entity
├── repositories/
│   └── registration_repository.dart         # Repository interface
└── usecases/
    ├── register_user_usecase.dart          # User registration logic
    ├── verify_phone_usecase.dart           # Phone verification logic
    ├── validate_user_input_usecase.dart    # Input validation logic
    └── create_user_profile_usecase.dart    # Profile creation logic
```

**File Purposes:**
- `user_profile.dart`:
  - Core business entity for user data
  - Independent of data layer models
  - Contains essential user properties

- `registration_result.dart`:
  - Entity representing registration outcome
  - Contains success/failure status
  - Includes relevant registration data

- `registration_repository.dart`:
  - Defines registration operation contracts
  - Specifies required repository methods
  - Establishes error handling protocol

- `register_user_usecase.dart`:
  - Orchestrates registration process
  - Implements registration business rules
  - Handles registration flow control

- `verify_phone_usecase.dart`:
  - Manages phone verification workflow
  - Handles OTP request and verification
  - Implements retry and timeout logic

- `validate_user_input_usecase.dart`:
  - Implements input validation rules
  - Handles real-time validation
  - Manages validation error states

- `create_user_profile_usecase.dart`:
  - Handles profile creation after registration
  - Manages profile data validation
  - Coordinates profile setup process

### 1.3 Presentation Layer
```
lib/features/auth/presentation/
├── bloc/
│   ├── registration_bloc.dart             # State management for registration
│   ├── registration_event.dart            # Registration events
│   └── registration_state.dart            # Registration states
├── screens/
│   ├── registration_screen.dart           # Main registration screen
│   └── phone_verification_screen.dart     # OTP verification screen
└── widgets/
    ├── registration_form.dart             # Registration form widget
    ├── phone_input_field.dart            # Phone input widget
    ├── password_input_field.dart         # Password input widget
    ├── verification_code_input.dart      # OTP input widget
    └── registration_button.dart          # Submit button widget
```

**File Purposes:**
- `registration_bloc.dart`:
  - Manages registration state
  - Handles user interactions
  - Coordinates with use cases

- `registration_event.dart`:
  - Defines all registration events
  - Handles form submissions
  - Manages verification events

- `registration_state.dart`:
  - Defines registration UI states
  - Manages loading states
  - Handles error states

- `registration_screen.dart`:
  - Main registration UI
  - Manages form layout
  - Handles navigation

- `phone_verification_screen.dart`:
  - OTP verification UI
  - Manages verification flow
  - Handles resend functionality

- Custom widgets:
  - Reusable form components
  - Input validation feedback
  - Custom styled elements

## 2. Dependencies Required

```yaml
dependencies:
  # State Management
  flutter_bloc: ^9.0.0
  equatable: ^2.0.7

  # Network & API
  dio: ^5.4.0
  internet_connection_checker: ^1.0.0+1

  # Local Storage
  flutter_secure_storage: ^9.0.0
  shared_preferences: ^2.5.2

  # Validation & Formatting
  phone_number: ^2.0.1
  form_validator: ^2.1.1
  email_validator: ^2.1.17

  # UI Components
  flutter_svg: ^2.0.17
  pin_code_fields: ^8.0.1

  # Device Info
  device_info_plus: ^11.3.0
  android_id: ^0.4.0
  uuid: ^4.5.1

dev_dependencies:
  # Testing
  bloc_test: ^9.1.5
  mockito: ^5.4.4
```

## 3. Testing Structure

### 3.1 Unit Tests
```
test/features/auth/
├── data/
│   ├── datasources/
│   │   ├── registration_remote_datasource_test.dart
│   │   └── registration_local_datasource_test.dart
│   └── repositories/
│       └── registration_repository_impl_test.dart
├── domain/
│   └── usecases/
│       ├── register_user_usecase_test.dart
│       ├── verify_phone_usecase_test.dart
│       └── validate_user_input_usecase_test.dart
└── presentation/
    └── bloc/
        └── registration_bloc_test.dart
```

### 3.2 Widget Tests
```
test/features/auth/presentation/
├── screens/
│   ├── registration_screen_test.dart
│   └── phone_verification_screen_test.dart
└── widgets/
    ├── registration_form_test.dart
    ├── phone_input_field_test.dart
    └── verification_code_input_test.dart
```

### 3.3 Integration Tests
```
integration_test/
└── registration_flow_test.dart
```

## 4. Luồng xử lý chính

1. **Khởi tạo Registration**:
   - Setup form components
   - Initialize BLoC
   - Configure validation rules

2. **Validate Input**:
   - Real-time phone format validation
   - Password strength requirements
   - Name format validation
   - Form completion check

3. **Phone Verification**:
   - Send OTP request
   - Handle OTP input
   - Manage resend timer
   - Verify OTP with backend

4. **User Registration**:
   - Submit registration data
   - Handle API response
   - Create user profile
   - Store authentication tokens

5. **Error Handling**:
   - Network connectivity issues
   - Invalid input handling
   - API error responses
   - OTP verification failures

6. **Navigation Flow**:
   - Success → Profile Creation
   - Phone Verification → OTP Screen
   - Back → Login Screen

## 5. Implementation Strategy

### Phase 1: Setup & Infrastructure (2 days)
1. Create file structure
2. Add dependencies
3. Setup basic routing
4. Configure API endpoints

### Phase 2: Data Layer (3 days)
1. Implement API client
2. Create data models
3. Setup local storage
4. Implement repository

### Phase 3: Domain Layer (2 days)
1. Define entities
2. Create interfaces
3. Implement use cases
4. Setup validation rules

### Phase 4: Presentation Layer (4 days)
1. Implement BLoC
2. Create UI components
3. Build form validation
4. Add phone verification
5. Implement error handling

### Phase 5: Testing & Refinement (3 days)
1. Write unit tests
2. Add widget tests
3. Create integration tests
4. Performance optimization

### Phase 6: Documentation & Cleanup (1 day)
1. Add documentation
2. Code cleanup
3. Review performance
4. Final testing