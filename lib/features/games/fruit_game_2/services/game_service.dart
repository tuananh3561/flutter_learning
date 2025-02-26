import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/enums/game_status.dart';
import '../models/fruit.dart';
import '../models/game_state.dart';
import '../models/question.dart';

class GameService extends ChangeNotifier {
  final Random _random = Random();
  final List<Fruit> availableFruits;
  final int questionsPerRound;

  GameState _state;

  GameService({
    required this.availableFruits,
    this.questionsPerRound = 2, // Default from use case
  }) : _state = GameState.initial(questionsPerRound);

  // Getters
  GameState get state => _state;
  Question? get currentQuestion => _state.currentQuestion;
  bool get isGameCompleted => _state.isGameCompleted;
  int get score => _state.score;

  // Game initialization
  void startGame() {
    if (availableFruits.length < 2) {
      throw Exception(
          'Not enough fruits available. At least 2 fruits are required.');
    }

    final List<Question> questions = _generateQuestions();

    _state = _state.copyWith(
      status: GameStatus.playing,
      questions: questions,
      currentQuestionIndex: 0,
      score: 0,
    );

    notifyListeners();
  }

  // Generate questions for the game
  List<Question> _generateQuestions() {
    final List<Question> questions = [];
    final List<Fruit> usedFruits = [];

    // We'll generate enough questions for the full round
    for (int i = 0; i < questionsPerRound; i++) {
      // Get two different fruits
      List<Fruit> questionFruits = _getTwoRandomFruits(usedFruits);
      usedFruits.addAll(questionFruits);

      // Determine which fruit will be displayed
      final displayedFruit = questionFruits[0];
      final correctFruit =
          questionFruits[0]; // The displayed fruit is the correct one
      final incorrectFruit = questionFruits[1];

      questions.add(Question(
        correctFruit: correctFruit,
        incorrectFruit: incorrectFruit,
        displayedFruit: displayedFruit,
      ));

      // If we've used all fruits, reset the used fruits list
      if (usedFruits.length >= availableFruits.length - 1) {
        usedFruits.clear();
      }
    }

    return questions;
  }

  // Helper method to get two different random fruits
  List<Fruit> _getTwoRandomFruits(List<Fruit> usedFruits) {
    // Filter out already used fruits if possible
    List<Fruit> availableFruitsForQuestion =
        availableFruits.where((fruit) => !usedFruits.contains(fruit)).toList();

    // If we don't have enough unused fruits, use the full list
    if (availableFruitsForQuestion.length < 2) {
      availableFruitsForQuestion = List.from(availableFruits);
    }

    // Pick the first fruit randomly
    final int firstIndex = _random.nextInt(availableFruitsForQuestion.length);
    final Fruit firstFruit = availableFruitsForQuestion[firstIndex];

    // Remove the first fruit from the list to avoid duplicates
    availableFruitsForQuestion.removeAt(firstIndex);

    // Pick the second fruit randomly from the remaining fruits
    final int secondIndex = _random.nextInt(availableFruitsForQuestion.length);
    final Fruit secondFruit = availableFruitsForQuestion[secondIndex];

    return [firstFruit, secondFruit];
  }

  // Validate the player's answer
  bool validateAnswer(Fruit selectedFruit) {
    final currentQuestion = _state.currentQuestion;
    if (currentQuestion == null || currentQuestion.isAnswered) {
      return false;
    }

    final bool isCorrect = selectedFruit.id == currentQuestion.correctFruit.id;

    // Update the current question
    currentQuestion.isAnswered = true;
    currentQuestion.isCorrect = isCorrect;

    // Update the game state
    _state = _state.copyWith(
      score: isCorrect ? _state.score + 1 : _state.score,
    );

    notifyListeners();
    return isCorrect;
  }

  // Move to the next question
  void moveToNextQuestion() {
    if (_state.isGameCompleted) {
      completeGame();
      return;
    }

    _state = _state.copyWith(
      currentQuestionIndex: _state.currentQuestionIndex + 1,
    );

    if (_state.isGameCompleted) {
      completeGame();
      return;
    }

    notifyListeners();
  }

  // Complete the game
  void completeGame() {
    _state = _state.copyWith(
      status: GameStatus.completed,
    );

    notifyListeners();
  }

  // Reset the game
  void resetGame() {
    _state = GameState.initial(questionsPerRound);
    notifyListeners();
  }

  // Helper methods for UI components

  // Get the fruit to display in the current question
  Fruit? getDisplayedFruit() {
    final currentQuestion = _state.currentQuestion;
    return currentQuestion?.displayedFruit;
  }

  // Get the correct fruit sound for the current question
  Fruit? getCorrectFruit() {
    final currentQuestion = _state.currentQuestion;
    return currentQuestion?.correctFruit;
  }

  // Get the incorrect fruit sound for the current question
  Fruit? getIncorrectFruit() {
    final currentQuestion = _state.currentQuestion;
    return currentQuestion?.incorrectFruit;
  }

  // Shuffle the options to present to the player
  List<Fruit> getShuffledOptions() {
    final currentQuestion = _state.currentQuestion;
    if (currentQuestion == null) {
      return [];
    }

    final options = [
      currentQuestion.correctFruit,
      currentQuestion.incorrectFruit,
    ];

    // Shuffle the options
    options.shuffle(_random);

    return options;
  }
}
