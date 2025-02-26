import 'package:flame/components.dart';
import '../levels/level_data.dart';

class GameManager extends Component {
  int score = 0;
  int currentLevelIndex = 0;
  int attemptsLeft = levels[0].maxAttempts;
  bool gameOver = false;

  LevelData get currentLevel => levels[currentLevelIndex];

  void onCorrectWordSelected() {
    score++;
    _nextLevel();
  }

  void onIncorrectWordSelected() {
    attemptsLeft--;
    if (attemptsLeft <= 0) {
      gameOver = true;
    }
  }

  void _nextLevel() {
    if (currentLevelIndex < levels.length - 1) {
      currentLevelIndex++;
      attemptsLeft = currentLevel.maxAttempts;
    } else {
      gameOver = true;
    }
  }

  void reset() {
    score = 0;
    currentLevelIndex = 0;
    attemptsLeft = levels[0].maxAttempts;
    gameOver = false;
  }

  void update(double dt) {
    //... cập nhật.
  }
}
