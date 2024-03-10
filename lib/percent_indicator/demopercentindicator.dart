import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DemoPercentIndicator extends StatefulWidget {
  const DemoPercentIndicator({super.key});

  @override
  State<DemoPercentIndicator> createState() => _DemoPercentIndicatortState();
}

class _DemoPercentIndicatortState extends State<DemoPercentIndicator> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularProgressIndicator(
              value: 0.3,
              strokeWidth: 20,
              strokeAlign: 3,
              backgroundColor: Colors.deepPurple,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeCap: StrokeCap.round,
              semanticsLabel: 'Circular progress indicator',
              semanticsValue: '30%',
            ),
            LinearProgressIndicator(
              minHeight: 40,
              value: 0.3,
              backgroundColor: Colors.deepPurple,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              semanticsLabel: 'Linear progress indicator',
              semanticsValue: '30%',
            ),
          ],
        ),
      ),
    );
  }
}
