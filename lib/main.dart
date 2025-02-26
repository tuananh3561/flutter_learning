import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_learning/features/games/game_selection_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Tắt kiểm tra loại Provider để tránh lỗi với GameService và AIService
  Provider.debugCheckInvalidValueType = null;

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Games',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo),
        useMaterial3: true,
      ),
      home: const GameSelectionScreen(),
    );
  }
}
