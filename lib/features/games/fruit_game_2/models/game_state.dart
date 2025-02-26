import 'enums/game_status.dart';
import 'question.dart';

class GameState {
  final GameStatus status;
  final List<Question> questions;
  final int currentQuestionIndex;
  final int score;
  final int totalQuestions;

  const GameState({
    required this.status,
    required this.questions,
    required this.currentQuestionIndex,
    required this.score,
    required this.totalQuestions,
  });

  factory GameState.initial(int totalQuestions) {
    return GameState(
      status: GameStatus.initial,
      questions: [],
      currentQuestionIndex: 0,
      score: 0,
      totalQuestions: totalQuestions,
    );
  }

  GameState copyWith({
    GameStatus? status,
    List<Question>? questions,
    int? currentQuestionIndex,
    int? score,
    int? totalQuestions,
  }) {
    return GameState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
    );
  }

  Question? get currentQuestion {
    if (currentQuestionIndex < questions.length) {
      return questions[currentQuestionIndex];
    }
    return null;
  }

  bool get isGameCompleted => currentQuestionIndex >= totalQuestions;
}
