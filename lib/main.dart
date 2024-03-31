import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // VARIABLES: You can store different types of data in variables.
  String name = "John Doe";
  int age = 30;
  double pi = 3.14;
  bool isBeginner = true;

  /*
  BASIC MATH OPERATIONS:
  1 + 1 -> 2 , add
  4 - 1 -> 3 , subtract
  2 * 3 -> 6 , munltiply
  8 / 2 -> 4 , divide
  9 % 4 -> 1 , remainder
  5++ -> 6 , increment
  5-- -> 4 , decrement

  COMPARISON OPERATORS:
  5 == 5 -> true , equal to
  2 != 5 -> true , not equal to
  3 > 2 -> true , greater than
  3 < 2 -> false , less than
  5 >= 5 -> true , greater than or equal to
  3 <= 2 -> false , less than or equal to

  LOGICAL OPERATORS:  
  AND operator, returns true if both sides are true
  isBeginner && ( age > 18 ) -> return true

  OR operator, returns true if one side is true
  isBeginner || ( age < 18 ) -> return true

  NOT operator, returns the opposite of the value
  !isBeginner -> return false

  ------------------------------------------------

  C O N T R O L F L O W

  if (condition) {
    // code to run if condition is true
  }

  if (condition) {
    // code to run if condition is true
  } else {
    // code to run if condition is false
  }

  switch (expression) {
    case value1:
      // code to run if expression is value1
      break;
    case value2:
      // code to run if expression is value2
      break;
    default:
      // code to run if expression is not any of the above
  }

  for loop
  for (initialization; condition; increment) {
    // code to run
  }

  while loop
  while (condition) {
    // code to run
  }

  do while loop
  do {
    // code to run
  } while (condition);

  break -> breaks out of a loop
  continue -> skips the current iteration of a loop

  ------------------------------------------------

  F U N C T I O N S / M E T H O D S

  */

  // basic function
  void greet() {
    print("Hello, John Doe");
  }

  // function with parameters
  void greetPerson(String name) {
    print("Hello, $name");
  }

  // function with return type
  int add(int a, int b) {
    return a + b;
  }

  /*
  ------------------------------------------------

  D A T A S T R U C T U R E S

  */

  // LIST: ordered collection of elements, can have duplicates
  List<int> numbers = [1, 2, 3, 4, 5];
  // numbers[0] -> 1
  // numbers[1] -> 2
  // numbers[2] -> 3
  // numbers[3] -> 4
  // numbers[4] -> 5

  void printNumbers() {
    for (int i = 0; i < numbers.length; i++) {
      print(numbers[i]);
    }
  }

  List<String> names = [
    "John",
    "Jane",
    "Doe",
    "Jane",
  ];
  // names[0] -> John
  // names[1] -> Jane
  // names[2] -> Doe
  // names[3] -> Jane

  // SET: underordered collection of unique elements
  Set<String> uniqueNames = {"John", "Jane", "Doe"};

  // MAP: collection of key-value pairs
  Map user = {
    "name": "John Doe",
    "age": 30,
    "isBeginner": true,
  };
  // user["name"] -> John Doe
  // user["age"] -> 30
  // user["isBeginner"] -> true

  void printNames() {
    for (int i = 0; i < names.length; i++) {
      print(names[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(),
    );
  }
}
