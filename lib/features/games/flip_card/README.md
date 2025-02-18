# 1. GAME ACTIONS:

| ID | Actor      | Target                    | Action                                           | Time (ms) |
|----|------------|---------------------------|--------------------------------------------------|-----------|
| 1  | System     | Logo                      | Move from off-screen to center from left to right| 2000      |
| 2  | System     | Game Title Sound          | Play sound                                       | 1000      |
| 3  | System     | Logo                      | Move from center to off-screen right             | 2000      |
| 4  | System     | Cards                     | Display 6 cards in grid layout (3x2)             | 500       |
| 5  | System     | Cards                     | Initial animation showing all cards face down    | 1000      |
| 6  | System     | Game Start Sound          | Play start sound                                 | 1000      |
| 7  | User       | Card                      | Tap first card                                   | -         |
| 8  | System     | Card                      | Flip animation for first selected card           | 500       |
| 9  | System     | Card Flip Sound           | Play card flip sound                             | 200       |
| 10 | User       | Card                      | Tap second card                                  | -         |
| 11 | System     | Card                      | Flip animation for second selected card          | 500       |
| 12 | System     | Card Flip Sound           | Play card flip sound                             | 200       |
| 13 | System     | Cards                     | Check if selected cards match                    | 300       |
| 14 | System     | Non-matching Cards        | Flip back animation                              | 500       |
| 15 | System     | Card Flip Sound           | Play card flip sound for non-match               | 200       |
| 16 | System     | Matching Cards            | Fade out animation                               | 800       |
| 17 | System     | Match Image               | Move matched image to screen center              | 500       |
| 18 | System     | Match Sound               | Play sound for matched word (e.g., "dog")        | 1000      |
| 19 | System     | Match Image               | Display matched image in center                  | 3000      |
| 20 | System     | Match Image               | Fade out matched image                           | 500       |
| 21 | System     | Game State                | Check if all pairs are matched                   | 300       |
| 22 | System     | Victory Sound             | Play victory sound when game complete            | 2000      |
| 23 | System     | Game Elements             | Fade out all game elements                       | 1000      |

# 2. SCENE FLOW:

| Scene           | Action                 | Trigger Condition                              |
|-----------------|------------------------|------------------------------------------------|
| **Intro Phase** | 1 -> 2 -> 3            | Game start                                     |
|                 | 4 -> 5 -> 6            | After logo animation completes                 |
| **Play Phase**  | 7 -> 8 -> 9            | User selects first card                        |
|                 | 10 -> 11 -> 12         | User selects second card                       |
|                 | 13                     | After second card selection                    |
| **Match Phase** | 14 -> 15               | If cards don't match                           |
|                 | 16 -> 17 -> 18 -> 19   | If cards match                                 |
|                 | 20                     | After match display timer complete             |
| **Loop Phase**  | Return to Play Phase   | If game not complete                           |
| **End Phase**   | 21 -> 22 -> 23         | All pairs matched                              |


# Use Case Analysis - Flip Card Game

## 1. Primary Actors
- Player (Primary User)
- System (Game Engine)

## 2. Main Use Cases

### UC1: Start Game
**Primary Actor**: System
**Description**: Initialize and display the game interface
**Preconditions**: None
**Main Flow**:
1. System displays logo animation
2. System plays game title sound
3. System removes logo
4. System initializes 6 cards in a 3x2 grid
5. System performs initial card placement animation
6. System plays game start sound

**Post-conditions**: 
- All cards are face down and ready for interaction
- Game state is initialized

### UC2: Select First Card
**Primary Actor**: Player
**Description**: Player selects their first card of a potential pair
**Preconditions**: 
- Game is initialized
- No cards are currently selected
**Main Flow**:
1. Player taps on a face-down card
2. System plays flip animation
3. System plays flip sound
4. System reveals card image
5. System marks card as "selected"

**Post-conditions**:
- One card is face up
- Player can select a second card

