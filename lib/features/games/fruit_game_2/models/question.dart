import 'fruit.dart';

class Question {
  final Fruit correctFruit;
  final Fruit incorrectFruit;
  final Fruit displayedFruit;
  bool isAnswered = false;
  bool? isCorrect;

  Question({
    required this.correctFruit,
    required this.incorrectFruit,
    required this.displayedFruit,
  });
}
