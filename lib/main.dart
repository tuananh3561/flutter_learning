import 'package:flutter/material.dart';
import 'package:flutter_learning/percent_indicator/demopercentindicator.dart';
// import 'package:flutter_learning/avatar_glow/demoavatarglow.dart';
// import 'package:flutter_learning/google_fonts/demogooglefonts.dart';
// import 'package:flutter_learning/liquid_pull_to_refresh/demoliquidpulltorefresh.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      // home: const DemoAvatarGlow(),
      // home: DemoGoogleFonts(),
      // home: DemoLiquidPullToRefresh(),
      home: DemoPercentIndicator(),
    );
  }
}