### UC3: Select Second Card
**Primary Actor**: Player
**Description**: Player selects second card to complete a potential pair
**Preconditions**: 
- One card is already selected
- Selected card is face up
**Main Flow**:
1. Player taps on a different face-down card
2. System plays flip animation
3. System plays flip sound
4. System reveals card image
5. System initiates pair matching check

**Alternative Flow**:
- If player selects same card as first selection, no action occurs

### UC4: Process Matching Pairs
**Primary Actor**: System
**Description**: System processes matched pair of cards
**Preconditions**: 
- Two cards are selected
- Cards have matching images
**Main Flow**:
1. System identifies matching pair
2. System fades out both cards
3. System moves matched image to screen center
4. System plays corresponding sound (e.g., "dog")
5. System displays image for 3 seconds
6. System fades out centered image
7. System updates game progress

**Post-conditions**:
- Matched cards are removed from play
- Game state is updated
- Player can select new cards

### UC5: Process Non-Matching Pairs
**Primary Actor**: System
**Description**: System handles non-matching card selections
**Preconditions**: 
- Two cards are selected
- Cards do not have matching images
**Main Flow**:
1. System identifies non-matching pair
2. System plays flip animation to return cards face down
3. System plays flip sound
4. System resets card selection state

**Post-conditions**:
- Both cards are face down
- No cards are selected
- Player can make new selections

### UC6: Complete Game
**Primary Actor**: System
**Description**: System handles game completion
**Preconditions**: 
- All pairs have been matched
**Main Flow**:
1. System checks for game completion
2. System plays victory sound
3. System fades out all game elements

**Post-conditions**:
- Game is complete
- All pairs are matched
- Display is cleared

## 3. Business Rules

1. Card Display Rules:
   - Exactly 6 cards must be displayed
   - Cards must be arranged in a 3x2 grid
   - Each image must appear exactly twice

2. Card Selection Rules:
   - Only face-down cards can be selected
   - Player cannot select same card twice
   - Maximum of two cards can be face-up at once

3. Matching Rules:
   - Matching pairs must have identical images
   - Matched pairs are removed from play
   - Non-matching pairs are returned face down

4. Sound Rules:
   - Each action type has a specific sound
   - Matched pairs play corresponding word sound
   - Sound effects cannot overlap

5. Timing Rules:
   - Matched image display lasts exactly 3 seconds
   - Card flip animations must complete before next action
   - All animations must be interruptible for game flow

## 4. Exception Cases

1. **Rapid Card Selection**
   - System must queue card selections if player taps rapidly
   - Animations must complete in sequence

2. **Sound Interruption**
   - System must handle sound interruption gracefully
   - New sounds should override current playing sounds

3. **Memory Management**
   - System must properly manage memory for image/sound assets
   - Resources should be loaded/unloaded efficiently

4. **Device Orientation Changes**
   - Grid layout must maintain integrity
   - Animations must handle orientation changes gracefully

5. **Touch Input Issues**
   - System must handle multi-touch scenarios
   - System must handle missed/phantom touches


# Project Structure - Flip Card Game

