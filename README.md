# flappy_dash

A new Flutter project.

lib/
├── core/
│   ├── config/                 # App configurations
│   ├── constants/              # App constants
│   ├── di/                     # Dependency injection setup
│   ├── network/                # Network handling
│   │   ├── api_client.dart
│   │   └── interceptors/
│   ├── storage/               # Local storage handling
│   └── theme/                 # App theming
│
├── features/
│   ├── auth/                  # Authentication feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── games/                 # Games module
│   │   ├── base/             # Base game architecture
│   │   │   ├── core/
│   │   │   ├── interfaces/
│   │   │   └── components/
│   │   │
│   │   ├── commons/          # Shared game components
│   │   │   ├── audio/
│   │   │   ├── sprites/
│   │   │   └── effects/
│   │   │
│   │   ├── egg_game/         # Egg tapping game
│   │   │   ├── components/
│   │   │   │   ├── egg.dart
│   │   │   │   ├── word.dart
│   │   │   │   └── effects/
│   │   │   ├── screens/
│   │   │   ├── controllers/
│   │   │   └── models/
│   │   │
│   │   ├── card_game/        # Card flipping game
│   │   └── quiz_game/        # Quiz game
│   │   └── flip_card/        # Flip card game
│   │
│   ├── profile/              # User profile feature
│   └── settings/             # App settings feature
│
├── shared/
│   ├── widgets/              # Shared widgets
│   ├── utils/                # Utility functions
│   ├── models/               # Shared data models
│   └── services/             # Shared services
│
└── routes/                   # App routing

 generate code:
 ```
 flutter pub run build_runner build --delete-conflicting-outputs
```