```
lib/
├── core/
│   ├── constants/
│   │   ├── asset_paths.dart
│   │   └── game_constants.dart
│   ├── services/
│   │   ├── audio_service.dart
│   │   └── storage_service.dart
│   └── utils/
│       ├── animations.dart
│       └── extensions.dart
│
├── features/
│   └── games/
│       └── flip_card/
│           ├── data/
│           │   ├── datasources/
│           │   │   └── card_datasource.dart
│           │   ├── models/
│           │   │   ├── card_model.dart
│           │   │   └── game_state_model.dart
│           │   └── repositories/
│           │       └── card_repository_impl.dart
│           │
│           ├── domain/
│           │   ├── entities/
│           │   │   ├── card_entity.dart
│           │   │   ├── card_pair.dart
│           │   │   └── game_state.dart
│           │   ├── repositories/
│           │   │   └── card_repository.dart
│           │   └── usecases/
│           │       ├── check_card_match_usecase.dart
│           │       ├── flip_card_usecase.dart
│           │       ├── initialize_game_usecase.dart
│           │       └── process_match_usecase.dart
│           │
│           ├── presentation/
│           │   ├── flame/
│           │   │   ├── components/
│           │   │   │   ├── card_component.dart
│           │   │   │   ├── game_background_component.dart
│           │   │   │   └── match_display_component.dart 
│           │   │   ├── systems/
│           │   │   │   ├── card_animation_system.dart
│           │   │   │   └── input_system.dart
│           │   │   └── flip_card_game.dart
│           │   │
│           │   ├── bloc/
│           │   │   ├── game_bloc.dart
│           │   │   ├── game_event.dart
│           │   │   └── game_state.dart
│           │   │
│           │   ├── widgets/
│           │   │   ├── card_grid.dart
│           │   │   ├── game_hud.dart
│           │   │   └── match_display.dart
│           │   │
│           │   └── screens/
│           │       └── flip_card_screen.dart
│           │
│           └── config/
│               ├── game_config.dart
│               └── level_config.dart
```

## Directory Structure Details

### 1. Core Layer
Contains application-wide shared code and utilities.

**constants/**
- `asset_paths.dart`: Paths to images, sounds, and other assets
- `game_constants.dart`: Game-specific constants like timings, grid size

**services/**
- `audio_service.dart`: Handles sound effects and audio playback
- `storage_service.dart`: Manages local storage for game state

**utils/**
- `animations.dart`: Shared animation utilities
- `extensions.dart`: Extension methods

### 2. Features/Games/Flip Card Layer

#### Data Layer
Handles data operations and external interfaces.

**datasources/**
- `card_datasource.dart`: Source for card data (images, sounds)

**models/**
- `card_model.dart`: Data model for cards
- `game_state_model.dart`: Data model for game state

**repositories/**
- `card_repository_impl.dart`: Implementation of card repository

#### Domain Layer
Contains business logic and rules.

**entities/**
- `card_entity.dart`: Core card entity
- `card_pair.dart`: Represents a pair of cards
- `game_state.dart`: Game state entity

**repositories/**
- `card_repository.dart`: Repository interface

**usecases/**
- `check_card_match_usecase.dart`: Check if selected cards match
- `flip_card_usecase.dart`: Handle card flip logic
- `initialize_game_usecase.dart`: Setup game state
- `process_match_usecase.dart`: Process matched cards

#### Presentation Layer
Handles UI and user interaction.

**flame/**
- **components/**
  - `card_component.dart`: Flame component for cards
  - `game_background_component.dart`: Background rendering
  - `match_display_component.dart`: Matched pair display
- **systems/**
  - `card_animation_system.dart`: Card animation system
  - `input_system.dart`: Handle user input
- `flip_card_game.dart`: Main Flame game class

**bloc/**
- `game_bloc.dart`: Game state management
- `game_event.dart`: Game events
- `game_state.dart`: UI state

**widgets/**
- `card_grid.dart`: Card grid layout
- `game_hud.dart`: Game HUD elements
- `match_display.dart`: Match animation display

**screens/**
- `flip_card_screen.dart`: Main game screen

#### Config Layer
Game configuration and settings.

- `game_config.dart`: Game configuration
- `level_config.dart`: Level-specific settings

## Key Implementation Notes

1. **Game State Management**
   - Use BLoC for overall game state
   - Flame components for real-time animations
   - Clear separation between game logic and rendering

2. **Asset Management**
   - Centralized asset paths
   - Preload assets during initialization
   - Efficient memory management

3. **Animation System**
   - Card flip animations
   - Match display animations
   - Smooth transitions

4. **Input Handling**
   - Touch input through Flame
   - Debounce rapid taps
   - Handle multi-touch scenarios

5. **Sound System**
   - Background music
   - Card flip sounds
   - Match sounds
   - Victory sounds